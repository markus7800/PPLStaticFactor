
import sexpdata
from typing import Optional, Dict, Tuple, List, Any
from utils import *
from ir4ppl.base_cfg import AbstractSyntaxNode

def sym_to_str(sexpr):
    if isinstance(sexpr, sexpdata.Symbol):
        return sexpr.value()
    elif isinstance(sexpr, list):
        return [sym_to_str(el) for el in sexpr]
    elif isinstance(sexpr, (bool,int,float,str)):
        return sexpr
    else:
        assert False, (sexpr, type(sexpr))

from pprint import pprint
class JuliaSyntaxNode(AbstractSyntaxNode):
    def __init__(self, sexpr: list, kind: str, value: Any = None) -> None:
        self.sexpr = sexpr
        self.kind = kind
        self.value = value
        self.parent: Optional[JuliaSyntaxNode] = None
        self.children: List[JuliaSyntaxNode] = list()

    # starts at 1
    def __getitem__(self, i: int):
        return self.children[i-1]
    
    def append(self, child):
        assert isinstance(child, JuliaSyntaxNode), child
        child.parent = self
        self.children.append(child)

    def fields(self) -> List[str]:
        return [child.kind for child in self.children]
    def __repr__(self) -> str:
        return f"{self.kind}({self.fields()}))"
    
    def pprint(self):
        print(self.kind, end=" ")
        pprint({i+1: child for i, child in enumerate(self.children)})


def make_syntaxtree(sexpr: list) -> JuliaSyntaxNode:
    assert len(sexpr) >= 2, f"Sexpr has not atleast two elements: {sexpr}"
    kind = sexpr[0]
    assert isinstance(kind, str)
    if len(sexpr) == 2 and not isinstance(sexpr[1], list):
        return JuliaSyntaxNode(sexpr, kind, sexpr[1])
    else:
        node = JuliaSyntaxNode(sexpr, kind)
        for child in sexpr[1:]:
            node.append(make_syntaxtree(child))
        return node
    
def unparse(sexpr: list, tab="") -> str:
    assert len(sexpr) >= 2
    kind = sexpr[0]
    assert isinstance(kind, str), kind
    if len(sexpr) == 2 and not isinstance(sexpr[1], list):
        if sexpr[1] == float('inf'):
            return "Inf"
        return str(sexpr[1])
    else:
        match sexpr:
            case ['toplevel' | 'block', *args]:
                s = ""
                for arg in args:
                    s += unparse(arg, tab) + "\n"
                return s
            case ['call', name, *args]:
                args_s = ", ".join([unparse(arg) for arg in args])
                return tab + f"{unparse(name)}({args_s})"
            case ['call-i', arg1, op, *args]:
                opname = op[1]
                args.insert(0, arg1)
                return tab + "(" + f" {opname} ".join([unparse(arg) for arg in args]) + ")"
            case ['string', s]:
                return tab + f"\"{unparse(s)}\""
            case ['using', s]:
                return f"using {unparse(s)}"
            case ['importpath', name]:
                return tab + unparse(name)
            case ['macrocall', name, func]:
                return tab + unparse(name) + " " + unparse(func)
            case ['function', sig, body]:
                s = tab + f"function {unparse(sig)}\n"
                s += unparse(body, tab+"    ")
                s += tab + "end"
                return s
            case ['::-i', name, t]:
                return tab + f"{unparse(name)}::{unparse(t)}"
            case ['curly', name, i]:
                return tab + unparse(name) + "{" + unparse(i) + "}" 
            case ['=', lhs, rhs]:
                return tab + unparse(lhs) + " = " + unparse(rhs)
            case ['ref', name, *args]:
                args_s = ", ".join([unparse(arg) for arg in args])
                return tab + f"{unparse(name)}[{args_s}]"
            case ['while', test, body]:
                s = tab + f"while {unparse(test)}\n"
                s += unparse(body, tab+"    ")
                s += tab + "end"
                return s
            case ['for', range, body]:
                s = tab + f"for {unparse(range)}\n"
                s += unparse(body, tab+"    ")
                s += tab + "end"
                return s
            case ["if", test, then]:
                s = tab + f"if {unparse(test)}\n"
                s += unparse(then, tab+"    ")
                s += tab + "end"
                return s
            case ["if", test, then, orelse]:
                s = tab + f"if {unparse(test)}\n"
                s += unparse(then, tab+"    ")
                s += tab + "else\n"
                s += unparse(orelse, tab+"    ")
                s += tab + "end"
                return s
            case ['parameters', *args]:
                return tab + ", ".join([unparse(arg) for arg in args])
            case ['vect', *args]:
                return tab + "[" + ", ".join([unparse(arg) for arg in args]) + "]"
            case ['.', name, ['quote', [member]]]:
                return tab + f"{unparse(name)}.{member}"
            case ['return', val]:
                return tab + f"return {unparse(val)}"
            case ['&&', *args]:
                return tab + "(" + f" && ".join([unparse(arg) for arg in args]) + ")"
            case ['vcat', *args]:
                return tab + "[" + f"; ".join([unparse(arg) for arg in args]) + "]"
            case ['row', *args]:
                return tab + f" ".join([unparse(arg) for arg in args])
            case ['?', test, then, orelse]:
                return tab + f"{unparse(test)} ? {unparse(then)} : {unparse(orelse)}"
            case _:
                raise Exception(f"Unknown sexpr in unparse {sexpr}")