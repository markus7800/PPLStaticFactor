import subprocess
import sys
from bcolors import bcolors


with open("evaluation/lp_results.csv", "w") as f:
    f.write("model,N,none,static,rel_static,finite,rel_finite,custom,rel_custom\n")

filenames = [
    "aircraft.jl",
    "bayesian_network.jl",
    "captcha.jl",
    "dirichlet_process.jl",
    "geometric.jl",
    "gmm_fixed_numclust.jl",
    "gmm_variable_numclust.jl",
    "hmm.jl",
    "hurricane.jl",
    "lda_fixed_numtopic.jl",
    "lda_variable_numtopic.jl",
    "linear_regression.jl",
    "marsaglia.jl",
    "pedestrian.jl",
    "pcfg.jl",
    "urn.jl"
]
filenames_unrolled = [
    # "gmm_fixed_numclust.jl",
    "hmm.jl",
    # "lda_fixed_numtopic.jl",
    # "linear_regression.jl",
]

N_repetitions = int(sys.argv[1])

for _ in range(N_repetitions):
    for filename in filenames:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        cmd = ["julia", "--project=.", "evaluation/bench_lp.jl", "benchmark", filename]
        subprocess.run(cmd, capture_output=False)
        print()


    print("\nUnrolled programs:\n")

    for filename in filenames_unrolled:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        cmd = ["julia", "--project=.", "evaluation/bench_lp.jl", "unrolled", filename]
        subprocess.run(cmd, capture_output=False)
        print()


import pandas as pd
df = pd.read_csv("evaluation/lp_results.csv")
avg_df = df.groupby("model").median()
avg_df = avg_df.reset_index()
avg_df.to_csv("evaluation/lp_results_aggregated.csv", index=False, sep=",", na_rep="NA")