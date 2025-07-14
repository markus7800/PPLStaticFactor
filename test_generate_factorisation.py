
import sys
sys.path.append("src/")

from formal.formal_cfg import get_IR_for_formal
from formal.factorisation_builder import FactorisationBuilder

filename = "test_1.jl"
ir = get_IR_for_formal("evaluation/test/" + filename)
pw = FactorisationBuilder(filename, ir, True, True)
pw.write_program()
with open("evaluation/test/generated/" + filename, "w") as f:
    f.write(pw.out)

