
import sys
sys.path.append("src/")

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("filename", help="name of your program in evaluations/models/ without path but with file extension")
args = parser.parse_args()

filename = args.filename

from formal.formal_cfg import get_IR_for_formal
from formal.factorisation_builder import FactorisationBuilder

ir = get_IR_for_formal("evaluation/models/" + filename)
pw = FactorisationBuilder(filename, ir, True, True)
pw.write_program()
with open("evaluation/models/generated/" + filename, "w") as f:
    f.write(pw.out)

