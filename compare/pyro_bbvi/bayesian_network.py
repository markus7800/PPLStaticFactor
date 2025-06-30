import torch
from bbvi import continuous_vd, discrete_vd, VarTracking_SVI, VarTracking_Trace_ELBO, VarTracking_TraceGraph_ELBO
import pyro
import pyro.distributions as dist
import pyro.distributions.transforms as transforms
import math
from pyro.optim import Adam # type: ignore
from tqdm.auto import tqdm

modelname = "bayesian_network"

def get_cpt_0(CPTs, addr: str):
    return CPTs[addr]

def get_cpt_1(CPTs, addr: str, ix1):
    return CPTs[addr][ix1]

def get_cpt_2(CPTs, addr: str, ix1, ix2):
    return CPTs[addr][ix1][ix2]

def get_cpt_3(CPTs, addr: str, ix1, ix2, ix3):
    return CPTs[addr][ix1][ix2][ix3]


def get_cpt_4(CPTs, addr: str, ix1, ix2, ix3, ix4):
    return CPTs[addr][ix1][ix2][ix3][ix4]


def model():
    MINVOLSET = pyro.sample("MINVOLSET", dist.Categorical(get_cpt_0(CPTs, "MINVOLSET")))
    VENTMACH = pyro.sample("VENTMACH", dist.Categorical(get_cpt_1(CPTs, "VENTMACH", MINVOLSET)))
    DISCONNECT = pyro.sample("DISCONNECT", dist.Categorical(get_cpt_0(CPTs, "DISCONNECT")))
    VENTTUBE = pyro.sample("VENTTUBE", dist.Categorical(get_cpt_2(CPTs, "VENTTUBE", DISCONNECT, VENTMACH)))
    INTUBATION = pyro.sample("INTUBATION", dist.Categorical(get_cpt_0(CPTs, "INTUBATION")))
    PULMEMBOLUS = pyro.sample("PULMEMBOLUS", dist.Categorical(get_cpt_0(CPTs, "PULMEMBOLUS")))
    PAP = pyro.sample("PAP", dist.Categorical(get_cpt_1(CPTs, "PAP", PULMEMBOLUS)))
    SHUNT = pyro.sample("SHUNT", dist.Categorical(get_cpt_2(CPTs, "SHUNT", INTUBATION, PULMEMBOLUS)))
    FIO2 = pyro.sample("FIO2", dist.Categorical(get_cpt_0(CPTs, "FIO2")))
    KINKEDTUBE = pyro.sample("KINKEDTUBE", dist.Categorical(get_cpt_0(CPTs, "KINKEDTUBE")))
    PRESS = pyro.sample("PRESS", dist.Categorical(get_cpt_3(CPTs, "PRESS", INTUBATION, KINKEDTUBE, VENTTUBE)))
    VENTLUNG = pyro.sample("VENTLUNG", dist.Categorical(get_cpt_3(CPTs, "VENTLUNG", INTUBATION, KINKEDTUBE, VENTTUBE)))
    MINVOL = pyro.sample("MINVOL", dist.Categorical(get_cpt_2(CPTs, "MINVOL", INTUBATION, VENTLUNG)))
    VENTALV = pyro.sample("VENTALV", dist.Categorical(get_cpt_2(CPTs, "VENTALV", INTUBATION, VENTLUNG)))
    ARTCO2 = pyro.sample("ARTCO2", dist.Categorical(get_cpt_1(CPTs, "ARTCO2", VENTALV)))
    EXPCO2 = pyro.sample("EXPCO2", dist.Categorical(get_cpt_2(CPTs, "EXPCO2", ARTCO2, VENTLUNG)))
    PVSAT = pyro.sample("PVSAT", dist.Categorical(get_cpt_2(CPTs, "PVSAT", FIO2, VENTALV)))
    SAO2 = pyro.sample("SAO2", dist.Categorical(get_cpt_2(CPTs, "SAO2", PVSAT, SHUNT)))
    ANAPHYLAXIS = pyro.sample("ANAPHYLAXIS", dist.Categorical(get_cpt_0(CPTs, "ANAPHYLAXIS")))
    TPR = pyro.sample("TPR", dist.Categorical(get_cpt_1(CPTs, "TPR", ANAPHYLAXIS)))
    INSUFFANESTH = pyro.sample("INSUFFANESTH", dist.Categorical(get_cpt_0(CPTs, "INSUFFANESTH")))
    CATECHOL = pyro.sample("CATECHOL", dist.Categorical(get_cpt_4(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH, SAO2, TPR)))
    HR = pyro.sample("HR", dist.Categorical(get_cpt_1(CPTs, "HR", CATECHOL)))
    ERRCAUTER = pyro.sample("ERRCAUTER", dist.Categorical(get_cpt_0(CPTs, "ERRCAUTER")))
    HREKG = pyro.sample("HREKG", dist.Categorical(get_cpt_2(CPTs, "HREKG", ERRCAUTER, HR)))
    HRSAT = pyro.sample("HRSAT", dist.Categorical(get_cpt_2(CPTs, "HRSAT", ERRCAUTER, HR)))
    ERRLOWOUTPUT = pyro.sample("ERRLOWOUTPUT", dist.Categorical(get_cpt_0(CPTs, "ERRLOWOUTPUT")))
    HRBP = pyro.sample("HRBP", dist.Categorical(get_cpt_2(CPTs, "HRBP", ERRLOWOUTPUT, HR)))
    LVFAILURE = pyro.sample("LVFAILURE", dist.Categorical(get_cpt_0(CPTs, "LVFAILURE")))
    HISTORY = pyro.sample("HISTORY", dist.Categorical(get_cpt_1(CPTs, "HISTORY", LVFAILURE)))
    HYPOVOLEMIA = pyro.sample("HYPOVOLEMIA", dist.Categorical(get_cpt_0(CPTs, "HYPOVOLEMIA")))
    LVEDVOLUME = pyro.sample("LVEDVOLUME", dist.Categorical(get_cpt_2(CPTs, "LVEDVOLUME", HYPOVOLEMIA, LVFAILURE)))
    PCWP = pyro.sample("PCWP", dist.Categorical(get_cpt_1(CPTs, "PCWP", LVEDVOLUME)))
    CVP = pyro.sample("CVP", dist.Categorical(get_cpt_1(CPTs, "CVP", LVEDVOLUME)))
    STROKEVOLUME = pyro.sample("STROKEVOLUME", dist.Categorical(get_cpt_2(CPTs, "STROKEVOLUME", HYPOVOLEMIA, LVFAILURE)))
    CO = pyro.sample("CO", dist.Categorical(get_cpt_2(CPTs, "CO", HR, STROKEVOLUME)))
    BP = pyro.sample("BP", dist.Categorical(get_cpt_2(CPTs, "BP", CO, TPR)))

