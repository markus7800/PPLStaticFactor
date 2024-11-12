# %%
import subprocess
import sexpdata
from formal.syntaxnode import *
from formal.formal_cfg import *
from static.model_graph import get_graph


def is_on_path_between_nodes(node: CFGNode, start: CFGNode, end: CFGNode) -> bool:
    b1 = is_reachable(start, node)
    b2 = is_reachable(node, end)
    return b1 and b2

def is_on_direct_path_between_nodes(node: CFGNode, start: CFGNode, end: CFGNode) -> bool:
    # is there a path from start to node to end  such that we do not have to go through start (or end)?
    start.block()
    # end.block()
    b1 = is_reachable(start, node)
    b2 = is_reachable(node, end)
    # end.unblock()
    start.unblock()
    return b1 and b2


from copy import deepcopy

def inject_state_rec(sexpr: list, state_var, var_names, node: SampleNode | FactorNode | None):
    match sexpr:
        case ["Identifier", name] if name in var_names:
            return [".", ["Identifier", state_var], ["quote", [name]]]
        case ["call", ["Identifier", "sample"], ctx, *args]:
            # node.id[5:] == node_ + int
            assert node is not None
            return ["call", ["Identifier", "sample"], ctx, ["Identifier", state_var], ["Integer", node.id[5:]], *[inject_state_rec(arg, state_var, var_names, None) for arg in args]]
    
    if len(sexpr) == 2 and not isinstance(sexpr[1], list):
        return sexpr
    else:
        return [sexpr[0]] + [inject_state_rec(child, state_var, var_names, None) for child in sexpr[1:]]
    
