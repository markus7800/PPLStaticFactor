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
        
class VarTracking_Trace_ELBO(Trace_ELBO):
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

            surrogate_loss_particle = surrogate_loss_particle / self.num_particles
            surrogate_loss_particle.backward(retain_graph=self.retain_graph)
                        
            grads_after = {
                site["name"]: maybe_clone(site["value"].unconstrained().grad)
                for site in guide_trace.nodes.values() if site["type"] == "param"
            }
            # print("grads", grads_after)
            
            for name, grad_after in grads_after.items():
                grad_before = grads_before[name]
                grad_before = torch.tensor(0.) if grad_before is None else grad_before
                grad = (grad_after - grad_before) * self.num_particles # correct for surrogate_loss_particle = surrogate_loss_particle / self.num_particles above
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

class VarTracking_TraceGraph_ELBO(TraceGraph_ELBO):
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
            # print(grads_after)
            
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


# has_rsample_(False) forces BBVI estimator
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

def bernoulli_vd(name: str):
    up = pyro.param(f"{name}_up", torch.tensor(0.), constraints.real)
    t = transforms.SigmoidTransform()
    p = t(up)
    return pyro.sample(name, dist.Bernoulli(p))