import subprocess
import sys
from bcolors import bcolors


with open("compare/pyro_bbvi/vi_results.csv", "w") as f:
    f.write("model,N,L,none,time_none,graph,time_graph,rel_graph\n")

filenames = [
    # "aircraft.py",
    "bayesian_network.py",
    # "geometric.py",
    "gmm_fixed_numclust.py",
    "hmm.py",
    # "hurricane.py",
    "lda_fixed_numtopic.py",
    "linear_regression.py",
    # "marsaglia.py",
    # "pcfg.py",
    # "pedestrian.py",
    "hmm_unrolled.py",
]

N_repetitions = int(sys.argv[1])

infer_str = """
from pyro.primitives import clear_param_store
from time import time

pyro.set_rng_seed(0)

# no adagrad in pyro
adam_params = {"lr": 0.001, "betas": (0.95, 0.999)}
optimizer = Adam(adam_params)        

bbvi = VarTracking_SVI(model, guide, optimizer, loss=VarTracking_Trace_ELBO(num_particles=L), L=L, n_iter=N_ITER)
t0 = time()
for step in tqdm(range(N_ITER)):
    loss = bbvi.step()
t1 = time()

avg_var_standard = torch.median(torch.hstack(list(bbvi.avg_grads_var.values())))
standard_time = t1 - t0
print(f"{avg_var_standard=:.3e} in {standard_time:.3f}s")

clear_param_store()

pyro.set_rng_seed(0)

adam_params = {"lr": 0.001, "betas": (0.95, 0.999)}
optimizer = Adam(adam_params)        

bbvi = VarTracking_SVI(model, guide, optimizer, loss=VarTracking_TraceGraph_ELBO(num_particles=L), L=L, n_iter=N_ITER)
t0 = time()
for step in tqdm(range(N_ITER)):
    loss = bbvi.step()
t1 = time()

avg_var_graph = torch.median(torch.hstack(list(bbvi.avg_grads_var.values())))
graph_time = t1 - t0
print(f"{avg_var_graph=:.3e} in {graph_time:.3f}s")

print("reduction", avg_var_standard / avg_var_graph)
print()

with open("compare/pyro_bbvi/vi_results.csv", "a") as f:
    f.write(f"{modelname},{N_ITER},{L},{avg_var_standard},{standard_time},{avg_var_graph},{graph_time},{avg_var_standard / avg_var_graph}\\n")
"""

N_ITER = 100
L = 100

for _ in range(N_repetitions):
    for filename in filenames:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        
        with open("compare/pyro_bbvi/" + filename, "r") as src_f:
            src = src_f.read()
        src += f"\nN_ITER = {N_ITER}\nL = {L}\n"
        src += infer_str
        with open("compare/pyro_bbvi/tmp.py", "w") as tmp_f:
            tmp_f.write(src)
            
        cmd = ["python3", "compare/pyro_bbvi/tmp.py"]
        res = subprocess.run(cmd, capture_output=False)
        

import pandas as pd
df = pd.read_csv("compare/pyro_bbvi/vi_results.csv")
avg_df = df.groupby("model").median()
avg_df = avg_df.reset_index()
avg_df.to_csv("compare/pyro_bbvi/vi_results_aggregated.csv", index=False, sep=",", na_rep="NA")