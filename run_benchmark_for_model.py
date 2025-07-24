
import sys
sys.path.append("src/")

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("filename", help="name of your program in evaluations/models/ without path but with file extension")
parser.add_argument("algorithm", help="benchmark to run (lp|is|lmh|smc|vi)")
parser.add_argument("repetitions", help="number of experemint runs")
args = parser.parse_args()

filename = args.filename
N_repetitions = int(args.repetitions)
algo = args.algorithm
assert algo in ("lp", "is", "lmh", "smc", "vi")

results_header = {
    "lp": "model,N,none,static,rel_static,finite,rel_finite,custom,rel_custom\n",
    "is": "model,n_particles,time\n",
    "lmh": "model,N,acceptancerate,none,static,rel_static,finite,rel_finite,custom,rel_custom\n",
    "smc": "model,n_data,n_particles,none,static,rel_static\n",
    "vi": "model,N,L,none,time_none,static,time_static,rel_static\n",
}[algo]

import subprocess
import os.path

results_file = f"evaluation/models/{algo}_results.csv"
if not os.path.isfile(results_file):
    with open(results_file, "w") as f:
        f.write(results_header)

for i in range(N_repetitions):
    print(f"Repetition {i+1}.")
    cmd = ["julia", "--project=.", f"evaluation/bench_{algo}.jl", "models", filename, str(i)]
    subprocess.run(cmd, capture_output=False)
    print()
        

import pandas as pd
df = pd.read_csv(results_file)
avg_df = df.groupby("model").median()
avg_df = avg_df.reset_index()
avg_df.to_csv(f"evaluation/models/{algo}_results_aggregated.csv", index=False, sep=",", na_rep="NA")