class FactorFunctionWriter():
    def __init__(self, model: CFG, samplenode: SampleNode, deps: Set[SampleNode|FactorNode], direct_paths: bool) -> None:
        self.direct_paths = direct_paths
        is_on_path = is_on_direct_path_between_nodes if direct_paths else is_on_path_between_nodes
        path_nodes = {
            cfgnode for cfgnode in model.nodes
            if any(is_on_path(cfgnode, samplenode, dep) for dep in deps)
        }
        # print(samplenode)
        # for dep in deps:
        #     print("  dep", dep)
        # for pathnode in path_nodes:
        #     print("  pathnode", pathnode)
        path_nodes.add(samplenode)
        self.samplenode = samplenode
        self.deps = deps
        self.path_nodes = path_nodes
        self.block_nodes: Set[CFGNode] = set()
        self.wrote_first = False

        self.state_var = "_s_"
        state_members: list[JuliaAssignTarget] = []
        for node in model.nodes:
            if isinstance(node, (AssignNode, SampleNode)):
                target = node.get_target()
                assert isinstance(target, JuliaAssignTarget)
                if target.syntaxnode.kind == "::-i":
                    state_members.append(target)
        self.state_members = state_members
        self.var_names = set(m.name for m in state_members)

        self.out = ""


    def write_factor_function(self, current: CFGNode, force_write=False, tab=""):
        while True:
            if isinstance(current, AbstractAssignNode):
                target = current.get_target()
                assert isinstance(target, JuliaAssignTarget)
                value = current.get_value_expr()
                assert isinstance(value, JuliaExpression)
                value_sexpr = value.syntaxnode.sexpr


                if isinstance(current, JuliaSampleNode):
                    value_sexpr =  inject_state_rec(value_sexpr, self.state_var, self.var_names, current)
                    value_sexpr = deepcopy(value_sexpr)
                    assert value_sexpr[0] == "call"
                    assert value_sexpr[1] == ["Identifier", "sample"]
                    if current == self.samplenode and not self.wrote_first:
                        self.wrote_first = True
                        value_sexpr[1] = ["Identifier", "resample"]
                    elif current in self.deps:
                        value_sexpr[1] = ["Identifier", "score"]
                    else:
                        value_sexpr[1] = ["Identifier", "read"]
                        del value_sexpr[6] # remove distribution
                else:
                    value_sexpr =  inject_state_rec(value_sexpr, self.state_var, self.var_names, None)


                if target.syntaxnode.kind == "::-i":
                    target_sexpr = target.syntaxnode.sexpr[1]
                else:
                    target_sexpr = target.syntaxnode.sexpr
                    
                target_sexpr = inject_state_rec(target_sexpr, self.state_var, self.var_names, None)

                self.out += tab + unparse(target_sexpr) + " = " + unparse(value_sexpr) + "\n"
                next = get_only_elem(current.children)

            elif isinstance(current, ExprNode):
                expr = current.get_expr()
                assert isinstance(expr, JuliaExpression)
                value_sexpr = expr.syntaxnode.sexpr
                

                if isinstance(current, JuliaFactorNode):
                    value_sexpr = inject_state_rec(value_sexpr, self.state_var, self.var_names, current)
                    value_sexpr = deepcopy(value_sexpr)
                    assert value_sexpr[0] == "call"
                    assert value_sexpr[1] == ["Identifier", "sample"]
                    if current in self.deps:
                        value_sexpr[1] = ["Identifier", "score"]
                    else:
                        value_sexpr[1] = ["Identifier", "read"]
                        del value_sexpr[6] # remove distribution
                else:
                    value_sexpr =  inject_state_rec(value_sexpr, self.state_var, self.var_names, None)


                self.out += tab + unparse(value_sexpr) + "\n"
                next = get_only_elem(current.children)

            elif isinstance(current, JoinNode):
                if current.id.endswith("for_start"):
                    raise Exception("For loops are not supported!")
                
                if current.id.endswith("while_start"):
                    while_join_startnode = current
                    assert while_join_startnode not in self.block_nodes
                    self.block_nodes.add(while_join_startnode)

                    branchnode = get_only_elem(while_join_startnode.children)
                    assert isinstance(branchnode, BranchNode)
                    test = branchnode.get_test_expr()
                    assert isinstance(test, JuliaExpression)
                    test_sexpr = test.syntaxnode.sexpr
                    test_sexpr =  inject_state_rec(test_sexpr, self.state_var, self.var_names, None)
                    self.out += tab+"while " + unparse(test_sexpr) + "\n"

                    assert isinstance(branchnode.then, (AbstractAssignNode, ExprNode, BranchNode))
                    while_force_write = self.direct_paths
                    self.write_factor_function(branchnode.then, while_force_write, tab+"    ")
                    self.out += tab + "end" + "\n"

                    self.block_nodes.discard(while_join_startnode)

                    while_end_joinnode = branchnode.orelse
                    assert while_end_joinnode.id.endswith("while_end")
                    next = get_only_elem(while_end_joinnode.children)
                else:
                    next = get_only_elem(current.children)
                    # raise Exception(f"Cannot write join {current}")
            elif isinstance(current, BranchNode):
                assert current.id.endswith("if_start")
                prefix_id = current.id[:-len("if_start")]
                branch_joinnode = [joinnode for joinnode in current.join_nodes if joinnode.id == prefix_id + "if_end"][0]
                self.block_nodes.add(branch_joinnode)

                test = current.get_test_expr()
                assert isinstance(test, JuliaExpression)
                test_sexpr = test.syntaxnode.sexpr
                test_sexpr =  inject_state_rec(test_sexpr, self.state_var, self.var_names, None)

                self.out += tab+"if " + unparse(test_sexpr) + "\n"

                if current.then != branch_joinnode:
                    self.write_factor_function(current.then, force_write, tab+"    ")
                if current.orelse != branch_joinnode:
                    self.out += tab+"else\n"
                    self.write_factor_function(current.orelse, force_write, tab+"    ")

                self.out += tab + "end" + "\n"
                
                
                self.block_nodes.discard(branch_joinnode)
                next = get_only_elem(branch_joinnode.children)
            else:
                raise Exception(f"Cannot write {current}")

            if next in self.block_nodes:
                break
            if not force_write and next not in self.path_nodes:
                break
            current = next
    


