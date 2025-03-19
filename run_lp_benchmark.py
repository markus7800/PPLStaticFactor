import subprocess
import sys

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

with open("evaluation/results.csv", "w") as f:
    f.write("model,none,static,finite,custom\n")

filenames = [
    "aircraft.jl",
    "bayesian_network.jl"
    "captcha.jl",
    "dirichlet_process.jl",
    "geometric.jl",
    "gmm_fixed_numclust.jl",
    "gmm_variable_numclust.jl",
    "hmm_fixed_seqlen.jl",
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
    "hmm_fixed_seqlen.jl",
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