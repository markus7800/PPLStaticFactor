import torch
from bbvi import continuous_vd, discrete_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm

modelname = "pedestrian"

def model():
    start = pyro.sample("start", dist.Uniform(0.,1.))
    position = start
    distance = 0
    i = 1
    while position > 0 and distance < 10:
        step = pyro.sample(f"step_{i}", dist.Uniform(-1.,1.))
        position = position + step
        distance = distance + torch.abs(step)
        i = i + 1
    pyro.sample("final_distance", dist.Normal(distance, 0.1), obs=torch.tensor(1.1))

import pyro.poutine as poutine
from pprint import pprint
pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore
