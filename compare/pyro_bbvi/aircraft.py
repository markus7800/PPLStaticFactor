import torch
from bbvi import continuous_vd, discrete_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm

model_name = "aircraft"

def model():
    num_aircraft = pyro.sample("num_aircraft", dist.Poisson(5))
    num_aircraft = num_aircraft + 1

    total_num_blibs = 0
    blip_1 = 0.
    blip_2 = 0.
    blip_3 = 0.

    i = 1
    while i <= num_aircraft:
        position = pyro.sample(f"pos_{i}", dist.Normal(2., 5.))
        num_blips = pyro.sample(f"num_blips_{i}", dist.Categorical(torch.tensor([0.1,0.4,0.5])))
        j = 1
        while j <= num_blips:
            total_num_blibs = total_num_blibs + 1
            blip = pyro.sample(f"blip_{i}_{j}", dist.Normal(position, 1.))
            if total_num_blibs == 1:
                blip_1 = blip
            if total_num_blibs == 2:
                blip_2 = blip
            if total_num_blibs == 3:
                blip_3 = blip
            j = j + 1
        i = i + 1

    pyro.sample("observed_num_blips", dist.Normal(total_num_blibs, 1), obs=torch.tensor(3))
    pyro.sample("observed_blip_1", dist.Normal(blip_1, 1), obs=torch.tensor(1.))
    pyro.sample("observed_blip_2", dist.Normal(blip_2, 1), obs=torch.tensor(2.))
    pyro.sample("observed_blip_3", dist.Normal(blip_3, 1), obs=torch.tensor(3.))


# import pyro.poutine as poutine
# from pprint import pprint
# pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore
