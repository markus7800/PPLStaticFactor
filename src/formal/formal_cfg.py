from copy import copy
from static.cfg import *

from static.cfg import AssignTarget, Dict, Distribution, Expression, FunctionDefinition, Variable
from formal.syntaxnode import *
from formal.node_finder import *
from static.ir import PPL_IR
from typing import Any, List
from static.base_cfg import AbstractCFGBuilder
from typing import Callable
from pprint import pprint

class JuliaVariable(Variable):
    def __init__(self, syntaxnode: JuliaSyntaxNode) -> None:
        super().__init__()
        assert syntaxnode.kind == "Identifier"
        self.syntaxnode = syntaxnode
        self.name = syntaxnode.value
    def __eq__(self, value: object) -> bool:
        if isinstance(value, JuliaVariable):
            return self.syntaxnode == value.syntaxnode
        else:
            return False
    def __hash__(self) -> int:
        return hash(self.syntaxnode)
    
    def __repr__(self) -> str:
        return f"PythonVariable({self.name})"

class JuliaAssignTarget(AssignTarget):
    def __init__(self, syntaxnode: JuliaSyntaxNode) -> None:
        super().__init__()
        assert syntaxnode.kind in ("Identifier", "::-i"), f"Wrong syntaxnode kind in JuliaAssignTarget {syntaxnode.kind}"
        self.syntaxnode = syntaxnode

        if syntaxnode.kind == "Identifier":
            self.name = syntaxnode.value
        else:
            assert syntaxnode[1].kind == "Identifier"
            self.name = syntaxnode[1].value
    
    def is_equal(self, variable: Variable) -> bool:
        assert isinstance(variable, JuliaVariable)
        return self.name == variable.name

    def __repr__(self) -> str:
        return unparse(self.syntaxnode.sexpr)

class JuliaExpression(Expression):
    def __init__(self, syntaxnode: JuliaSyntaxNode) -> None:
        super().__init__()
        self.syntaxnode = syntaxnode
    def __eq__(self, value: object) -> bool:
        if isinstance(value, JuliaExpression):
            return self.syntaxnode == value.syntaxnode
        else:
            return False
    def __hash__(self) -> int:
        return hash(self.syntaxnode)

    def get_free_variables(self) -> List[Variable]:
        name_finder = NodeFinder(
            lambda node: node.kind == "Identifier",
            lambda node: JuliaVariable(node)) # this also returns variable names for user-defined functions
        return name_finder.visit(self.syntaxnode)
    
    def __repr__(self) -> str:
        return unparse(self.syntaxnode.sexpr)
    
class EmptyJuliaExpression(JuliaExpression):
    def __init__(self) -> None:
        pass
    def __hash__(self) -> int:
        return 0
    def __eq__(self, value: object) -> bool:
        return isinstance(value, EmptyJuliaExpression)
    def get_free_variables(self) -> List[Variable]:
        return list()
    def __repr__(self) -> str:
        return "<>"
    
def get_only_elem(s: Set[CFGNode]) -> CFGNode:
    assert len(s) == 1
    return list(s)[0]

class JuliaFunctionDefinition(FunctionDefinition):
    def __init__(self, syntaxnode: JuliaSyntaxNode) -> None:
        super().__init__()
        assert syntaxnode.kind in ("toplevel", "function")
        self.syntaxnode = syntaxnode
        self.name = ""
        if syntaxnode.kind == "function":
            self.name = syntaxnode[1][1].value
        else:
            self.name = "Toplevel"
            self.scope = None

    def is_equal(self, variable: Variable) -> bool:
        return False # TODO
        
    def __repr__(self) -> str:
        if self.syntaxnode.kind == "toplevel":
            return "JuliaFunctionDefinition(Main)"
        else:
            return f"JuliaFunctionDefinition({self.name})"
        
def get_address_expr_from_sample_call(expr: Expression) -> Expression:
    assert isinstance(expr, JuliaExpression)
    assert expr.syntaxnode.kind == "call"
    return JuliaExpression(expr.syntaxnode[3])
    
class JuliaSampleNode(SampleNode):
    def get_distribution_expr(self) -> Expression:
        value_expr = self.get_value_expr()
        assert isinstance(value_expr, JuliaExpression)
        assert value_expr.syntaxnode.kind == "call"
        return JuliaExpression(value_expr.syntaxnode[4])
    
    def get_distribution(self) -> Distribution:
        raise NotImplementedError

    def get_address_expr(self) -> Expression:
        value_expr = self.get_value_expr()
        return get_address_expr_from_sample_call(value_expr)
    
    def symbolic_name(self) -> str:
        raise NotImplementedError