CPTs = {
    "MINVOLSET": torch.tensor([0.05, 0.9, 0.05]),
    "VENTMACH": torch.tensor([[0.05, 0.93, 0.01, 0.01], [0.05, 0.01, 0.93, 0.01], [0.05, 0.01, 0.01, 0.93]]),
    "DISCONNECT": torch.tensor([0.1, 0.9]),
    "VENTTUBE": torch.tensor([[[0.97, 0.01, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.97, 0.01]], [[0.97, 0.01, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.97, 0.01, 0.01], [0.01, 0.01, 0.01, 0.97]]]),
    "INTUBATION": torch.tensor([0.92, 0.03, 0.05]),
    "PULMEMBOLUS": torch.tensor([0.01, 0.99]),
    "PAP": torch.tensor([[0.01, 0.19, 0.8], [0.05, 0.9, 0.05]]),
    "SHUNT": torch.tensor([[[0.1, 0.9], [0.95, 0.05]], [[0.1, 0.9], [0.95, 0.05]], [[0.01, 0.99], [0.05, 0.95]]]),
    "FIO2": torch.tensor([0.05, 0.95]),
    "KINKEDTUBE": torch.tensor([0.04, 0.96]),
    "PRESS": torch.tensor([[[[0.97, 0.01, 0.01, 0.01], [0.05, 0.25, 0.25, 0.45], [0.97, 0.01, 0.01, 0.01], [0.2, 0.75, 0.04, 0.01]], [[0.01, 0.01, 0.01, 0.97], [0.01, 0.29, 0.3, 0.4], [0.01, 0.01, 0.01, 0.97], [0.01, 0.9, 0.08, 0.01]]], [[[0.01, 0.3, 0.49, 0.2], [0.01, 0.15, 0.25, 0.59], [0.01, 0.97, 0.01, 0.01], [0.2, 0.7, 0.09, 0.01]], [[0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.08, 0.9], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.38, 0.6]]], [[[0.01, 0.01, 0.08, 0.9], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.97, 0.01], [0.97, 0.01, 0.01, 0.01]], [[0.1, 0.84, 0.05, 0.01], [0.01, 0.01, 0.01, 0.97], [0.4, 0.58, 0.01, 0.01], [0.01, 0.01, 0.01, 0.97]]]]),
    "VENTLUNG": torch.tensor([[[[0.97, 0.01, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01]], [[0.3, 0.68, 0.01, 0.01], [0.95, 0.03, 0.01, 0.01], [0.01, 0.01, 0.01, 0.97], [0.01, 0.97, 0.01, 0.01]]], [[[0.95, 0.03, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.97, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01]], [[0.97, 0.01, 0.01, 0.01], [0.5, 0.48, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.97, 0.01]]], [[[0.4, 0.58, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.97, 0.01], [0.97, 0.01, 0.01, 0.01]], [[0.97, 0.01, 0.01, 0.01], [0.3, 0.68, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.01, 0.97]]]]),
    "MINVOL": torch.tensor([[[0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.01, 0.97], [0.5, 0.48, 0.01, 0.01], [0.01, 0.97, 0.01, 0.01]], [[0.01, 0.97, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.5, 0.48, 0.01, 0.01], [0.01, 0.01, 0.97, 0.01]], [[0.01, 0.01, 0.97, 0.01], [0.6, 0.38, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.01, 0.97]]]),
    "VENTALV": torch.tensor([[[0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.01, 0.97], [0.01, 0.01, 0.97, 0.01], [0.03, 0.95, 0.01, 0.01]], [[0.01, 0.97, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.01, 0.97], [0.01, 0.94, 0.04, 0.01]], [[0.01, 0.01, 0.97, 0.01], [0.01, 0.97, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.88, 0.1, 0.01]]]),
    "ARTCO2": torch.tensor([[0.01, 0.01, 0.98], [0.01, 0.01, 0.98], [0.04, 0.92, 0.04], [0.9, 0.09, 0.01]]),
    "EXPCO2": torch.tensor([[[0.97, 0.01, 0.01, 0.01], [0.01, 0.97, 0.01, 0.01], [0.01, 0.01, 0.97, 0.01], [0.01, 0.01, 0.01, 0.97]], [[0.01, 0.97, 0.01, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.97, 0.01], [0.01, 0.01, 0.01, 0.97]], [[0.01, 0.97, 0.01, 0.01], [0.01, 0.01, 0.97, 0.01], [0.97, 0.01, 0.01, 0.01], [0.01, 0.01, 0.01, 0.97]]]),
    "PVSAT": torch.tensor([[[0.99, 0.005, 0.005], [0.95, 0.04, 0.01], [0.98, 0.015, 0.005], [0.01, 0.95, 0.04]], [[0.99, 0.005, 0.005], [0.95, 0.04, 0.01], [0.95, 0.04, 0.01], [0.01, 0.01, 0.98]]]),
    "SAO2": torch.tensor([[[0.98, 0.01, 0.01], [0.98, 0.01, 0.01]], [[0.01, 0.98, 0.01], [0.98, 0.01, 0.01]], [[0.01, 0.01, 0.98], [0.69, 0.3, 0.01]]]),
    "ANAPHYLAXIS": torch.tensor([0.01, 0.99]),
    "TPR": torch.tensor([[0.98, 0.01, 0.01], [0.3, 0.4, 0.3]]),
    "INSUFFANESTH": torch.tensor([0.1, 0.9]),
    "CATECHOL": torch.tensor([[[[[0.01, 0.99], [0.01, 0.99], [0.7, 0.3]], [[0.01, 0.99], [0.05, 0.95], [0.7, 0.3]], [[0.01, 0.99], [0.05, 0.95], [0.95, 0.05]]], [[[0.01, 0.99], [0.05, 0.95], [0.7, 0.3]], [[0.01, 0.99], [0.05, 0.95], [0.95, 0.05]], [[0.05, 0.95], [0.05, 0.95], [0.95, 0.05]]]], [[[[0.01, 0.99], [0.01, 0.99], [0.7, 0.3]], [[0.01, 0.99], [0.05, 0.95], [0.7, 0.3]], [[0.01, 0.99], [0.05, 0.95], [0.99, 0.01]]], [[[0.01, 0.99], [0.05, 0.95], [0.7, 0.3]], [[0.01, 0.99], [0.05, 0.95], [0.99, 0.01]], [[0.05, 0.95], [0.05, 0.95], [0.99, 0.01]]]], [[[[0.01, 0.99], [0.01, 0.99], [0.1, 0.9]], [[0.01, 0.99], [0.01, 0.99], [0.1, 0.9]], [[0.01, 0.99], [0.01, 0.99], [0.3, 0.7]]], [[[0.01, 0.99], [0.01, 0.99], [0.1, 0.9]], [[0.01, 0.99], [0.01, 0.99], [0.3, 0.7]], [[0.01, 0.99], [0.01, 0.99], [0.3, 0.7]]]]]),
    "HR": torch.tensor([[0.05, 0.9, 0.05], [0.01, 0.09, 0.9]]),
    "ERRCAUTER": torch.tensor([0.1, 0.9]),
    "HREKG": torch.tensor([[[0.3333333, 0.3333333, 0.3333333], [0.3333333, 0.3333333, 0.3333333], [0.01, 0.98, 0.01]], [[0.3333333, 0.3333333, 0.3333333], [0.98, 0.01, 0.01], [0.01, 0.01, 0.98]]]),
    "HRSAT": torch.tensor([[[0.3333333, 0.3333333, 0.3333333], [0.3333333, 0.3333333, 0.3333333], [0.01, 0.98, 0.01]], [[0.3333333, 0.3333333, 0.3333333], [0.98, 0.01, 0.01], [0.01, 0.01, 0.98]]]),
    "ERRLOWOUTPUT": torch.tensor([0.05, 0.95]),
    "HRBP": torch.tensor([[[0.98, 0.01, 0.01], [0.3, 0.4, 0.3], [0.01, 0.98, 0.01]], [[0.4, 0.59, 0.01], [0.98, 0.01, 0.01], [0.01, 0.01, 0.98]]]),
    "LVFAILURE": torch.tensor([0.05, 0.95]),
    "HISTORY": torch.tensor([[0.9, 0.1], [0.01, 0.99]]),
    "HYPOVOLEMIA": torch.tensor([0.2, 0.8]),
    "LVEDVOLUME": torch.tensor([[[0.95, 0.04, 0.01], [0.01, 0.09, 0.9]], [[0.98, 0.01, 0.01], [0.05, 0.9, 0.05]]]),
    "PCWP": torch.tensor([[0.95, 0.04, 0.01], [0.04, 0.95, 0.01], [0.01, 0.04, 0.95]]),
    "CVP": torch.tensor([[0.95, 0.04, 0.01], [0.04, 0.95, 0.01], [0.01, 0.29, 0.7]]),
    "STROKEVOLUME": torch.tensor([[[0.98, 0.01, 0.01], [0.5, 0.49, 0.01]], [[0.95, 0.04, 0.01], [0.05, 0.9, 0.05]]]),
    "CO": torch.tensor([[[0.98, 0.01, 0.01], [0.95, 0.04, 0.01], [0.3, 0.69, 0.01]], [[0.95, 0.04, 0.01], [0.04, 0.95, 0.01], [0.01, 0.3, 0.69]], [[0.8, 0.19, 0.01], [0.01, 0.04, 0.95], [0.01, 0.01, 0.98]]]),
    "BP": torch.tensor([[[0.98, 0.01, 0.01], [0.98, 0.01, 0.01], [0.3, 0.6, 0.1]], [[0.98, 0.01, 0.01], [0.1, 0.85, 0.05], [0.05, 0.4, 0.55]], [[0.9, 0.09, 0.01], [0.05, 0.2, 0.75], [0.01, 0.09, 0.9]]]),
}



import pyro.poutine as poutine
from pprint import pprint
pprint({name: site["value"] for name, site in poutine.trace(model).get_trace().nodes.items() if site["type"] == "sample"}) # type: ignore
