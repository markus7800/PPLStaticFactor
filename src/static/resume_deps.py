
from collections import deque
from .ir import * 
from typing import Deque, Tuple, List

DEBUG_RESUME_DEPS = False
def get_resume_deps(cfgnode: CFGNode):

    marked: Set[CFGNode] = set()
    # we recursively get all data and control dependencies of random variable node
    queue: Deque[CFGNode] = deque()
    queue.append(cfgnode)
    
    resume_deps: Set[SampleNode | FactorNode] = set()

    while len(queue) > 0:
        # get next node, FIFO
        node = queue.popleft()
        
        for child in node.children:
            if child not in marked:
                if isinstance(child, (SampleNode,FactorNode)):
                    resume_deps.add(child)
                else:
                    queue.append(child)
                marked.add(child)

    return resume_deps