class JuliaFactorNode(FactorNode):
    def __init__(self, id: str, factor_expression: Expression) -> None:
        super().__init__(id, factor_expression)
    def get_distribution(self) -> Distribution:
        raise NotImplementedError

class JuliaCFGBuilder(AbstractCFGBuilder):
    def __init__(self, node_to_id: Dict[JuliaSyntaxNode,str]) -> None:
        self.node_to_id = node_to_id
        self.cfgs: Dict[FunctionDefinition,CFG] = dict() # toplevel -> CFG, functiondef -> CFG

    def is_random_variable_definition(self, node: JuliaSyntaxNode) -> bool:
        match node:
            case JuliaSyntaxNode(kind="=", children=[_, JuliaSyntaxNode(kind="call", children=[JuliaSyntaxNode(kind="Identifier",value="sample"), *_])]):
                return True
            # case JuliaSyntaxNode(kind="call", children=[JuliaSyntaxNode(kind="Identifier",value="sample"), *_]):
            #     return True
        return False
    
    def is_observed(self, node: JuliaSyntaxNode) -> bool:
        args = None
        match node:
            case JuliaSyntaxNode(kind="=", children=[_, JuliaSyntaxNode(kind="call", children=[JuliaSyntaxNode(kind="Identifier",value="sample"), *_args])]):
                args = _args
            # case JuliaSyntaxNode(kind="call", children=[JuliaSyntaxNode(kind="Identifier",value="sample"), *_args]):
            #     args = _args
            case _:
                return False
        match args:
            case [ctx, addr, dist, JuliaSyntaxNode(kind="parameters", children=[JuliaSyntaxNode(kind="=", children=[JuliaSyntaxNode(kind="Identifier", value="observed"), _])])]:
                return True
            case [ctx, addr, dist, JuliaSyntaxNode(kind="=", children=[JuliaSyntaxNode(kind="Identifier", value="observed"), _])]:
                return True
        return False
        
    def is_supported_expression(self, node: JuliaSyntaxNode) -> bool:
        return node.kind in ("call", "using")

    def get_cfg(self, node: JuliaSyntaxNode, breaknode:Optional[JoinNode], continuenode:Optional[JoinNode], returnnode:Optional[JoinNode]) -> CFG: # type: ignore
        node_id = self.node_to_id[node]

        startnode = StartNode(node_id)
        nodes: Set[CFGNode] = set()
        endnode = EndNode(node_id)


        if node.kind == "toplevel" or node.kind=="block":
            # concatentate all children if they are not functions
            # S_i -> CFG_i -> E_i
            # => S -> CFG_1 -> ... CFG_n -> E
            current_node: CFGNode = startnode
            for child in node.children:
                child_node_id = self.node_to_id[child]
                if child.kind == "function":
                    function_cfg = self.get_function_cfg(child)
                    self.cfgs[JuliaFunctionDefinition(child)] = function_cfg
                elif child.kind == "macrocall" and child[2].kind == "function":
                    function_cfg = self.get_function_cfg(child[2])
                    self.cfgs[JuliaFunctionDefinition(child[2])] = function_cfg

                elif child.kind in ("return", "break", "continue"):
                    if child.kind == "return":
                        if len(child.children) > 0:
                            special_node = ReturnNode(child_node_id, JuliaExpression(child[1]))
                        else:
                            special_node = ReturnNode(child_node_id, EmptyJuliaExpression())
                        goto_node = returnnode
                    elif child.kind  == "break":
                        special_node = BreakNode(child_node_id)
                        goto_node = breaknode
                    else: # child.kind == "continue":
                        special_node = ContinueNode(child_node_id)
                        goto_node = continuenode
                    
                    # CFG_i -> SPECIAL_NODE -> GOTO_NODE
                    nodes.add(special_node)
                    add_edge(current_node, special_node)
                    current_node = special_node
                    assert goto_node is not None
                    add_edge(current_node, goto_node)
                    break

                else:
                    child_cfg = self.get_cfg(child, breaknode, continuenode, returnnode)
                    nodes = nodes.union(child_cfg.nodes)

                    N1 = get_only_elem(child_cfg.startnode.children) # node after start node
                    N2 = get_only_elem(child_cfg.endnode.parents)    # node before end node

                    delete_edge(child_cfg.startnode, N1)
                    add_edge(current_node, N1)
                    delete_edge(N2, child_cfg.endnode)
                    
                    # parents come from sub-cfg
                    current_node = N2

            add_edge(current_node, endnode)


        elif node.kind == "=":
            # S -> Assign -> E
            if self.is_random_variable_definition(node):
                # print(ast.dump(node.ast_node))
                if self.is_observed(node):
                    cfgnode = JuliaFactorNode(
                        node_id,
                        JuliaExpression(node[2])
                    )
                else:
                    cfgnode = JuliaSampleNode(
                        node_id,        
                        JuliaAssignTarget(node[1]),
                        JuliaExpression(node[2])
                    )
            else:
                cfgnode = AssignNode(
                    node_id,
                    JuliaAssignTarget(node[1]),
                    JuliaExpression(node[2])
                )
            nodes.add(cfgnode)
            add_edge(startnode, cfgnode)
            add_edge(cfgnode, endnode)
            
        elif node.kind in ("if", "elseif"):
            test_node = node[1]
            
            branch_cfgnode = BranchNode(node_id + "_if_start", JuliaExpression(test_node))
            branch_join_cfgnode = JoinNode(node_id + "_if_end")
            branch_cfgnode.join_nodes.add(branch_join_cfgnode)

            consequent = node[2]
            alternative = node[3] if len(node.children) > 2 else None

            self.build_if_cfg(startnode, nodes, endnode, branch_cfgnode, branch_join_cfgnode, consequent, alternative, continuenode, breaknode, returnnode)
            
        elif node.kind == "while":
            # S_body -> CFG_body -> E_body
            # => S -> Branch -> CFG_body \
            #           |   \<-----------/
            #            \> Join -> E   
            test_node = node[1]

            while_start_join_cfgnode = JoinNode(node_id + "_while_start")
            while_branch_cfgnode = BranchNode(node_id + "_while_test", JuliaExpression(test_node))
            while_end_join_cfgnode = JoinNode(node_id + "_while_end")

            while_branch_cfgnode.join_nodes.add(while_start_join_cfgnode)
            while_branch_cfgnode.join_nodes.add(while_end_join_cfgnode)

            body = node[2]

            self.build_while_cfg(startnode, nodes, endnode, while_start_join_cfgnode, while_branch_cfgnode, while_end_join_cfgnode, body, returnnode)

        
        elif node.kind == "for":
            loop_var = node[1]
            body = node[2]

            for_start_join_cfgnode = JoinNode(node_id + "_for_start")
            for_branch_cfgnode = BranchNode(node_id + "_for_iter", JuliaExpression(loop_var))
            for_end_join_cfgnode = JoinNode(node_id + "_for_end")

            loop_var_cfgnode = LoopIterNode(
                node_id, 
                JuliaAssignTarget(loop_var[1]),
                JuliaExpression(loop_var[2])
            )

            self.build_for_cfg(startnode, nodes, endnode, for_start_join_cfgnode, for_branch_cfgnode, for_end_join_cfgnode, loop_var_cfgnode, body, returnnode)
            
        elif self.is_supported_expression(node):
            cfgnode = ExprNode(node_id, JuliaExpression(node))
            nodes.add(cfgnode)
            add_edge(startnode, cfgnode)
            add_edge(cfgnode, endnode)
        else:
            raise Exception(f"Unsupported node kind: {node.kind} sexpr: {node.sexpr}")


        cfg =  CFG(startnode, nodes, endnode)


        try:
            verify_cfg(cfg)
        except Exception:
            print(pprint(node.sexpr))
            print_cfg_dot(cfg)
            raise


        if node.kind == "toplevel":
            self.cfgs[JuliaFunctionDefinition(node)] = cfg
            return cfg
        
        return cfg
    

    def fix_return(self, nodes: Set[CFGNode], func_join_node: CFGNode):
        for node in nodes:
            if isinstance(node, ReturnNode):
                discard = [child for child in node.children if child != func_join_node]
                for child in discard:
                    delete_edge(node, child)
        
    def get_parameter_nodes_of_function(self, func: JuliaSyntaxNode):
        parameters: list[JuliaSyntaxNode] = list()
        assert func.kind == "function"
        if func[1].kind == "::":
            call = func[1][1]
            # typed return
        else:
            call = func[1]
        assert call.kind == "call"
        for child in call.children[1:]: # 1 is function name
            if child.kind == "parameters":
                # named parameters
                for c in child.children:
                    parameters.append(c)
            else:
                parameters.append(child)

        return parameters

    def get_function_cfg(self, node: JuliaSyntaxNode): # type: ignore
        # assert node.is_kind(ast.FunctionDef)
        assert node.kind == "function"
        node_id = self.node_to_id[node]
        func_signature = unparse(node[1].sexpr)
        func_body = node[2]

        # all returns go to join node
        func_join_cfgnode = JoinNode(node_id + "_func")
        # return stmts "break" to join_node, no continuenode
        body_cfg = self.get_cfg(func_body, None, None, func_join_cfgnode)

        nodes = copy(body_cfg.nodes)
        nodes.add(func_join_cfgnode)

        # FUNCSTART -> FUNCARG1 -> FUNCARG2 ...
        startnode = FuncStartNode(node_id, func_signature)
        current_node = startnode
        
        for i, p in enumerate(self.get_parameter_nodes_of_function(node)):
            funcarg_node_id = self.node_to_id[p]
            name = p[1].value if p.kind == "::-i" else p.value
            # print(i, f"param({name})", p, p.sexpr,)
            funcarg_node = FuncArgNode(funcarg_node_id, JuliaAssignTarget(p), EmptyJuliaExpression(), name, i)
            add_edge(current_node, funcarg_node)
            nodes.add(funcarg_node)
            current_node = funcarg_node
        
        endnode = EndNode(node_id)

        N1 = get_only_elem(body_cfg.startnode.children) # node after start node
        N2 = get_only_elem(body_cfg.endnode.parents)    # node before end node

        delete_edge(N2, body_cfg.endnode)
        delete_edge(body_cfg.startnode, N1)
        
        # FUNCARGS -> BODY
        add_edge(current_node, N1)
        # BODY -> JOIN_NODE -> END
        add_edge(N2, func_join_cfgnode)
        add_edge(func_join_cfgnode, endnode)

        self.fix_return(nodes, func_join_cfgnode)


        cfg = CFG(startnode, nodes, endnode)

        try:
            verify_cfg(cfg)
        except Exception:
            print_cfg_dot(cfg)
            raise
        return cfg
    
    

class NodeIdAssigner(NodeVisitor):
    def __init__(self) -> None:
        self.node_to_id: Dict[JuliaSyntaxNode, str] = {}
        self.id_to_node: Dict[str, JuliaSyntaxNode] = {}

    def visit(self, node: JuliaSyntaxNode):
        i = f"node_{len(self.node_to_id) + 1}"
        self.node_to_id[node] = i
        self.id_to_node[i] = node

        self.generic_visit(node)


def preproc_observed(sexpr: list):
    match sexpr:
        case ["=", _, ["call", ["Identifier", "sample"], *_]]:
            return sexpr
        case ["call", ["Identifier", "sample"], ctx, addr, dist, ["=", ["Identifier", "observed"], val]]:
            return ["=", ["Identifier", "_"], ["call", ["Identifier", "sample"], ctx, addr, dist, ["=", ["Identifier", "observed"], val]]]
        case ["call", ["Identifier", "sample"], ctx, addr, dist, ["parameters", ["=", ["Identifier", "observed"], val]]]:
            return ["=", ["Identifier", "_"], ["call", ["Identifier", "sample"], ctx, addr, dist, ["=", ["Identifier", "observed"], val]]]
    
    if len(sexpr) == 2 and not isinstance(sexpr[1], list):
        return sexpr
    else:
        return [sexpr[0]] + [preproc_observed(child) for child in sexpr[1:]]

