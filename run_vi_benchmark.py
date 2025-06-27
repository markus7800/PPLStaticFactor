import subprocess
import sys
from bcolors import bcolors


with open("evaluation/vi_results.csv", "w") as f:
    f.write("model,N,L,none,static,rel_static\n")

filenames = [
    "aircraft.jl",
    "bayesian_network.jl",
    # "captcha.jl",
    # "dirichlet_process.jl",
    "geometric.jl",
    "gmm_fixed_numclust.jl",
    # "gmm_variable_numclust.jl",
    "hmm.jl",
    "hurricane.jl",
    "lda_fixed_numtopic.jl",
    # "lda_variable_numtopic.jl",
    "linear_regression.jl",
    "marsaglia.jl",
    "pcfg.jl",
    "pedestrian.jl",
    # "urn.jl"
]
filenames_unrolled = [
    # "gmm_fixed_numclust.jl",
    "hmm.jl",
    # "lda_fixed_numtopic.jl",
    # "linear_regression.jl",
]

N_repetitions = int(sys.argv[1])

for i in range(N_repetitions):
    for filename in filenames:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        cmd = ["julia", "--project=.", "evaluation/bench_vi.jl", "benchmark", filename, str(i)]
        subprocess.run(cmd, capture_output=False)
        print()


    print("\nUnrolled programs:\n")

    for filename in filenames_unrolled:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        cmd = ["julia", "--project=.", "evaluation/bench_vi.jl", "unrolled", filename, str(i)]
        subprocess.run(cmd, capture_output=False)
        print()


import pandas as pd
df = pd.read_csv("evaluation/vi_results.csv")
avg_df = df.groupby("model").median()
avg_df = avg_df.reset_index()
avg_df.to_csv("evaluation/vi_results_aggregated.csv", index=False, sep=",", na_rep="NA")