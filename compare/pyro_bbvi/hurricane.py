import torch
from bbvi import continuous_vd, discrete_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm

modelname = "hurricane"

def model():
    first_city_ixs = pyro.sample("F", dist.Bernoulli(0.5))
    prep_0 = 0
    damage_0 = 0
    prep_1 = 0
    damage_1 = 0
    if first_city_ixs == 0:
        prep_0 = pyro.sample("P0", dist.Bernoulli(0.5))
        damage_0 = pyro.sample("D0", dist.Bernoulli(0.20 if prep_0 == 1 else 0.80))
        prep_1 = pyro.sample("P1", dist.Bernoulli(0.75 if damage_0 == 1 else 0.50))
        damage_1 = pyro.sample("D1", dist.Bernoulli(0.20 if prep_1 == 1 else 0.80))
    else:
        prep_1 = pyro.sample("P1", dist.Bernoulli(0.5))
        damage_1 = pyro.sample("D1", dist.Bernoulli(0.20 if prep_1 == 1 else 0.80))
        prep_0 = pyro.sample("P0", dist.Bernoulli(0.75 if damage_1 == 1 else 0.50))
        damage_0 = pyro.sample("D0", dist.Bernoulli(0.20 if prep_0 == 1 else 0.80))


import pyro.poutine as poutine
from pprint import pprint
pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore
