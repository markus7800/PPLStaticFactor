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
    ("dirichlet_process.wppl", "xs", 1, 50),
    ("gmm_fixed_numclust.wppl", "data", 28, 100),
    ("gmm_variable_numclust.wppl", "data", 28, 100),
    ("hmm.wppl", "data", 18, 50),
    ("lda_fixed_numtopic.wppl", "documents", 30, 262),
    ("lda_variable_numtopic.wppl", "documents", 30, 262),
]


infer_1_str = """
var N_PARTICLES = 100

console.time('IS all ')
repeat(10, function() { Infer({method: 'forward', samples: N_PARTICLES}, model_rec) })
console.timeEnd('IS all ')

console.time('SMC all')
repeat(10, function() { Infer({method: 'SMC', particles: N_PARTICLES}, model_rec) })
console.timeEnd('SMC all')
"""

infer_2_str = """
var N_PARTICLES = 100

console.time('IS 1 ')
repeat(10, function() { Infer({method: 'forward', samples: N_PARTICLES}, model_rec) })
console.timeEnd('IS 1 ')

console.time('SMC 1')
repeat(10, function() { Infer({method: 'SMC', particles: N_PARTICLES}, model_rec) })
console.timeEnd('SMC 1')
"""

def parse_time(s: str):
    if s.endswith("ms"):
        return float(s[:-2])
    elif s.endswith("s"):
        return float(s[:-1]) * 1000
    else:
        raise ValueError()


with open("compare/webppl/smc_results.csv", "w") as f:
    f.write("model,N,base,c3,rel\n")

N_repetitions = int(sys.argv[1])

for _ in range(N_repetitions):
    for filename, data_var, l, n_data in filenames:
        print(bcolors.HEADER + filename + bcolors.ENDC)
        
        with open("compare/webppl/" + filename, "r") as src_f:
            src = src_f.read()
        with open("compare/webppl/tmp.wppl", "w") as tmp_f:
            tmp_f.write(src + infer_1_str)
            
        cmd = ["webppl", "--random-seed=0", "compare/webppl/tmp.wppl"]
        res = subprocess.run(cmd, capture_output=True)
        out = res.stdout.decode()
        print(out)
        

        match = re.search(r"IS all : (\d+.\d+(s|ms))", out)
        assert match is not None
        is_all_time = parse_time(match.group(1))
        
        match = re.search(r"SMC all: (\d+.\d+(s|ms))", out)
        assert match is not None
        smc_all_time = parse_time(match.group(1))
        
        lines = src.splitlines()
        new_lines = lines[:l] + [lines[l] + "[0]"] + lines[l+1:]
                
        with open("compare/webppl/tmp.wppl", "w") as tmp_f:
            tmp_f.write("\r\n".join(new_lines) + infer_2_str)
        
        cmd = ["webppl", "--random-seed=0", "compare/webppl/tmp.wppl"]
        res = subprocess.run(cmd, capture_output=True)
        out = res.stdout.decode()
        print(out)
        
        match = re.search(r"IS 1 : (\d+.\d+(s|ms))", out)
        assert match is not None
        is_1_time = parse_time(match.group(1))
        
        match = re.search(r"SMC 1: (\d+.\d+(s|ms))", out)
        assert match is not None
        smc_1_time = parse_time(match.group(1))
        
        print(is_all_time, smc_all_time, is_1_time, is_all_time)
        smc_without_cps_est = (is_all_time + is_1_time) / 2 * n_data
        print(smc_without_cps_est, smc_all_time / smc_without_cps_est)


        # with open("compare/webppl/smc_results.csv", "a") as f:
        #     modelname = filename[:-5]
        #     f.write(f"{modelname},{N},{mh_time},{c3_time},{c3_time/mh_time}\n")
        
        print()
    
import pandas as pd
df = pd.read_csv("compare/webppl/smc_results.csv")
avg_df = df.groupby("model").median()
avg_df = avg_df.reset_index()
avg_df.to_csv("compare/webppl/smc_results_aggregated.csv", index=False, sep=",", na_rep="NA")