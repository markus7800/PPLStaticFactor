import subprocess

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
    f.write("model, none, static, finite, custom\n")

filenames = [
    "aircraft.jl",
    "captcha.jl",
    "dirichlet_process.jl",
    "geometric.jl",
    "gmm_fixed_numclust.jl",
    "gmm_variable_numclust.jl",
    "hmm_fixed_seqlen.jl",
    "hmm_variable_seqlen.jl",
    "hurricane.jl",
    "lda_fixed_numtopic.jl",
    "lda_variable_numtopic.jl",
    "linear_regression.jl",
    "marsaglia.jl",
    "pedestrian.jl",
    "urn.jl"
]

for filename in filenames:
    print(bcolors.HEADER + filename + bcolors.ENDC)
    cmd = ["julia", "--project=.", "evaluation/bench.jl", "benchmark", filename]
    subprocess.run(cmd, capture_output=False)
exit()

print("\nUnrolled programs:\n")

filenames = [
    # "gmm_fixed_numclust.jl",
    "hmm_fixed_seqlen.jl",
    # "lda_fixed_numtopic.jl",
    # "linear_regression.jl",
]
for filename in filenames:
    print(bcolors.HEADER + filename + bcolors.ENDC)
    cmd = ["julia", "--project=.", "evaluation/bench.jl", "unrolled", filename]
    subprocess.run(cmd, capture_output=False)