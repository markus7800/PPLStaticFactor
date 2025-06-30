import torch
from bbvi import continuous_vd, discrete_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm

modelname = "marsaglia"


def model():
    s = torch.tensor(torch.inf)
    x = 0.
    y = 0.
    i = 1
    while s > 1:
        x = pyro.sample(f"x_{i}", dist.Uniform(-1.,1.))
        y = pyro.sample(f"y_{i}", dist.Uniform(-1.,1.))
        s = x**2 + y**2
        i = i + 1
    
    z = x * torch.sqrt(-2 * torch.log(s) / s)
    return z

import pyro.poutine as poutine
from pprint import pprint
pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore
