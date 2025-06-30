import torch
from bbvi import continuous_vd, discrete_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm

modelname = "pcfg"


production_probs = torch.tensor([
    [0.1, 0.2, 0.6, 0.1],
    [0.05, 0.8, 0.1, 0.05],
    [0.3, 0.3, 0.3, 0.1]
])

def model():
    TERMINAL_SYMBOL = 3
    current = pyro.sample("initial_symbol", dist.Categorical(torch.tensor([0.33, 0.33, 0.34])))
    i = 1
    while current != TERMINAL_SYMBOL:
        current = pyro.sample(f"symbol_{i}", dist.Categorical(production_probs[current]))
        i = i + 1
        

def guide():
    TERMINAL_SYMBOL = 3
    current = discrete_vd("initial_symbol", 3)
    i = 1
    while current != TERMINAL_SYMBOL:
        current = discrete_vd(f"symbol_{i}", 4)
        i = i + 1

# import pyro.poutine as poutine
# from pprint import pprint
# pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore
