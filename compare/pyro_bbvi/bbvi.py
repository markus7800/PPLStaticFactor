import pyro
import pyro.distributions as dist
import pyro.distributions.constraints as constraints
import pyro.distributions.transforms as transforms
from pyro.infer import SVI, Trace_ELBO, TraceGraph_ELBO
from pyro.infer.util import torch_item
from pyro.util import warn_if_nan
import torch
import pyro.poutine as poutine
from pyro.infer.util import zero_grads
from torchviz import make_dot
from typing import Optional

def getBack(var_grad_fn):
    print(var_grad_fn)
    for n in var_grad_fn.next_functions:
        if n[0]:
            try:
                tensor = getattr(n[0], 'variable')
                print(n[0])
                print('Tensor with grad found:', tensor)
                print(' - gradient:', tensor.grad)
                print()
            except AttributeError as e:
                getBack(n[0])

def maybe_clone(g):
    if g is None:
        return None
    else:
        return g.clone()
    
class VarTracking_SVI(SVI):
    def __init__(self, model, guide, optim, loss, L, n_iter, loss_and_grads=None, num_samples=0, num_steps=0, **kwargs):
        super().__init__(model, guide, optim, loss, loss_and_grads, num_samples, num_steps, **kwargs)
        self.avg_grads_var = dict()
        self.L = L
        self.n_iter = n_iter
        
    def step(self, *args, **kwargs):
        """
        :returns: estimate of the loss
        :rtype: float

        Take a gradient step on the loss function (and any auxiliary loss functions
        generated under the hood by `loss_and_grads`).
        Any args or kwargs are passed to the model and guide
        """
        # get loss and compute gradients
        with poutine.trace(param_only=True) as param_capture:
            loss, grads_var = self.loss_and_grads(self.model, self.guide, *args, **kwargs)
            for name, v in grads_var.items():
                if name not in self.avg_grads_var:
                    self.avg_grads_var[name] = torch.zeros_like(v)
                self.avg_grads_var[name] = self.avg_grads_var[name] + v / ((self.L - 1) * self.n_iter)

        params = set(
            site["value"].unconstrained() for site in param_capture.trace.nodes.values()
        )

        # actually perform gradient steps
        # torch.optim objects gets instantiated for any params that haven't been seen yet
        self.optim(params)

        # zero gradients
        zero_grads(params)

        if isinstance(loss, tuple):
            # Support losses that return a tuple, e.g. ReweightedWakeSleep.
            return type(loss)(map(torch_item, loss))
        else:
            return torch_item(loss)
        
