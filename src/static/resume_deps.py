
from collections import deque
from .ir import * 
from typing import Deque, Tuple, List

def get_resume_deps(cfgnode: CFGNode, break_at_sample: bool, add_end_node: bool):

    marked: Set[CFGNode] = set()
    # we recursively get all data and control dependencies of random variable node
    queue: Deque[CFGNode] = deque()
    queue.append(cfgnode)
    
    resume_deps: Set[SampleNode | FactorNode | EndNode] = set()

    while len(queue) > 0:
        # get next node, FIFO
        node = queue.popleft()
        
        for child in node.children:
            if child not in marked:
                if isinstance(child, FactorNode):
                    resume_deps.add(child)
                elif break_at_sample and isinstance(child, SampleNode):
                    resume_deps.add(child)
                elif add_end_node and isinstance(child, EndNode):
                    resume_deps.add(child)
                else:
                    queue.append(child)
                marked.add(child)

    return resume_deps
