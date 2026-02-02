
import subprocess
import sys
from bcolors import bcolors

import sys
sys.path.append("src/")

from formal.formal_cfg import get_IR_for_formal
from formal.factorisation_builder import FactorisationBuilder
import time
import os

from pathlib import Path

Path("evaluation/benchmark/generated/").mkdir(parents=True, exist_ok=True)

filename = "hmm.jl"

print(bcolors.HEADER + "Check build IR..." + bcolors.ENDC)
ir = get_IR_for_formal("evaluation/benchmark/" + filename)
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")


print(bcolors.HEADER + "Check generate factorisation..." + bcolors.ENDC)
pw = FactorisationBuilder(filename, ir, True, True)
pw.write_program()
with open("evaluation/benchmark/generated/" + filename, "w") as f:
    f.write(pw.out)
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")


print(bcolors.HEADER + "Check build IR (unrolled)..." + bcolors.ENDC)
ir = get_IR_for_formal("evaluation/unrolled/" + filename, unroll_loops=True)
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")


print(bcolors.HEADER + "Check generate factorisation (unrolled)..." + bcolors.ENDC)
pw = FactorisationBuilder(filename, ir, True, True)
pw.write_program()
with open("evaluation/unrolled/generated/" + filename, "w") as f:
    f.write(pw.out)
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")


print(bcolors.HEADER + "Check LMH..." + bcolors.ENDC)
cmd = ["julia", "--project=.", "evaluation/bench_lmh.jl", "benchmark", filename]
subprocess.run(cmd, capture_output=False)
os.remove("evaluation/lmh_results.csv")
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")


print(bcolors.HEADER + "Check BBVI..." + bcolors.ENDC)
cmd = ["julia", "--project=.", "evaluation/bench_vi.jl", "benchmark", filename, str(0)]
subprocess.run(cmd, capture_output=False)
os.remove("evaluation/vi_results.csv")
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")


print(bcolors.HEADER + "Check SMC..." + bcolors.ENDC)
cmd = ["julia", "--project=.", "evaluation/bench_smc.jl", "benchmark", filename]
subprocess.run(cmd, capture_output=False)
os.remove("evaluation/smc_results.csv")
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")


print(bcolors.HEADER + "Check Gen LMH..." + bcolors.ENDC)
filename = "hmm.jl"
cmd = ["julia", "--project=.", "compare/gen/" + filename]
subprocess.run(cmd, capture_output=False)
os.remove("compare/gen/lmh_results.csv")
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")


print(bcolors.HEADER + "Check Pyro BBVI..." + bcolors.ENDC)
filename = "hmm.py"
from compare.pyro_bbvi.run_vi import infer_str
with open("compare/pyro_bbvi/" + filename, "r") as src_f:
    src = src_f.read()
src += f"\nN_ITER = {10}\nL = {10}\n"
src += infer_str
with open("compare/pyro_bbvi/tmp.py", "w") as tmp_f:
    tmp_f.write(src)
cmd = ["python3", "compare/pyro_bbvi/tmp.py"]
res = subprocess.run(cmd, capture_output=False)
os.remove("compare/pyro_bbvi/vi_results.csv")
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")

print(bcolors.HEADER + "Check WebPPL BBVI..." + bcolors.ENDC)
filename, N, variants = ("hmm.wppl", 1e4, ("rec",))
from compare.webppl.run_lmh import rec_lmh_str, iter_lmh_str
N_SEEDS = 10
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
print(out)
assert res.stderr.decode() == ""
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")
    
    
print(bcolors.HEADER + "Check WebPPL SMC..." + bcolors.ENDC)
filename = "hmm.wppl"
from compare.webppl.run_smc import infer_1_str, infer_2_str
N_seeds = 10

with open("compare/webppl/" + filename, "r") as src_f:
    src = src_f.read()
with open("compare/webppl/tmp.wppl", "w") as tmp_f:
    tmp_f.write(src + f"\nvar N_seeds = {N_seeds}\n" + infer_1_str)
    
cmd = ["webppl", "--random-seed=0", "compare/webppl/tmp.wppl"]
res = subprocess.run(cmd, capture_output=True)
out = res.stdout.decode()
print(out)

with open("compare/webppl/smc/" + filename[:-5] + ".js", "r") as src_f:
    src = src_f.read()
    
with open("compare/webppl/smc/tmp.js", "w") as tmp_f:
    tmp_f.write(src + f"\nvar N_seeds = {N_seeds}\n" + infer_2_str)
    
cmd = ["node", "compare/webppl/smc/tmp.js"]
res = subprocess.run(cmd, capture_output=True)
out = res.stdout.decode()
print(out)
print(bcolors.OKGREEN + "Check OK." + bcolors.ENDC + "\n")