from pyro.infer.trace_elbo import _compute_log_r, is_identically_zero
class VarTracking_Trace_ELBO(Trace_ELBO):
    def _differentiable_loss_particle(self, model_trace, guide_trace):
        elbo_particle = 0
        surrogate_elbo_particle = 0
        log_r = None

        # compute elbo and surrogate elbo
        for name, site in model_trace.nodes.items():
            if site["type"] == "sample":
                elbo_particle = elbo_particle + torch_item(site["log_prob_sum"])
                print("+log_prob_sum", site["log_prob_sum"])
                surrogate_elbo_particle = surrogate_elbo_particle + site["log_prob_sum"]

        for name, site in guide_trace.nodes.items():
            if site["type"] == "sample":
                log_prob, score_function_term, entropy_term = site["score_parts"]

                elbo_particle = elbo_particle - torch_item(site["log_prob_sum"])

                if not is_identically_zero(entropy_term):
                    print("-entropy_term", entropy_term.sum())
                    surrogate_elbo_particle = (
                        surrogate_elbo_particle - entropy_term.sum()
                    )

                if not is_identically_zero(score_function_term):
                    if log_r is None:
                        log_r = _compute_log_r(model_trace, guide_trace)
                    site = log_r.sum_to(site["cond_indep_stack"])
                    print("+log_r*score", log_r, site, score_function_term, site * score_function_term)
                    surrogate_elbo_particle = (
                        surrogate_elbo_particle + (site * score_function_term).sum()
                    )

        return -elbo_particle, -surrogate_elbo_particle
    
    def loss_and_grads(self, model, guide, *args, **kwargs):
        """
        :returns: returns an estimate of the ELBO
        :rtype: float

        Computes the ELBO as well as the surrogate ELBO that is used to form the gradient estimator.
        Performs backward on the latter. Num_particle many samples are used to form the estimators.
        """
        grads_mean = {}
        grads_var = {}
        
        loss = 0.0
        l = 0
        # grab a trace from the generator
        for model_trace, guide_trace in self._get_traces(model, guide, args, kwargs):
            l += 1
            
            loss_particle, surrogate_loss_particle = self._differentiable_loss_particle(
                model_trace, guide_trace
            )
            loss += loss_particle / self.num_particles

            # collect parameters to train from model and guide
            grads_before = {
                site["name"]: maybe_clone(site["value"].unconstrained().grad)
                for site in guide_trace.nodes.values() if site["type"] == "param"
            }
            # print(make_dot(guide_trace.nodes["x"]["score_parts"].entropy_term.sum()))

            surrogate_loss_particle = surrogate_loss_particle / self.num_particles
            # print(make_dot(surrogate_loss_particle, show_attrs=True, show_saved=False))
            surrogate_loss_particle.backward(retain_graph=self.retain_graph)
            # getBack(surrogate_loss_particle.grad_fn)
            
            print("params", {site["name"]: site["value"].unconstrained() for site in guide_trace.nodes.values() if site["type"] == "param"})
            print("samples", {site["name"]: site["value"] for site in guide_trace.nodes.values() if site["type"] == "sample"})
            print("score_parts", {site["name"]: site["score_parts"] for site in guide_trace.nodes.values() if site["type"] == "sample"})
            print("loss", loss_particle, surrogate_loss_particle*self.num_particles)
            
            grads_after = {
                site["name"]: maybe_clone(site["value"].unconstrained().grad)
                for site in guide_trace.nodes.values() if site["type"] == "param"
            }
            print("grads", grads_after)
            
            for name, grad_after in grads_after.items():
                grad_before = grads_before[name]
                grad_before = torch.tensor(0.) if grad_before is None else grad_before
                # print(grad_after, "-", grad_before)
                grad = (grad_after - grad_before) * self.num_particles # correct for surrogate_loss_particle = surrogate_loss_particle / self.num_particles above
                # print(name, grad)
                if name not in grads_mean:
                    grads_mean[name] = torch.zeros_like(grad)
                    grads_var[name] = torch.zeros_like(grad)
                
                new_value = grad
                old_mean = grads_mean[name]
                delta1 = new_value - old_mean
                new_mean = old_mean + delta1 / l
                delta2 = new_value - new_mean
                grads_mean[name] = new_mean
                grads_var[name] = grads_var[name] + delta1 * delta2
            
        warn_if_nan(loss, "loss")
        return loss, grads_var

from pyro.infer.tracegraph_elbo import defaultdict, MultiFrameTensor, get_provenance, is_identically_zero, _construct_baseline, detach_provenance
def _compute_elbo(model_trace, guide_trace):
    # In ref [1], section 3.2, the part of the surrogate loss computed here is
    # \sum{cost}, which in this case is the ELBO. Instead of using the ELBO,
    # this implementation uses a surrogate ELBO which modifies some entropy
    # terms depending on the parameterization. This reduces the variance of the
    # gradient under some conditions.

    elbo = 0.0
    surrogate_elbo = 0.0
    baseline_loss = 0.0
    # mapping from non-reparameterizable sample sites to cost terms influenced by each of them
    downstream_costs = defaultdict(lambda: MultiFrameTensor())

    # Bring log p(x, z|...) terms into both the ELBO and the surrogate
    print("Model")
    for name, site in model_trace.nodes.items():
        if site["type"] == "sample":
            elbo += site["log_prob_sum"]
            surrogate_elbo += site["log_prob_sum"]
            print(name, site["value"], "surrogate_elbo +=", site["log_prob_sum"])
            # add the log_prob to each non-reparam sample site upstream
            for key in get_provenance(site["log_prob_sum"]):
                downstream_costs[key].add((site["cond_indep_stack"], site["log_prob"]))
                print(name, f"downstream_costs[{key}] +=", site["log_prob"])
    #         print(name, get_provenance(site["log_prob_sum"]))
    # exit()
    print()

    # Bring log q(z|...) terms into the ELBO, and effective terms into the
    # surrogate. Depending on the parameterization of a site, its log q(z|...)
    # cost term may not contribute (in expectation) to the gradient. To reduce
    # the variance under some conditions, the default entropy terms from
    # site[`score_parts`] are used.
    print("Guide")
    for name, site in guide_trace.nodes.items():
        if site["type"] == "sample":
            elbo -= site["log_prob_sum"]
            entropy_term = site["score_parts"].entropy_term
            # For fully reparameterized terms, this entropy_term is log q(z|...)
            # For fully non-reparameterized terms, it is zero
            if not is_identically_zero(entropy_term):
                surrogate_elbo -= entropy_term.sum()
                print(name, "surrogate_elbo -= entropy_term", entropy_term.sum())
                
            # add the -log_prob to each non-reparam sample site upstream
            for key in get_provenance(site["log_prob_sum"]):
                downstream_costs[key].add((site["cond_indep_stack"], -site["log_prob"]))
                print(name, f"downstream_costs[{key}] -=", site["log_prob"])
    print()

    # construct all the reinforce-like terms.
    # we include only downstream costs to reduce variance
    # optionally include baselines to further reduce variance
    for node, downstream_cost in downstream_costs.items():
        guide_site = guide_trace.nodes[node]
        downstream_cost = downstream_cost.sum_to(guide_site["cond_indep_stack"])
        score_function = guide_site["score_parts"].score_function

        use_baseline, baseline_loss_term, baseline = _construct_baseline(
            node, guide_site, downstream_cost
        )
        print("use_baseline", use_baseline)

        if use_baseline:
            downstream_cost = downstream_cost - baseline
            baseline_loss = baseline_loss + baseline_loss_term

        surrogate_elbo += (score_function * downstream_cost.detach()).sum()
        print(node, f"surrogate_elbo +=", score_function, "*", downstream_cost)
    print()

    surrogate_loss = -surrogate_elbo + baseline_loss
    print("surrogate_loss", surrogate_loss)
    return detach_provenance(elbo), detach_provenance(surrogate_loss)

