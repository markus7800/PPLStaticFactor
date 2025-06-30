import subprocess
import sys
from bcolors import bcolors


with open("compare/pyro_bbvi/vi_results.csv", "w") as f:
    f.write("model,N,L,none,graph,rel_graph\n")

filenames = [
    "aircraft.py",
    "bayesian_network.py",
    # "captcha.py",
    # "dirichlet_process.py",
    "geometric.py",
    "gmm_fixed_numclust.py",
    # "gmm_variable_numclust.py",
    "hmm.py",
    "hurricane.py",
    "lda_fixed_numtopic.py",
    # "lda_variable_numtopic.py",
    "linear_regression.py",
    "marsaglia.py",
    "pcfg.py",
    "pedestrian.py",
    # "urn.py"
    "hmm_unrolled.py",
]

N_repetitions = int(sys.argv[1])

