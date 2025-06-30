import torch
from bbvi import continuous_vd, discrete_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm

modelname = "lda_fixed_numtopic"


w = torch.tensor([4, 3, 5, 4, 3, 3, 3, 3, 3, 4, 5, 3, 4, 4, 5, 3, 4, 4, 4, 3, 5, 4, 5, 2, 3, 3, 1, 5, 5, 1, 4, 3, 1, 2, 5, 4, 4, 3, 5, 4, 2, 4, 5, 3, 4, 1, 4, 4, 3, 2, 1, 2, 1, 2, 2, 2, 1, 2, 2, 3, 1, 2, 2, 4, 4, 5, 4, 5, 5, 4, 3, 5, 4, 4, 4, 2, 2, 1, 1, 2, 1, 3, 1, 2, 1, 1, 1, 3, 2, 3, 3, 5, 4, 5, 4, 3, 5, 4, 2, 2, 2, 1, 3, 2, 1, 3, 1, 3, 1, 1, 2, 1, 2, 2, 4, 4, 4, 5, 5, 4, 4, 5, 4, 3, 3, 3, 1, 3, 3, 4, 2, 1, 3, 4, 4, 5, 4, 4, 4, 3, 4, 3, 4, 5, 1, 2, 1, 3, 2, 1, 1, 2, 3, 3, 3, 3, 4, 1, 4, 4, 4, 4, 3, 4, 4, 1, 2, 2, 3, 3, 1, 1, 4, 1, 3, 1, 5, 3, 2, 2, 1, 1, 2, 3, 3, 4, 4, 5, 3, 4, 3, 1, 5, 5, 5, 3, 3, 4, 5, 3, 3, 3, 2, 3, 1, 3, 3, 1, 3, 1, 5, 5, 5, 2, 2, 3, 3, 3, 1, 1, 5, 5, 5, 3, 1, 5, 4, 1, 3, 3, 3, 3, 4, 2, 5, 1, 3, 5, 2, 5, 5, 2, 1, 3, 3, 5, 3, 5, 3, 3, 5, 1, 2, 2, 1, 1, 2, 1, 2, 3, 1, 1]) - 1
doc = torch.tensor([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12, 13, 13, 13, 13, 13, 13, 13, 13, 13, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 19, 19, 19, 19, 20, 20, 20, 20, 20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 22, 22, 22, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25]) - 1
M = 25  # num docs
N = 262 # total word instances
V = 5  # num words

def model():
    K = 2 # num topics

    thetas = []

    i = 1
    while i <= M:
        theta = pyro.sample(f"theta_{i}", dist.Dirichlet(torch.full((K,), 1/K)))
        thetas.append(theta)
        i = i + 1
    thetas = torch.vstack(thetas)
    # print(f"{thetas.shape=}")

    phis = []

    i = 1
    while i <= K:
        phi = pyro.sample(f"phi_{i}", dist.Dirichlet(torch.full((V,),1/V)))
        phis.append(phi)
        i = i + 1
    phis = torch.vstack(phis)
    # print(f"{phis.shape=}")

    n = 0
    while n < N:
        z = pyro.sample(f"z_{n}", dist.Categorical(thetas[doc[n]]))
        pyro.sample(f"w_{n}", dist.Categorical(phis[z]), obs=w[n])
        n = n + 1
        

def guide():
    K = 2 # num topics

    i = 1
    while i <= M:
        theta = continuous_vd(f"theta_{i}", K-1, transforms.StickBreakingTransform())
        i = i + 1

    i = 1
    while i <= K:
        phi = continuous_vd(f"phi_{i}", V-1, transforms.StickBreakingTransform())
        i = i + 1

    n = 0
    while n < N:
        z = discrete_vd(f"z_{n}", 2)
        n = n + 1

# import pyro.poutine as poutine
# from pprint import pprint
# pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore
