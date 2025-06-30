import torch
from bbvi import continuous_vd, discrete_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm

modelname = "geometric"

def model():
    i = -1
    b = True
    while b: 
        i = i + 1
        b = pyro.sample(f"b_{i}", dist.Bernoulli(0.5)) == 1
    pyro.sample("x", dist.Normal(i,1.), obs=torch.tensor(5.))
    return i

import pyro.poutine as poutine
from pprint import pprint
pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore
