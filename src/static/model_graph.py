
from collections import deque
from .ir import * 
from typing import Deque, Tuple, List

DEBUG_GRAPH = False
def get_graph(program_ir: PPL_IR):

    random_stmts = program_ir.get_sample_nodes() + program_ir.get_factor_nodes()

    edges = []

    for r in random_stmts:
        if DEBUG_GRAPH: print(r)
        marked: Set[CFGNode] = set()
        # we recursively get all data and control dependencies of random variable node
        queue: Deque[Tuple[CFGNode,Expression]] = deque()
        if isinstance(r, SampleNode):
            queue.append((r, r.get_address_expr()))
            queue.append((r, r.get_distribution_expr()))
        else:
            queue.append((r, r.get_factor_expr()))

        while len(queue) > 0:
            # get next node, FIFO
            node, expr = queue.popleft()
            if DEBUG_GRAPH: print("| pop", expr)

            # get all data dependencies
            for dep in program_ir.get_data_deps_for_expr(node, expr):
                if DEBUG_GRAPH: print("| | dp", dep)
                # check if we have already processed node
                if dep not in marked:
                    if isinstance(dep, SampleNode):
                        # if node is random variable, we only push the address expression into the queue and add edge to graph
                        edges.append((dep, r))
                        queue.append((dep, dep.get_address_expr()))
                        if DEBUG_GRAPH: print("| | | edge ", dep, "->", r)
                        if DEBUG_GRAPH: print("| | | add ", dep.get_address_expr())

                    else:
                        queue.append((dep, dep.get_value_expr()))
                        if DEBUG_GRAPH: print("| | | add ", dep.get_value_expr())

                    marked.add(dep)
            
            # get all control dependencies
            # we can move this loop outside (in contrast to Algorithm 1),
            # since for the factor dependencies we want to include the control dependencies of r
            for dep in program_ir.get_control_deps_for_node(node, expr):
                if DEBUG_GRAPH: print("| | bp", dep)
                if dep not in marked:
                    if DEBUG_GRAPH: print("| | | add ", dep.get_test_expr())
                    queue.append((dep, dep.get_test_expr()))
                    marked.add(dep)
                    

    return random_stmts, edges
