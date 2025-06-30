import torch
from bbvi import continuous_vd, discrete_vd, bernoulli_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm
from pyro.primitives import get_param_store, clear_param_store

modelname = "geometric"

def model():
    i = -1
    b = True
    while b: 
        i = i + 1
        b = pyro.sample(f"b_{i}", dist.Bernoulli(0.5)) == 1
    pyro.sample("x", dist.Normal(i,1.), obs=torch.tensor(5.))
    return i


def guide():
    i = -1
    b = True
    while b: 
        i = i + 1
        b = bernoulli_vd(f"b_{i}") == 1
    return i


# import pyro.poutine as poutine
# from pprint import pprint
# pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore


N_ITER = 1000
L = 10

pyro.set_rng_seed(0)

# no adagrad in pyro
adam_params = {"lr": 0.005, "betas": (0.95, 0.999)}
optimizer = Adam(adam_params)        

bbvi = VarTracking_SVI(model, guide, optimizer, loss=VarTracking_Trace_ELBO(num_particles=L), L=L, n_iter=N_ITER)
for step in tqdm(range(N_ITER)):
    loss = bbvi.step()

avg_var_standard = torch.median(torch.hstack(list(bbvi.avg_grads_var.values())))
print(f"{avg_var_standard=:.4g}")
param_store = get_param_store()
for name, param in param_store.named_parameters():
    print(name, param)


clear_param_store()

# Does not work:

adam_params = {"lr": 0.005, "betas": (0.95, 0.999)}
optimizer = Adam(adam_params)        

bbvi = VarTracking_SVI(model, guide, optimizer, loss=VarTracking_TraceGraph_ELBO(num_particles=L), L=L, n_iter=N_ITER)
for step in tqdm(range(N_ITER)):
    loss = bbvi.step()

avg_var_graph = torch.median(torch.hstack(list(bbvi.avg_grads_var.values())))
print(f"{avg_var_graph=:.4g}")
param_store = get_param_store()
for name, param in param_store.named_parameters():
    print(name, param)

print()