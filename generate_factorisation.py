
import sys
sys.path.append("src/")

from formal.formal_cfg import get_IR_for_formal
from formal.factorisation_builder import FactorisationBuilder

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

for i, filename in enumerate(filenames):
    print(i+1, filename)
    ir = get_IR_for_formal("evaluation/benchmark/" + filename)
    pw = FactorisationBuilder(filename, ir, True)
    pw.write_program()
    with open("evaluation/benchmark/generated/" + filename, "w") as f:
        f.write(pw.out)

filenames = [
    "gmm_fixed_numclust.jl",
    "hmm_fixed_seqlen.jl",
    "lda_fixed_numtopic.jl",
    "linear_regression.jl",
]
for i, filename in enumerate(filenames):
    print(i+1, filename)
    ir = get_IR_for_formal("evaluation/unrolled/" + filename, unroll_loops=True)
    pw = FactorisationBuilder(filename, ir, True)
    pw.write_program()
    with open("evaluation/unrolled/generated/" + filename, "w") as f:
        f.write(pw.out)
