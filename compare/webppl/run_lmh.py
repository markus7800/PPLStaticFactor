import subprocess
import re
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

with open("compare/gen/results.csv", "w") as f:
    f.write("model,N,acceptancerate,base,combinator,rel\n")

filenames = [
    ("aircraft.wppl", ("rec", "iter")),
    ("bayesian_network.wppl", ("rec",)),
    ("captcha.wppl", ("rec", "iter")),
    ("dirichlet_process.wppl", ("rec", "iter")),
    ("geometric.wppl", ("rec", )),
    ("gmm_fixed_numclust.wppl", ("rec", "iter")),
    ("gmm_variable_numclust.wppl", ("rec", "iter")),
    ("hmm.wppl", ("rec",)),
    ("hurricane.wppl", ("rec",)),
    ("lda_fixed_numtopic.wppl", ("rec",)),
    ("lda_variable_numtopic.wppl", ("rec",)),
    ("linear_regression.wppl", ("rec", "iter")),
    ("pedestrian.wppl", ("rec",)),
    ("marsaglia.wppl", ("rec",)),
    ("pcfg.wppl", ("rec",)),
    ("urn.wppl", ("rec", "iter"))
]


rec_lmh_str = """
console.time('MH rec ')
repeat(10, function() { Infer({method: 'MCMC', samples: N, burn: 0}, model_rec) })
console.timeEnd('MH rec ')

console.time('C3 rec ')
repeat(10, function() { Infer({method: 'incrementalMH', samples: N, burn: 0}, model_rec) })
console.timeEnd('C3 rec ')
"""

iter_lmh_str = """
console.time('MH iter')
repeat(10, function() { Infer({method: 'MCMC', samples: N, burn: 0}, model_iter) })
console.timeEnd('MH iter')

console.time('C3 iter')
repeat(10, function() { Infer({method: 'incrementalMH', samples: N, burn: 0}, model_iter) })
console.timeEnd('C3 iter')
"""

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

for _ in range(N_repetitions):
    for filename, variants in filenames:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        with open("compare/webppl/" + filename, "r") as src_f:
            src = src_f.read()
        if "rec" in variants:
            src += rec_lmh_str
        if "iter" in variants:
            src += iter_lmh_str
        with open("compare/webppl/tmp.wppl", "w") as tmp_f:
            tmp_f.write(src)
        cmd = ["webppl", "--random-seed=0", "compare/webppl/tmp.wppl"]
        res = subprocess.run(cmd, capture_output=True)
        out = res.stdout.decode()
        # print(out)


        match = re.search(r"N: (\d+)", out)
        assert match is not None
        N = int(match.group(1))

        match = re.search(r"C3 rec : (\d+.\d+(s|ms))", out)
        assert match is not None
        c3_time = parse_time(match.group(1))


        match = re.search(r"MH rec : (\d+.\d+(s|ms))", out)
        assert match is not None
        mh_time = parse_time(match.group(1))
        match = re.search(r"MH iter: (\d+.\d+(s|ms))", out)
        if match:
            # use iterative implemenation if faster as comparison
            mh_time = min(mh_time, parse_time(match.group(1)))


        print(f"{N=}, {c3_time=}, {mh_time=}")

        with open("compare/webppl/lmh_results.csv", "a") as f:
            modelname = filename[:-5]
            f.write(f"{modelname},{N},{mh_time},{c3_time},{c3_time/mh_time}\n")
        print()
    
import pandas as pd
df = pd.read_csv("compare/webppl/lmh_results.csv")
avg_df = df.groupby("model").median()
avg_df = avg_df.reset_index()
avg_df.to_csv("compare/webppl/lmh_results_aggregated.csv", index=False, sep=",", na_rep="NA")