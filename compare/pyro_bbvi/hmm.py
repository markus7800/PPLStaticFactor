import torch
from bbvi import continuous_vd, discrete_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm

modelname = "hmm"

transition_probs = torch.tensor([
    [0.1, 0.2, 0.7],
    [0.1, 0.8, 0.1],
    [0.3, 0.3, 0.4]
])

def model():
    seqlen = len(ys)

    current = pyro.sample("initial_state", dist.Categorical(torch.tensor([0.33, 0.33, 0.34])))
    i = 0
    while i < seqlen:
        current = pyro.sample(f"state_{i}", dist.Categorical(transition_probs[current]))
        pyro.sample(f"obs_{i}", dist.Normal(current, 1), obs=ys[i])
        i = i + 1
        
ys = torch.tensor([
    3.36, 2.87, 1.54, 1.13, 2.05, 2.55, 3.08, 1.23, 2.37, 2.5,
    1.42, 1.46, 0.65, 1.15, 0.31, 2.89, 0.96, 2.23, 1.55, 1.52,
    2.72, 4.16, 2.4, 2.41, 1.05, 3.05, 2.04, 3.47, 1.08, 0.63,
    3.87, 0.08, 2.06, 2.21, 2.24, 1.77, 0.67, 2.45, 4.05, 2.95,
    1.65, 3.01, 3.74, 1.54, 2.47, 1.54, 3.7, 4.29, 0.93, 1.95, 
])


import pyro.poutine as poutine
from pprint import pprint
pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore
