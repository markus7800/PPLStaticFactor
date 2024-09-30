from typing import Set, Dict, List, Any
from .cfg import *
from functools import reduce
from .rd_bp import *

class PPL_IR:
    def __init__(self, cfgs: Dict[FunctionDefinition,CFG], model_cfg: Optional[CFG] = None, guide_cfg: Optional[CFG] = None) -> None:
        self.cfgs = cfgs
        self.node_to_cfg = {node: (fdef, cfg) for fdef, cfg in cfgs.items() for node in cfg.nodes}
        self.model_cfg = model_cfg
        self.guide_cfg = guide_cfg

    def is_user_defined_function(self, variable: Variable) -> bool:
        return any(fdef.is_equal(variable) for fdef, _ in self.cfgs.items())

    def get_user_defined_function(self, variable: Variable) -> CFG:
        for fdef, fcfg in self.cfgs.items():
            if fdef.is_equal(variable):
                return fcfg
        raise ValueError
    
    def get_model(self) -> Optional[CFG]:
        return self.model_cfg
    
    def get_guide(self) -> Optional[CFG]:
        return self.guide_cfg

    
    def get_cfg_for_node(self, cfgnode: CFGNode) -> Tuple[FunctionDefinition,CFG]:
        return self.node_to_cfg[cfgnode]

    def get_sample_nodes(self) -> List[SampleNode]:
        nodes: List[SampleNode] = list()
        for _, cfg in self.cfgs.items():
            nodes.extend([node for node in cfg.nodes if isinstance(node, SampleNode)])
        return nodes
    
    def get_factor_nodes(self) -> List[FactorNode]:
        nodes: List[FactorNode] = list()
        for _, cfg in self.cfgs.items():
            nodes.extend([node for node in cfg.nodes if isinstance(node, FactorNode)])
        return nodes

    def get_data_deps_for_expr(self, cfgnode: CFGNode, expr: Expression) -> List[AbstractAssignNode]:
        return list(data_deps_for_expr(self, cfgnode, expr))
    
    def get_control_deps_for_node(self, cfgnode: CFGNode, expr: Expression) -> List[BranchNode]:
        return list(control_parents_for_expr(self, cfgnode, expr))


def data_deps_for_expr(ir: PPL_IR, cfgnode: CFGNode, expr: Expression) -> Set[AbstractAssignNode]:
    if isinstance(cfgnode, FuncArgNode):
        fdef, _ = ir.get_cfg_for_node(cfgnode)
        data_deps: Set[AbstractAssignNode] = set()
        return data_deps
    else:
        variables = expr.get_free_variables()

        data_deps: Set[AbstractAssignNode] = set()
        for variable in variables:
            if ir.is_user_defined_function(variable):
                function_cfg = ir.get_user_defined_function(variable)
                for returnnode in function_cfg.nodes:
                    if isinstance(returnnode, ReturnNode):
                        data_deps = data_deps | data_deps_for_expr(ir, returnnode, returnnode.get_return_expr())
            else:
                rds = get_RDs(cfgnode, variable)
                data_deps = data_deps | rds

        return data_deps


def control_parents_for_expr(ir: PPL_IR, cfgnode: CFGNode, expr: Expression) -> Set[BranchNode]:
    fdef, cfg = ir.get_cfg_for_node(cfgnode)
    assert cfgnode in cfg.nodes

    if isinstance(cfgnode, FuncArgNode):
        bps: Set[BranchNode] = set()      
        return bps
    else:
        bps = get_BPs(cfg, cfgnode)

        variables = expr.get_free_variables()
        for variable in variables:
            if ir.is_user_defined_function(variable):
                function_cfg = ir.get_user_defined_function(variable)
                for returnnode in function_cfg.nodes:
                    if isinstance(returnnode, ReturnNode):
                        bps = bps | control_parents_for_expr(ir, returnnode, returnnode.get_return_expr())

        return bps