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

filenames = [
    "dirichlet_process.wppl",
    "gmm_fixed_numclust.wppl",
    "gmm_variable_numclust.wppl",
    "hmm.wppl",
    "lda_fixed_numtopic.wppl",
    "lda_variable_numtopic.wppl",
]


infer_1_str = """
var N_PARTICLES = 100

console.time('IS ')
repeat(10, function() { Infer({method: 'forward', samples: N_PARTICLES}, model_rec) })
console.timeEnd('IS ')

console.time('SMC')
repeat(10, function() { Infer({method: 'SMC', particles: N_PARTICLES}, model_rec) })
console.timeEnd('SMC')
"""

infer_2_str = """
var N_PARTICLES = 100

ppl.seedRNG(0)
console.time('SMC')
for (var i = 0; i < 10; i++) {
    ppl.smc(model_data_annealed, N_PARTICLES, N_DATA)
}
console.timeEnd('SMC')
"""


def parse_time(s: str):
    if s.endswith("ms"):
        return float(s[:-2])
    elif s.endswith("s"):
        return float(s[:-1]) * 1000
    else:
        raise ValueError()


with open("compare/webppl/smc_results.csv", "w") as f:
    f.write("model,smc_standard,smc_cps,cps_rel,is_cps\n")

N_repetitions = int(sys.argv[1])

for _ in range(N_repetitions):
    for filename in filenames:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        
        with open("compare/webppl/" + filename, "r") as src_f:
            src = src_f.read()
        with open("compare/webppl/tmp.wppl", "w") as tmp_f:
            tmp_f.write(src + infer_1_str)
            
        cmd = ["webppl", "--random-seed=0", "compare/webppl/tmp.wppl"]
        res = subprocess.run(cmd, capture_output=True)
        out = res.stdout.decode()
        # print(out)
        
        match = re.search(r"IS : (\d+.\d+(s|ms))", out)
        assert match is not None
        is_time = parse_time(match.group(1))
        
        match = re.search(r"SMC: (\d+.\d+(s|ms))", out)
        assert match is not None
        smc_time = parse_time(match.group(1))
        
        
        with open("compare/webppl/smc/" + filename[:-5] + ".js", "r") as src_f:
            src = src_f.read()
            
        with open("compare/webppl/smc/tmp.js", "w") as tmp_f:
            tmp_f.write(src + infer_2_str)
            
        cmd = ["node", "compare/webppl/smc/tmp.js"]
        res = subprocess.run(cmd, capture_output=True)
        out = res.stdout.decode()
        # print(out)
        
        match = re.search(r"SMC: (\d+.\d+(s|ms))", out)
        assert match is not None
        smc_standard_time = parse_time(match.group(1))
        
        print(smc_standard_time, "vs", smc_time, f"{smc_time/smc_standard_time}")

        with open("compare/webppl/smc_results.csv", "a") as f:
            modelname = filename[:-5]
            f.write(f"{modelname},{smc_standard_time},{smc_time},{smc_time/smc_standard_time},{is_time}\n")
        
        print()
    
import pandas as pd
df = pd.read_csv("compare/webppl/smc_results.csv")
avg_df = df.groupby("model").median()
avg_df = avg_df.reset_index()
avg_df.to_csv("compare/webppl/smc_results_aggregated.csv", index=False, sep=",", na_rep="NA")