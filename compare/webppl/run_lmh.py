import subprocess
import re
import sys
from bcolors import bcolors


filenames = [
    ("aircraft.wppl", 1e3, ("rec", "iter")),
    ("bayesian_network.wppl", 1e4,  ("rec",)),
    ("captcha.wppl", 1e2, ("rec", "iter")),
    ("dirichlet_process.wppl", 1e3, ("rec", "iter")),
    ("geometric.wppl", 5e4, ("rec", )),
    ("gmm_fixed_numclust.wppl", 5e3, ("rec", "iter")),
    ("gmm_variable_numclust.wppl", 5e3, ("rec", "iter")),
    ("hmm.wppl", 1e4, ("rec",)),
    ("lda_fixed_numtopic.wppl", 1e3, ("rec",)),
    ("lda_variable_numtopic.wppl", 1e3, ("rec",)),
    ("linear_regression.wppl", 1e4, ("rec", "iter")),
    ("marsaglia.wppl", 5e4, ("rec",)),
    ("pcfg.wppl", 1e4, ("rec",)),
    ("pedestrian.wppl", 1e4, ("rec",)),
    ("urn.wppl", 1e4, ("rec", "iter"))
]


rec_lmh_str = """
console.log("N:", N)
console.log("N_seeds:", N_seeds)

console.time('MH rec ')
repeat(N_seeds, function() { Infer({method: 'MCMC', samples: N, burn: 0}, model_rec) })
console.timeEnd('MH rec ')

console.time('C3 rec ')
repeat(N_seeds, function() { Infer({method: 'incrementalMH', samples: N, burn: 0}, model_rec) })
console.timeEnd('C3 rec ')
"""

iter_lmh_str = """
console.time('MH iter')
repeat(N_seeds, function() { Infer({method: 'MCMC', samples: N, burn: 0}, model_iter) })
console.timeEnd('MH iter')

console.time('C3 iter')
repeat(N_seeds, function() { Infer({method: 'incrementalMH', samples: N, burn: 0}, model_iter) })
console.timeEnd('C3 iter')
"""

# rec_lmh_str = """
# console.log("N:", N)
# console.log("N_seeds:", 1)

# console.time('MH rec ')
# Infer({method: 'MCMC', samples: N, burn: 0}, model_rec)
# console.timeEnd('MH rec ')

# console.time('C3 rec ')
# Infer({method: 'incrementalMH', samples: N, burn: 0}, model_rec)
# console.timeEnd('C3 rec ')
# """

# iter_lmh_str = """
# console.time('MH iter')
# Infer({method: 'MCMC', samples: N, burn: 0}, model_iter)
# console.timeEnd('MH iter')

# console.time('C3 iter')
# Infer({method: 'incrementalMH', samples: N, burn: 0}, model_iter)
# console.timeEnd('C3 iter')
# """

def parse_time(s: str):
    if s.endswith("ms"):
        return float(s[:-2])
    elif s.endswith("s"):
        return float(s[:-1]) * 1000
    else:
        raise ValueError()


with open("compare/webppl/lmh_results.csv", "w") as f:
    f.write("model,N,base,c3,rel\n")

N_repetitions = int(sys.argv[1])
N_SEEDS = 10

for _ in range(N_repetitions):
    for filename, N, variants in filenames:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        
        with open("compare/webppl/" + filename, "r") as src_f:
            src = src_f.read()
        src += f"\nvar N = {N}\nvar N_seeds = {N_SEEDS}\n"
        if "rec" in variants:
            src += rec_lmh_str
        if "iter" in variants:
            src += iter_lmh_str
        with open("compare/webppl/tmp.wppl", "w") as tmp_f:
            tmp_f.write(src)
            
        cmd = ["webppl", "--random-seed=0", "compare/webppl/tmp.wppl"]
        res = subprocess.run(cmd, capture_output=True)
        out = res.stdout.decode()
        err = res.stderr.decode()
        # print(out)
        if err != "":
            print(err)


        match = re.search(r"N: (\d+)", out)
        assert match is not None
        n = int(match.group(1))
        
        match = re.search(r"N_seeds: (\d+)", out)
        assert match is not None
        n_seeds = int(match.group(1))

        match = re.search(r"C3 rec : (\d+.\d+(s|ms))", out)
        assert match is not None
        c3_time = parse_time(match.group(1)) / (n_seeds*n) * 1000


        match = re.search(r"MH rec : (\d+.\d+(s|ms))", out)
        assert match is not None
        mh_time = parse_time(match.group(1))
        match = re.search(r"MH iter: (\d+.\d+(s|ms))", out)
        if match:
            # use iterative implemenation if faster as comparison
            mh_time = min(mh_time, parse_time(match.group(1)))
        mh_time = mh_time / (n_seeds*n) * 1000


        print(f"{n=}, {n_seeds=}, {c3_time=}, {mh_time=}")

        with open("compare/webppl/lmh_results.csv", "a") as f:
            modelname = filename[:-5]
            f.write(f"{modelname},{n_seeds*n},{mh_time},{c3_time},{c3_time/mh_time}\n")
        print()
    
import pandas as pd
df = pd.read_csv("compare/webppl/lmh_results.csv")
avg_df = df.groupby("model").median()
avg_df = avg_df.reset_index()
avg_df.to_csv("compare/webppl/lmh_results_aggregated.csv", index=False, sep=",", na_rep="NA")