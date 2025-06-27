import subprocess
import sys
from bcolors import bcolors

with open("evaluation/is_results.csv", "w") as f:
    f.write("model,n_particles,time\n")

filenames = [
    # "aircraft.jl",
    # "bayesian_network.jl",
    # "captcha.jl",
    "dirichlet_process.jl",
    # "geometric.jl",
    "gmm_fixed_numclust.jl",
    "gmm_variable_numclust.jl",
    "hmm.jl",
    # "hurricane.jl",
    "lda_fixed_numtopic.jl",
    "lda_variable_numtopic.jl",
    # "linear_regression.jl",
    # "marsaglia.jl",
    # "pcfg.jl",
    # "pedestrian.jl",
    # "urn.jl"
]

N_repetitions = int(sys.argv[1])

for i in range(N_repetitions):
    for filename in filenames:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        cmd = ["julia", "--project=.", "evaluation/bench_is.jl", "benchmark", filename]
        subprocess.run(cmd, capture_output=False)
        print()
        

import pandas as pd
df = pd.read_csv("evaluation/is_results.csv")
avg_df = df.groupby("model").median()
avg_df = avg_df.reset_index()
avg_df.to_csv("evaluation/is_results_aggregated.csv", index=False, sep=",", na_rep="NA")