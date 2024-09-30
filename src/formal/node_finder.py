from .syntaxnode import JuliaSyntaxNode
from typing import Any, Callable, List, Optional

class NodeVisitor:
    # override this method:
    def visit(self, node: JuliaSyntaxNode) -> Any:
        self.generic_visit(node)

    def generic_visit(self, node: JuliaSyntaxNode):
        for child in node.children:
            self.visit(child)

class NodeFinder(NodeVisitor):
    def __init__(self,
                 predicate: Callable[[JuliaSyntaxNode], bool],
                 map: Callable[[JuliaSyntaxNode], Any],
                 visit_matched_nodes: bool = False,
                 visit_predicate: Optional[Callable[[JuliaSyntaxNode],bool]]=None):
        
        super().__init__()
        self.predicate = predicate
        self.map = map
        if visit_predicate is None:
            if visit_matched_nodes:
                visit_predicate = lambda _: True
            else:
                visit_predicate = lambda node: not predicate(node)
        self.visit_predicate: Callable[[JuliaSyntaxNode],bool] = visit_predicate
        self.result: List[Any] = []

    def visit(self, node):
        if self.predicate(node):
            self.result.append(self.map(node))
        if self.visit_predicate(node):
            self.generic_visit(node)
            
        return self.result