import subprocess
import sexpdata
def get_IR_for_formal(filename, unroll_loops=False):
    cmd = ["julia", "--project=.", "src/formal/ast.jl", filename]
    if unroll_loops:
        cmd.append("--unroll_loops")
    res = subprocess.run(cmd, capture_output=True)
    julia_ast = res.stdout.decode("utf-8")
    if julia_ast == "":
        err = res.stderr.decode("utf-8")
        raise Exception(f"Parsing Julia AST failed for {filename}:\n{err}")    
    sexpr = sexpdata.loads(julia_ast)
    sexpr = sym_to_str(sexpr)
    # pprint(sexpr)
    sexpr = preproc_observed(sexpr) # type: ignore
    # unparsed = unparse(sexpr) # type: ignore
    # print(unparsed)
    # pprint(sexpr)

    assert isinstance(sexpr, list)
    syntaxtree = make_syntaxtree(sexpr)
    # syntaxtree.pprint()

    visitor = NodeIdAssigner()
    visitor.visit(syntaxtree)

    cfgbuilder = JuliaCFGBuilder(visitor.node_to_id)

    cfgbuilder.get_cfg(syntaxtree, None, None, None)
    for fdef, cfg in cfgbuilder.cfgs.items():
        assert isinstance(fdef, JuliaFunctionDefinition)
        # plot_cfg(cfg, f"tmp/{fdef.name}")
        assert verify_cfg(cfg)

    return PPL_IR(
        cfgbuilder.cfgs,
        model_cfg=next(
            cfg for fdef, cfg in cfgbuilder.cfgs.items()
            if isinstance(fdef, JuliaFunctionDefinition) and fdef.syntaxnode.parent and fdef.syntaxnode.parent.kind == "macrocall" and fdef.syntaxnode.parent[1].value == "@model"
        ))