class VarTracking_TraceGraph_ELBO(TraceGraph_ELBO):
    
    def _loss_and_surrogate_loss_particle(self, model_trace, guide_trace):
        elbo, surrogate_loss = _compute_elbo(model_trace, guide_trace)

        return elbo, surrogate_loss
    
    def loss_and_grads(self, model, guide, *args, **kwargs):
        """
        :returns: returns an estimate of the ELBO
        :rtype: float

        Computes the ELBO as well as the surrogate ELBO that is used to form the gradient estimator.
        Performs backward on the latter. Num_particle many samples are used to form the estimators.
        If baselines are present, a baseline loss is also constructed and differentiated.
        """
        # elbo, surrogate_loss = self._loss_and_surrogate_loss(model, guide, args, kwargs)

        grads_mean = {}
        grads_var = {}
        
        elbo = 0.0
        surrogate_loss = 0.0

        l = 0
        for model_trace, guide_trace in self._get_traces(model, guide, args, kwargs):
            l += 1
            
            grads_before = {
                site["name"]: maybe_clone(site["value"].unconstrained().grad)
                for site in guide_trace.nodes.values() if site["type"] == "param"
            }
            
            lp, slp = self._loss_and_surrogate_loss_particle(model_trace, guide_trace)
            elbo += lp
            surrogate_loss += slp
            
            slp.backward()
            
            grads_after = {
                site["name"]: maybe_clone(site["value"].unconstrained().grad)
                for site in guide_trace.nodes.values() if site["type"] == "param"
            }
            print(grads_after)
            
            for name, grad_after in grads_after.items():
                grad_before = grads_before[name]
                grad_before = torch.tensor(0.) if grad_before is None else grad_before
                grad = (grad_after - grad_before)
                if name not in grads_mean:
                    grads_mean[name] = torch.zeros_like(grad)
                    grads_var[name] = torch.zeros_like(grad)
                
                new_value = grad
                old_mean = grads_mean[name]
                delta1 = new_value - old_mean
                new_mean = old_mean + delta1 / l
                delta2 = new_value - new_mean
                grads_mean[name] = new_mean
                grads_var[name] = grads_var[name] + delta1 * delta2

        elbo /= self.num_particles
        surrogate_loss /= self.num_particles
        
        elbo = torch_item(elbo)
        loss = -elbo
        
        warn_if_nan(loss, "loss")
        return loss, grads_var

def continuous_vd(name: str, n_dim: int, transform: Optional[transforms.Transform] = None):
    mu = pyro.param(f"{name}_m", torch.zeros((n_dim,)))
    omega = pyro.param(f"{name}_omega", torch.zeros((n_dim,)))
    if transform is not None:
        # dist.TransformedDistribution has_rsample inherits from base
        return pyro.sample(name, dist.TransformedDistribution(dist.Normal(mu, torch.exp(omega)).has_rsample_(False), transform))   
    else:
        return pyro.sample(name, dist.Normal(mu, torch.exp(omega)).has_rsample_(False))
    
def discrete_vd(name: str, N: int):
    # p = pyro.param(f"{name}_p", torch.full((N,),1/N), constraints.simplex) # uses softmax transform
    up = pyro.param(f"{name}_up", torch.zeros((N-1,)), constraints.real)
    t = transforms.StickBreakingTransform()
    p = t(up)
    return pyro.sample(name, dist.Categorical(p))