class SexprToNodeVisitor(NodeVisitor):
    def __init__(self) -> None:
        self.sexpr_to_node : Dict[Any, JuliaSyntaxNode] = {}

    def visit(self, node: JuliaSyntaxNode):
        self.sexpr_to_node[id(node.sexpr)] = node
        
        self.generic_visit(node)


import operator  
class FactorisationBuilder():
    def __init__(self, filename: str, ir: PPL_IR, direct_paths: bool) -> None:
        model = ir.get_model()
        assert model is not None
        self.filename = filename
        self.ir = ir
        self.model = model
        self.direct_paths = direct_paths


        model_function = next(fdef for fdef, cfg in ir.cfgs.items() if cfg == self.model)
        # print(model_function)
        assert isinstance(model_function, JuliaFunctionDefinition)
        # print(unparse(model_function.syntaxnode.sexpr))
        self.model_function = model_function

        self.state_var = "_s_"
        state_members: list[JuliaAssignTarget] = []
        for node in model.nodes:
            if isinstance(node, (AssignNode, SampleNode)):
                target = node.get_target()
                assert isinstance(target, JuliaAssignTarget)
                if target.syntaxnode.kind == "::-i":
                    state_members.append(target)
        self.state_members = sorted(state_members, key=operator.attrgetter('name'))
        self.var_names = set(m.name for m in state_members)


        self.sample_nodes = ir.get_sample_nodes()
        self.factor_nodes = ir.get_factor_nodes()

        _, model_graph_edges = get_graph(ir)
        self.model_graph_edges = model_graph_edges

        self.out = ""

    def write_state_struct(self):
        s = "mutable struct State <: AbstractState\n"
        tab = "    "
        s += tab + "node_id:: Int\n"
        for m in self.state_members:
            s += tab  + unparse(m.syntaxnode.sexpr) + "\n"
        s += tab + "function State()\n"
        s += tab + tab + "return new(\n"
        s += tab + tab + tab + "0,\n"
        for m in self.state_members:
            # TODO: maybe copy vectors?
            s += tab + tab + tab + f"zero({unparse(m.syntaxnode[2].sexpr)})," + "\n"
        s +=  tab + tab + ")\n"
        s += tab + "end\n"
        s += "end\n\n"

        s += f"function Base.copy!(dst::State, {self.state_var}::State)\n"
        s += tab + f"dst.node_id = {self.state_var}.node_id\n"
        for m in self.state_members:
            var = m.name # unparse(m.syntaxnode[1].sexpr)
            s += tab + f"dst.{var} = {self.state_var}.{var}\n"
        s += tab + f"return dst\n"
        s += "end\n\n"
        s += f"Base.copy({self.state_var}::State) = Base.copy!(State(), {self.state_var})\n\n"
        self.out += s

        header = []
        for m in self.state_members:
            var = m.name
            header.append(["=", ["Identifier", var], [".", ["Identifier", self.state_var], ["quote", [var]]]])
        self.header = header

    def write_model_inject_state(self):


        def rename_sample_rec(sexpr: list):
            match sexpr:
                case ["call", ["Identifier", "sample"], *args]:
                    return ["call", ["Identifier", "sample_record_state"], *[rename_sample_rec(arg) for arg in args]]
            if len(sexpr) == 2 and not isinstance(sexpr[1], list):
                return sexpr
            else:
                return [sexpr[0]] + [rename_sample_rec(child) for child in sexpr[1:]]
            
        def copy_sexpr(sexpr: list, old_sexpr_to_node: Dict[Any,JuliaSyntaxNode], new_sexpr_to_node: Dict[Any,JuliaSyntaxNode]):
            if len(sexpr) == 2 and not isinstance(sexpr[1], list):
                copied_sexpr = deepcopy(sexpr)
            else:
                copied_sexpr = [sexpr[0]] + [copy_sexpr(child, old_sexpr_to_node, new_sexpr_to_node) for child in sexpr[1:]]
            new_sexpr_to_node[id(copied_sexpr)] = old_sexpr_to_node[id(sexpr)]
            return copied_sexpr

        visitor = SexprToNodeVisitor()
        visitor.visit(self.model_function.syntaxnode)
        old_sexpr_to_node = visitor.sexpr_to_node

        sexpr_to_node: Dict[Any,JuliaSyntaxNode] = dict()

        model_sexpr = copy_sexpr(self.model_function.syntaxnode.sexpr, old_sexpr_to_node, sexpr_to_node)

        assert model_sexpr[0] == "function"
        signature = model_sexpr[1]
        assert signature[0] == "call"
        assert signature[2] == ["::-i", ["Identifier", "ctx"], ["Identifier", "SampleContext"]]
        signature[2][2][1] = "AbstractGenerateRecordStateContext"
        signature.append(['::-i', ['Identifier', self.state_var], ['Identifier', 'State']])
        # pprint(model_sexpr)

        def get_cfgnode_for_syntaxnode(syntaxnode: JuliaSyntaxNode):
            for cfgnode in self.model.nodes:
                if isinstance(cfgnode, JuliaSampleNode):
                    value_expr = cfgnode.get_value_expr()
                    assert isinstance(value_expr, JuliaExpression)
                    if value_expr.syntaxnode == syntaxnode:
                        return cfgnode
                if isinstance(cfgnode, JuliaFactorNode):
                    value_expr = cfgnode.get_factor_expr()
                    assert isinstance(value_expr, JuliaExpression)
                    if value_expr.syntaxnode == syntaxnode:
                        return cfgnode
            raise Exception(f"CFGNode not found for {syntaxnode}")

        def _inject_state_rec(sexpr: list):
            match sexpr:
                case ["Identifier", name] if name in self.var_names:
                    return [".", ["Identifier", self.state_var], ["quote", [name]]]
                case ["call", ["Identifier", "sample"], ctx, *args]:
                    # node.id[5:] == node_ + int
                    syntaxnode = sexpr_to_node[id(sexpr)]
                    node = get_cfgnode_for_syntaxnode(syntaxnode)
                    return ["call", ["Identifier", "sample"], ctx, ["Identifier", self.state_var], ["Integer", node.id[5:]], *[_inject_state_rec(arg) for arg in args]]
    
            if len(sexpr) == 2 and not isinstance(sexpr[1], list):
                return sexpr
            else:
                return [sexpr[0]] + [_inject_state_rec(child) for child in sexpr[1:]]
    

        model_sexpr = _inject_state_rec(model_sexpr)
        model_sexpr = rename_sample_rec(model_sexpr)
        self.out += unparse(model_sexpr) + "\n\n"

    def get_prefix(self, addr: JuliaExpression):
        node = addr.syntaxnode
        while node.kind != "string":
            assert node.kind == "call-i"
            node = node[1]
        return node
    
    def write_combined_factors(self):
        addr_var = "_addr_"
        self.addr_var = addr_var
        signature = deepcopy(self.model_function.syntaxnode.sexpr[1])
        assert signature[0] == "call"
        assert signature[2] == ["::-i", ["Identifier", "ctx"], ["Identifier", "SampleContext"]]
        signature[1] = ["Identifier", signature[1][1] + "_factor"] # name
        signature[2][2][1] = "AbstractFactorResampleContext"
        signature.append(['::-i', ['Identifier', self.state_var], ['Identifier', 'State']])
        signature.append(['::-i', ['Identifier', addr_var], ['Identifier', 'String']])

        prog = "function "
        prog += unparse(signature) + "\n"
        tab = "    "
        
        for prefix, samplenode in self.prefixed_sample_nodes:
            node_id = samplenode.id[5:]
            prog += tab + f"if {self.state_var}.node_id == {node_id}\n"

            signature = deepcopy(self.model_function.syntaxnode.sexpr[1])
            assert signature[0] == "call"
            signature[1] = ["Identifier", signature[1][1] + "_" + prefix.strip('"')] # name
            for i in range(2, len(signature)):
                if signature[i][0] == "::-i":
                    signature[i] = signature[i][1]
            signature.append(['Identifier', self.state_var])

            prog += tab + tab + "return " + unparse(signature) + "\n"
            prog += tab + "end\n"
        prog += tab + f"error(\"Cannot find factor for ${self.addr_var} ${self.state_var}\")\n"
        prog += "end\n\n"
        self.out += prog


    def write_helpers(self):
        prog = "function model(ctx::SampleContext)\n"
        signature = deepcopy(self.model_function.syntaxnode.sexpr[1])
        for i in range(2, len(signature)):
            if signature[i][0] == "::-i":
                signature[i] = signature[i][1]
        prog += "    return " + unparse(signature) + "\n"
        prog += "end\n\n"

        prog += f"function model(ctx::AbstractGenerateRecordStateContext, {self.state_var}::State)\n"
        signature = deepcopy(self.model_function.syntaxnode.sexpr[1])
        signature.append(['Identifier', self.state_var])
        for i in range(2, len(signature)):
            if signature[i][0] == "::-i":
                signature[i] = signature[i][1]
        prog += "    return " + unparse(signature) + "\n"
        prog += "end\n\n"

        prog += f"function factor(ctx::AbstractFactorResampleContext, {self.state_var}::State, {self.addr_var}::String)\n"
        signature = deepcopy(self.model_function.syntaxnode.sexpr[1])
        signature[1] = ["Identifier", signature[1][1] + "_factor"] # name
        signature.append(['Identifier', self.state_var])
        signature.append(['Identifier', self.addr_var])
        for i in range(2, len(signature)):
            if signature[i][0] == "::-i":
                signature[i] = signature[i][1]
        prog += "    return " + unparse(signature) + "\n"
        prog += "end\n"


        self.out += prog

    def write_program(self):

        self.out = "# this file is auto-generated\n\n"
        self.out += f"include(\"../{self.filename}\")\n\n"

        # self.out += unparse(self.model_function.syntaxnode.sexpr) + "\n\n"

        self.write_state_struct()
        self.write_model_inject_state()

        prefixed_sample_nodes = []
        for samplenode in self.sample_nodes:
            addr_expr = samplenode.get_address_expr()
            assert isinstance(addr_expr, JuliaExpression)
            prefix = unparse(self.get_prefix(addr_expr).sexpr).strip('"') + "_" + samplenode.id[5:]
            prefixed_sample_nodes.append((prefix, samplenode))
        prefixed_sample_nodes = sorted(prefixed_sample_nodes)
        self.prefixed_sample_nodes = prefixed_sample_nodes

        for prefix, samplenode in self.prefixed_sample_nodes:
            deps = {y for x, y in self.model_graph_edges if x == samplenode}

            signature = deepcopy(self.model_function.syntaxnode.sexpr[1])
            assert signature[0] == "call"
            assert signature[2] == ["::-i", ["Identifier", "ctx"], ["Identifier", "SampleContext"]]
            signature[1] = ["Identifier", signature[1][1] + "_" + prefix] # name
            signature[2][2][1] = "AbstractFactorResampleContext"
            signature.append(['::-i', ['Identifier', self.state_var], ['Identifier', 'State']])

            prog = "function "
            prog += unparse(signature) + "\n"

            tab = "    "
            # header_prog = tab + f"\n{tab}".join(map(unparse, self.header)) + "\n\n"
            # prog += header_prog

            writer = FactorFunctionWriter(self.model, samplenode, deps, self.direct_paths)
            writer.write_factor_function(samplenode, tab=tab)
            prog += writer.out

            prog += "end\n\n"
            
            self.out += prog

        self.write_combined_factors()

        self.write_helpers()

    
