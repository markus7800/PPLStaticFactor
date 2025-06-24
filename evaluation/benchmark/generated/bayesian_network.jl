# this file is auto-generated

include("../bayesian_network.jl")

mutable struct State <: AbstractState
    node_id:: Int
    ANAPHYLAXIS::Int
    ARTCO2::Int
    BP::Int
    CATECHOL::Int
    CO::Int
    CVP::Int
    DISCONNECT::Int
    ERRCAUTER::Int
    ERRLOWOUTPUT::Int
    EXPCO2::Int
    FIO2::Int
    HISTORY::Int
    HR::Int
    HRBP::Int
    HREKG::Int
    HRSAT::Int
    HYPOVOLEMIA::Int
    INSUFFANESTH::Int
    INTUBATION::Int
    KINKEDTUBE::Int
    LVEDVOLUME::Int
    LVFAILURE::Int
    MINVOL::Int
    MINVOLSET::Int
    PAP::Int
    PCWP::Int
    PRESS::Int
    PULMEMBOLUS::Int
    PVSAT::Int
    SAO2::Int
    SHUNT::Int
    STROKEVOLUME::Int
    TPR::Int
    VENTALV::Int
    VENTLUNG::Int
    VENTMACH::Int
    VENTTUBE::Int
    function State()
        return new(
            0,
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.ANAPHYLAXIS = _s_.ANAPHYLAXIS
    dst.ARTCO2 = _s_.ARTCO2
    dst.BP = _s_.BP
    dst.CATECHOL = _s_.CATECHOL
    dst.CO = _s_.CO
    dst.CVP = _s_.CVP
    dst.DISCONNECT = _s_.DISCONNECT
    dst.ERRCAUTER = _s_.ERRCAUTER
    dst.ERRLOWOUTPUT = _s_.ERRLOWOUTPUT
    dst.EXPCO2 = _s_.EXPCO2
    dst.FIO2 = _s_.FIO2
    dst.HISTORY = _s_.HISTORY
    dst.HR = _s_.HR
    dst.HRBP = _s_.HRBP
    dst.HREKG = _s_.HREKG
    dst.HRSAT = _s_.HRSAT
    dst.HYPOVOLEMIA = _s_.HYPOVOLEMIA
    dst.INSUFFANESTH = _s_.INSUFFANESTH
    dst.INTUBATION = _s_.INTUBATION
    dst.KINKEDTUBE = _s_.KINKEDTUBE
    dst.LVEDVOLUME = _s_.LVEDVOLUME
    dst.LVFAILURE = _s_.LVFAILURE
    dst.MINVOL = _s_.MINVOL
    dst.MINVOLSET = _s_.MINVOLSET
    dst.PAP = _s_.PAP
    dst.PCWP = _s_.PCWP
    dst.PRESS = _s_.PRESS
    dst.PULMEMBOLUS = _s_.PULMEMBOLUS
    dst.PVSAT = _s_.PVSAT
    dst.SAO2 = _s_.SAO2
    dst.SHUNT = _s_.SHUNT
    dst.STROKEVOLUME = _s_.STROKEVOLUME
    dst.TPR = _s_.TPR
    dst.VENTALV = _s_.VENTALV
    dst.VENTLUNG = _s_.VENTLUNG
    dst.VENTMACH = _s_.VENTMACH
    dst.VENTTUBE = _s_.VENTTUBE
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function bayesian_network(ctx::AbstractSampleRecordStateContext, CPTs::CPTsDict, _s_::State)
    _s_.MINVOLSET::Int = sample_record_state(ctx, _s_, 151, "MINVOLSET", Categorical(get_cpt(CPTs, "MINVOLSET"), check_args = false))
    _s_.VENTMACH::Int = sample_record_state(ctx, _s_, 170, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", _s_.MINVOLSET), check_args = false))
    _s_.DISCONNECT::Int = sample_record_state(ctx, _s_, 190, "DISCONNECT", Categorical(get_cpt(CPTs, "DISCONNECT"), check_args = false))
    _s_.VENTTUBE::Int = sample_record_state(ctx, _s_, 209, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", _s_.DISCONNECT, _s_.VENTMACH), check_args = false))
    _s_.INTUBATION::Int = sample_record_state(ctx, _s_, 230, "INTUBATION", Categorical(get_cpt(CPTs, "INTUBATION"), check_args = false))
    _s_.PULMEMBOLUS::Int = sample_record_state(ctx, _s_, 249, "PULMEMBOLUS", Categorical(get_cpt(CPTs, "PULMEMBOLUS"), check_args = false))
    _s_.PAP::Int = sample_record_state(ctx, _s_, 268, "PAP", Categorical(get_cpt(CPTs, "PAP", _s_.PULMEMBOLUS), check_args = false))
    _s_.SHUNT::Int = sample_record_state(ctx, _s_, 288, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", _s_.INTUBATION, _s_.PULMEMBOLUS), check_args = false))
    _s_.FIO2::Int = sample_record_state(ctx, _s_, 309, "FIO2", Categorical(get_cpt(CPTs, "FIO2"), check_args = false))
    _s_.KINKEDTUBE::Int = sample_record_state(ctx, _s_, 328, "KINKEDTUBE", Categorical(get_cpt(CPTs, "KINKEDTUBE"), check_args = false))
    _s_.PRESS::Int = sample_record_state(ctx, _s_, 347, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.VENTLUNG::Int = sample_record_state(ctx, _s_, 369, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.MINVOL::Int = sample_record_state(ctx, _s_, 391, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.VENTALV::Int = sample_record_state(ctx, _s_, 412, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.ARTCO2::Int = sample_record_state(ctx, _s_, 433, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", _s_.VENTALV), check_args = false))
    _s_.EXPCO2::Int = sample_record_state(ctx, _s_, 453, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", _s_.ARTCO2, _s_.VENTLUNG), check_args = false))
    _s_.PVSAT::Int = sample_record_state(ctx, _s_, 474, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", _s_.FIO2, _s_.VENTALV), check_args = false))
    _s_.SAO2::Int = sample_record_state(ctx, _s_, 495, "SAO2", Categorical(get_cpt(CPTs, "SAO2", _s_.PVSAT, _s_.SHUNT), check_args = false))
    _s_.ANAPHYLAXIS::Int = sample_record_state(ctx, _s_, 516, "ANAPHYLAXIS", Categorical(get_cpt(CPTs, "ANAPHYLAXIS"), check_args = false))
    _s_.TPR::Int = sample_record_state(ctx, _s_, 535, "TPR", Categorical(get_cpt(CPTs, "TPR", _s_.ANAPHYLAXIS), check_args = false))
    _s_.INSUFFANESTH::Int = sample_record_state(ctx, _s_, 555, "INSUFFANESTH", Categorical(get_cpt(CPTs, "INSUFFANESTH"), check_args = false))
    _s_.CATECHOL::Int = sample_record_state(ctx, _s_, 574, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
    _s_.HR::Int = sample_record_state(ctx, _s_, 597, "HR", Categorical(get_cpt(CPTs, "HR", _s_.CATECHOL), check_args = false))
    _s_.ERRCAUTER::Int = sample_record_state(ctx, _s_, 617, "ERRCAUTER", Categorical(get_cpt(CPTs, "ERRCAUTER"), check_args = false))
    _s_.HREKG::Int = sample_record_state(ctx, _s_, 636, "HREKG", Categorical(get_cpt(CPTs, "HREKG", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.HRSAT::Int = sample_record_state(ctx, _s_, 657, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.ERRLOWOUTPUT::Int = sample_record_state(ctx, _s_, 678, "ERRLOWOUTPUT", Categorical(get_cpt(CPTs, "ERRLOWOUTPUT"), check_args = false))
    _s_.HRBP::Int = sample_record_state(ctx, _s_, 697, "HRBP", Categorical(get_cpt(CPTs, "HRBP", _s_.ERRLOWOUTPUT, _s_.HR), check_args = false))
    _s_.LVFAILURE::Int = sample_record_state(ctx, _s_, 718, "LVFAILURE", Categorical(get_cpt(CPTs, "LVFAILURE"), check_args = false))
    _s_.HISTORY::Int = sample_record_state(ctx, _s_, 737, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", _s_.LVFAILURE), check_args = false))
    _s_.HYPOVOLEMIA::Int = sample_record_state(ctx, _s_, 757, "HYPOVOLEMIA", Categorical(get_cpt(CPTs, "HYPOVOLEMIA"), check_args = false))
    _s_.LVEDVOLUME::Int = sample_record_state(ctx, _s_, 776, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.PCWP::Int = sample_record_state(ctx, _s_, 797, "PCWP", Categorical(get_cpt(CPTs, "PCWP", _s_.LVEDVOLUME), check_args = false))
    _s_.CVP::Int = sample_record_state(ctx, _s_, 817, "CVP", Categorical(get_cpt(CPTs, "CVP", _s_.LVEDVOLUME), check_args = false))
    _s_.STROKEVOLUME::Int = sample_record_state(ctx, _s_, 837, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.CO::Int = sample_record_state(ctx, _s_, 858, "CO", Categorical(get_cpt(CPTs, "CO", _s_.HR, _s_.STROKEVOLUME), check_args = false))
    _s_.BP::Int = sample_record_state(ctx, _s_, 879, "BP", Categorical(get_cpt(CPTs, "BP", _s_.CO, _s_.TPR), check_args = false))
end

function bayesian_network_ANAPHYLAXIS_516(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.ANAPHYLAXIS = revisit(ctx, _s_, 516, "ANAPHYLAXIS", Categorical(get_cpt(CPTs, "ANAPHYLAXIS"), check_args = false))
    _s_.TPR = score(ctx, _s_, 535, "TPR", Categorical(get_cpt(CPTs, "TPR", _s_.ANAPHYLAXIS), check_args = false))
end

function bayesian_network_ARTCO2_433(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.ARTCO2 = revisit(ctx, _s_, 433, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", _s_.VENTALV), check_args = false))
    _s_.EXPCO2 = score(ctx, _s_, 453, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", _s_.ARTCO2, _s_.VENTLUNG), check_args = false))
    _s_.PVSAT = read(ctx, _s_, 474, "PVSAT")
    _s_.SAO2 = read(ctx, _s_, 495, "SAO2")
    _s_.ANAPHYLAXIS = read(ctx, _s_, 516, "ANAPHYLAXIS")
    _s_.TPR = read(ctx, _s_, 535, "TPR")
    _s_.INSUFFANESTH = read(ctx, _s_, 555, "INSUFFANESTH")
    _s_.CATECHOL = score(ctx, _s_, 574, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
end

function bayesian_network_BP_879(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.BP = revisit(ctx, _s_, 879, "BP", Categorical(get_cpt(CPTs, "BP", _s_.CO, _s_.TPR), check_args = false))
end

function bayesian_network_CATECHOL_574(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.CATECHOL = revisit(ctx, _s_, 574, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
    _s_.HR = score(ctx, _s_, 597, "HR", Categorical(get_cpt(CPTs, "HR", _s_.CATECHOL), check_args = false))
end

function bayesian_network_CO_858(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.CO = revisit(ctx, _s_, 858, "CO", Categorical(get_cpt(CPTs, "CO", _s_.HR, _s_.STROKEVOLUME), check_args = false))
    _s_.BP = score(ctx, _s_, 879, "BP", Categorical(get_cpt(CPTs, "BP", _s_.CO, _s_.TPR), check_args = false))
end

function bayesian_network_CVP_817(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.CVP = revisit(ctx, _s_, 817, "CVP", Categorical(get_cpt(CPTs, "CVP", _s_.LVEDVOLUME), check_args = false))
end

function bayesian_network_DISCONNECT_190(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.DISCONNECT = revisit(ctx, _s_, 190, "DISCONNECT", Categorical(get_cpt(CPTs, "DISCONNECT"), check_args = false))
    _s_.VENTTUBE = score(ctx, _s_, 209, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", _s_.DISCONNECT, _s_.VENTMACH), check_args = false))
end

function bayesian_network_ERRCAUTER_617(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.ERRCAUTER = revisit(ctx, _s_, 617, "ERRCAUTER", Categorical(get_cpt(CPTs, "ERRCAUTER"), check_args = false))
    _s_.HREKG = score(ctx, _s_, 636, "HREKG", Categorical(get_cpt(CPTs, "HREKG", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.HRSAT = score(ctx, _s_, 657, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", _s_.ERRCAUTER, _s_.HR), check_args = false))
end

function bayesian_network_ERRLOWOUTPUT_678(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.ERRLOWOUTPUT = revisit(ctx, _s_, 678, "ERRLOWOUTPUT", Categorical(get_cpt(CPTs, "ERRLOWOUTPUT"), check_args = false))
    _s_.HRBP = score(ctx, _s_, 697, "HRBP", Categorical(get_cpt(CPTs, "HRBP", _s_.ERRLOWOUTPUT, _s_.HR), check_args = false))
end

function bayesian_network_EXPCO2_453(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.EXPCO2 = revisit(ctx, _s_, 453, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", _s_.ARTCO2, _s_.VENTLUNG), check_args = false))
end

function bayesian_network_FIO2_309(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.FIO2 = revisit(ctx, _s_, 309, "FIO2", Categorical(get_cpt(CPTs, "FIO2"), check_args = false))
    _s_.KINKEDTUBE = read(ctx, _s_, 328, "KINKEDTUBE")
    _s_.PRESS = read(ctx, _s_, 347, "PRESS")
    _s_.VENTLUNG = read(ctx, _s_, 369, "VENTLUNG")
    _s_.MINVOL = read(ctx, _s_, 391, "MINVOL")
    _s_.VENTALV = read(ctx, _s_, 412, "VENTALV")
    _s_.ARTCO2 = read(ctx, _s_, 433, "ARTCO2")
    _s_.EXPCO2 = read(ctx, _s_, 453, "EXPCO2")
    _s_.PVSAT = score(ctx, _s_, 474, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", _s_.FIO2, _s_.VENTALV), check_args = false))
end

function bayesian_network_HISTORY_737(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.HISTORY = revisit(ctx, _s_, 737, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", _s_.LVFAILURE), check_args = false))
end

function bayesian_network_HRBP_697(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.HRBP = revisit(ctx, _s_, 697, "HRBP", Categorical(get_cpt(CPTs, "HRBP", _s_.ERRLOWOUTPUT, _s_.HR), check_args = false))
end

function bayesian_network_HREKG_636(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.HREKG = revisit(ctx, _s_, 636, "HREKG", Categorical(get_cpt(CPTs, "HREKG", _s_.ERRCAUTER, _s_.HR), check_args = false))
end

function bayesian_network_HRSAT_657(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.HRSAT = revisit(ctx, _s_, 657, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", _s_.ERRCAUTER, _s_.HR), check_args = false))
end

function bayesian_network_HR_597(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.HR = revisit(ctx, _s_, 597, "HR", Categorical(get_cpt(CPTs, "HR", _s_.CATECHOL), check_args = false))
    _s_.ERRCAUTER = read(ctx, _s_, 617, "ERRCAUTER")
    _s_.HREKG = score(ctx, _s_, 636, "HREKG", Categorical(get_cpt(CPTs, "HREKG", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.HRSAT = score(ctx, _s_, 657, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.ERRLOWOUTPUT = read(ctx, _s_, 678, "ERRLOWOUTPUT")
    _s_.HRBP = score(ctx, _s_, 697, "HRBP", Categorical(get_cpt(CPTs, "HRBP", _s_.ERRLOWOUTPUT, _s_.HR), check_args = false))
    _s_.LVFAILURE = read(ctx, _s_, 718, "LVFAILURE")
    _s_.HISTORY = read(ctx, _s_, 737, "HISTORY")
    _s_.HYPOVOLEMIA = read(ctx, _s_, 757, "HYPOVOLEMIA")
    _s_.LVEDVOLUME = read(ctx, _s_, 776, "LVEDVOLUME")
    _s_.PCWP = read(ctx, _s_, 797, "PCWP")
    _s_.CVP = read(ctx, _s_, 817, "CVP")
    _s_.STROKEVOLUME = read(ctx, _s_, 837, "STROKEVOLUME")
    _s_.CO = score(ctx, _s_, 858, "CO", Categorical(get_cpt(CPTs, "CO", _s_.HR, _s_.STROKEVOLUME), check_args = false))
end

function bayesian_network_HYPOVOLEMIA_757(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.HYPOVOLEMIA = revisit(ctx, _s_, 757, "HYPOVOLEMIA", Categorical(get_cpt(CPTs, "HYPOVOLEMIA"), check_args = false))
    _s_.LVEDVOLUME = score(ctx, _s_, 776, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.PCWP = read(ctx, _s_, 797, "PCWP")
    _s_.CVP = read(ctx, _s_, 817, "CVP")
    _s_.STROKEVOLUME = score(ctx, _s_, 837, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
end

function bayesian_network_INSUFFANESTH_555(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.INSUFFANESTH = revisit(ctx, _s_, 555, "INSUFFANESTH", Categorical(get_cpt(CPTs, "INSUFFANESTH"), check_args = false))
    _s_.CATECHOL = score(ctx, _s_, 574, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
end

function bayesian_network_INTUBATION_230(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.INTUBATION = revisit(ctx, _s_, 230, "INTUBATION", Categorical(get_cpt(CPTs, "INTUBATION"), check_args = false))
    _s_.PULMEMBOLUS = read(ctx, _s_, 249, "PULMEMBOLUS")
    _s_.PAP = read(ctx, _s_, 268, "PAP")
    _s_.SHUNT = score(ctx, _s_, 288, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", _s_.INTUBATION, _s_.PULMEMBOLUS), check_args = false))
    _s_.FIO2 = read(ctx, _s_, 309, "FIO2")
    _s_.KINKEDTUBE = read(ctx, _s_, 328, "KINKEDTUBE")
    _s_.PRESS = score(ctx, _s_, 347, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.VENTLUNG = score(ctx, _s_, 369, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.MINVOL = score(ctx, _s_, 391, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.VENTALV = score(ctx, _s_, 412, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
end

function bayesian_network_KINKEDTUBE_328(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.KINKEDTUBE = revisit(ctx, _s_, 328, "KINKEDTUBE", Categorical(get_cpt(CPTs, "KINKEDTUBE"), check_args = false))
    _s_.PRESS = score(ctx, _s_, 347, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.VENTLUNG = score(ctx, _s_, 369, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
end

function bayesian_network_LVEDVOLUME_776(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.LVEDVOLUME = revisit(ctx, _s_, 776, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.PCWP = score(ctx, _s_, 797, "PCWP", Categorical(get_cpt(CPTs, "PCWP", _s_.LVEDVOLUME), check_args = false))
    _s_.CVP = score(ctx, _s_, 817, "CVP", Categorical(get_cpt(CPTs, "CVP", _s_.LVEDVOLUME), check_args = false))
end

function bayesian_network_LVFAILURE_718(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.LVFAILURE = revisit(ctx, _s_, 718, "LVFAILURE", Categorical(get_cpt(CPTs, "LVFAILURE"), check_args = false))
    _s_.HISTORY = score(ctx, _s_, 737, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", _s_.LVFAILURE), check_args = false))
    _s_.HYPOVOLEMIA = read(ctx, _s_, 757, "HYPOVOLEMIA")
    _s_.LVEDVOLUME = score(ctx, _s_, 776, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.PCWP = read(ctx, _s_, 797, "PCWP")
    _s_.CVP = read(ctx, _s_, 817, "CVP")
    _s_.STROKEVOLUME = score(ctx, _s_, 837, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
end

function bayesian_network_MINVOLSET_151(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.MINVOLSET = revisit(ctx, _s_, 151, "MINVOLSET", Categorical(get_cpt(CPTs, "MINVOLSET"), check_args = false))
    _s_.VENTMACH = score(ctx, _s_, 170, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", _s_.MINVOLSET), check_args = false))
end

function bayesian_network_MINVOL_391(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.MINVOL = revisit(ctx, _s_, 391, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
end

function bayesian_network_PAP_268(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.PAP = revisit(ctx, _s_, 268, "PAP", Categorical(get_cpt(CPTs, "PAP", _s_.PULMEMBOLUS), check_args = false))
end

function bayesian_network_PCWP_797(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.PCWP = revisit(ctx, _s_, 797, "PCWP", Categorical(get_cpt(CPTs, "PCWP", _s_.LVEDVOLUME), check_args = false))
end

function bayesian_network_PRESS_347(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.PRESS = revisit(ctx, _s_, 347, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
end

function bayesian_network_PULMEMBOLUS_249(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.PULMEMBOLUS = revisit(ctx, _s_, 249, "PULMEMBOLUS", Categorical(get_cpt(CPTs, "PULMEMBOLUS"), check_args = false))
    _s_.PAP = score(ctx, _s_, 268, "PAP", Categorical(get_cpt(CPTs, "PAP", _s_.PULMEMBOLUS), check_args = false))
    _s_.SHUNT = score(ctx, _s_, 288, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", _s_.INTUBATION, _s_.PULMEMBOLUS), check_args = false))
end

function bayesian_network_PVSAT_474(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.PVSAT = revisit(ctx, _s_, 474, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", _s_.FIO2, _s_.VENTALV), check_args = false))
    _s_.SAO2 = score(ctx, _s_, 495, "SAO2", Categorical(get_cpt(CPTs, "SAO2", _s_.PVSAT, _s_.SHUNT), check_args = false))
end

function bayesian_network_SAO2_495(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.SAO2 = revisit(ctx, _s_, 495, "SAO2", Categorical(get_cpt(CPTs, "SAO2", _s_.PVSAT, _s_.SHUNT), check_args = false))
    _s_.ANAPHYLAXIS = read(ctx, _s_, 516, "ANAPHYLAXIS")
    _s_.TPR = read(ctx, _s_, 535, "TPR")
    _s_.INSUFFANESTH = read(ctx, _s_, 555, "INSUFFANESTH")
    _s_.CATECHOL = score(ctx, _s_, 574, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
end

function bayesian_network_SHUNT_288(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.SHUNT = revisit(ctx, _s_, 288, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", _s_.INTUBATION, _s_.PULMEMBOLUS), check_args = false))
    _s_.FIO2 = read(ctx, _s_, 309, "FIO2")
    _s_.KINKEDTUBE = read(ctx, _s_, 328, "KINKEDTUBE")
    _s_.PRESS = read(ctx, _s_, 347, "PRESS")
    _s_.VENTLUNG = read(ctx, _s_, 369, "VENTLUNG")
    _s_.MINVOL = read(ctx, _s_, 391, "MINVOL")
    _s_.VENTALV = read(ctx, _s_, 412, "VENTALV")
    _s_.ARTCO2 = read(ctx, _s_, 433, "ARTCO2")
    _s_.EXPCO2 = read(ctx, _s_, 453, "EXPCO2")
    _s_.PVSAT = read(ctx, _s_, 474, "PVSAT")
    _s_.SAO2 = score(ctx, _s_, 495, "SAO2", Categorical(get_cpt(CPTs, "SAO2", _s_.PVSAT, _s_.SHUNT), check_args = false))
end

function bayesian_network_STROKEVOLUME_837(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.STROKEVOLUME = revisit(ctx, _s_, 837, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.CO = score(ctx, _s_, 858, "CO", Categorical(get_cpt(CPTs, "CO", _s_.HR, _s_.STROKEVOLUME), check_args = false))
end

function bayesian_network_TPR_535(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.TPR = revisit(ctx, _s_, 535, "TPR", Categorical(get_cpt(CPTs, "TPR", _s_.ANAPHYLAXIS), check_args = false))
    _s_.INSUFFANESTH = read(ctx, _s_, 555, "INSUFFANESTH")
    _s_.CATECHOL = score(ctx, _s_, 574, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
    _s_.HR = read(ctx, _s_, 597, "HR")
    _s_.ERRCAUTER = read(ctx, _s_, 617, "ERRCAUTER")
    _s_.HREKG = read(ctx, _s_, 636, "HREKG")
    _s_.HRSAT = read(ctx, _s_, 657, "HRSAT")
    _s_.ERRLOWOUTPUT = read(ctx, _s_, 678, "ERRLOWOUTPUT")
    _s_.HRBP = read(ctx, _s_, 697, "HRBP")
    _s_.LVFAILURE = read(ctx, _s_, 718, "LVFAILURE")
    _s_.HISTORY = read(ctx, _s_, 737, "HISTORY")
    _s_.HYPOVOLEMIA = read(ctx, _s_, 757, "HYPOVOLEMIA")
    _s_.LVEDVOLUME = read(ctx, _s_, 776, "LVEDVOLUME")
    _s_.PCWP = read(ctx, _s_, 797, "PCWP")
    _s_.CVP = read(ctx, _s_, 817, "CVP")
    _s_.STROKEVOLUME = read(ctx, _s_, 837, "STROKEVOLUME")
    _s_.CO = read(ctx, _s_, 858, "CO")
    _s_.BP = score(ctx, _s_, 879, "BP", Categorical(get_cpt(CPTs, "BP", _s_.CO, _s_.TPR), check_args = false))
end

function bayesian_network_VENTALV_412(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.VENTALV = revisit(ctx, _s_, 412, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.ARTCO2 = score(ctx, _s_, 433, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", _s_.VENTALV), check_args = false))
    _s_.EXPCO2 = read(ctx, _s_, 453, "EXPCO2")
    _s_.PVSAT = score(ctx, _s_, 474, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", _s_.FIO2, _s_.VENTALV), check_args = false))
end

function bayesian_network_VENTLUNG_369(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.VENTLUNG = revisit(ctx, _s_, 369, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.MINVOL = score(ctx, _s_, 391, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.VENTALV = score(ctx, _s_, 412, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.ARTCO2 = read(ctx, _s_, 433, "ARTCO2")
    _s_.EXPCO2 = score(ctx, _s_, 453, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", _s_.ARTCO2, _s_.VENTLUNG), check_args = false))
end

function bayesian_network_VENTMACH_170(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.VENTMACH = revisit(ctx, _s_, 170, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", _s_.MINVOLSET), check_args = false))
    _s_.DISCONNECT = read(ctx, _s_, 190, "DISCONNECT")
    _s_.VENTTUBE = score(ctx, _s_, 209, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", _s_.DISCONNECT, _s_.VENTMACH), check_args = false))
end

function bayesian_network_VENTTUBE_209(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State)
    _s_.VENTTUBE = revisit(ctx, _s_, 209, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", _s_.DISCONNECT, _s_.VENTMACH), check_args = false))
    _s_.INTUBATION = read(ctx, _s_, 230, "INTUBATION")
    _s_.PULMEMBOLUS = read(ctx, _s_, 249, "PULMEMBOLUS")
    _s_.PAP = read(ctx, _s_, 268, "PAP")
    _s_.SHUNT = read(ctx, _s_, 288, "SHUNT")
    _s_.FIO2 = read(ctx, _s_, 309, "FIO2")
    _s_.KINKEDTUBE = read(ctx, _s_, 328, "KINKEDTUBE")
    _s_.PRESS = score(ctx, _s_, 347, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.VENTLUNG = score(ctx, _s_, 369, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
end

function bayesian_network_factor(ctx::AbstractFactorRevisitContext, CPTs::CPTsDict, _s_::State, _addr_::String)
    if _s_.node_id == 516
        return bayesian_network_ANAPHYLAXIS_516(ctx, CPTs, _s_)
    end
    if _s_.node_id == 433
        return bayesian_network_ARTCO2_433(ctx, CPTs, _s_)
    end
    if _s_.node_id == 879
        return bayesian_network_BP_879(ctx, CPTs, _s_)
    end
    if _s_.node_id == 574
        return bayesian_network_CATECHOL_574(ctx, CPTs, _s_)
    end
    if _s_.node_id == 858
        return bayesian_network_CO_858(ctx, CPTs, _s_)
    end
    if _s_.node_id == 817
        return bayesian_network_CVP_817(ctx, CPTs, _s_)
    end
    if _s_.node_id == 190
        return bayesian_network_DISCONNECT_190(ctx, CPTs, _s_)
    end
    if _s_.node_id == 617
        return bayesian_network_ERRCAUTER_617(ctx, CPTs, _s_)
    end
    if _s_.node_id == 678
        return bayesian_network_ERRLOWOUTPUT_678(ctx, CPTs, _s_)
    end
    if _s_.node_id == 453
        return bayesian_network_EXPCO2_453(ctx, CPTs, _s_)
    end
    if _s_.node_id == 309
        return bayesian_network_FIO2_309(ctx, CPTs, _s_)
    end
    if _s_.node_id == 737
        return bayesian_network_HISTORY_737(ctx, CPTs, _s_)
    end
    if _s_.node_id == 697
        return bayesian_network_HRBP_697(ctx, CPTs, _s_)
    end
    if _s_.node_id == 636
        return bayesian_network_HREKG_636(ctx, CPTs, _s_)
    end
    if _s_.node_id == 657
        return bayesian_network_HRSAT_657(ctx, CPTs, _s_)
    end
    if _s_.node_id == 597
        return bayesian_network_HR_597(ctx, CPTs, _s_)
    end
    if _s_.node_id == 757
        return bayesian_network_HYPOVOLEMIA_757(ctx, CPTs, _s_)
    end
    if _s_.node_id == 555
        return bayesian_network_INSUFFANESTH_555(ctx, CPTs, _s_)
    end
    if _s_.node_id == 230
        return bayesian_network_INTUBATION_230(ctx, CPTs, _s_)
    end
    if _s_.node_id == 328
        return bayesian_network_KINKEDTUBE_328(ctx, CPTs, _s_)
    end
    if _s_.node_id == 776
        return bayesian_network_LVEDVOLUME_776(ctx, CPTs, _s_)
    end
    if _s_.node_id == 718
        return bayesian_network_LVFAILURE_718(ctx, CPTs, _s_)
    end
    if _s_.node_id == 151
        return bayesian_network_MINVOLSET_151(ctx, CPTs, _s_)
    end
    if _s_.node_id == 391
        return bayesian_network_MINVOL_391(ctx, CPTs, _s_)
    end
    if _s_.node_id == 268
        return bayesian_network_PAP_268(ctx, CPTs, _s_)
    end
    if _s_.node_id == 797
        return bayesian_network_PCWP_797(ctx, CPTs, _s_)
    end
    if _s_.node_id == 347
        return bayesian_network_PRESS_347(ctx, CPTs, _s_)
    end
    if _s_.node_id == 249
        return bayesian_network_PULMEMBOLUS_249(ctx, CPTs, _s_)
    end
    if _s_.node_id == 474
        return bayesian_network_PVSAT_474(ctx, CPTs, _s_)
    end
    if _s_.node_id == 495
        return bayesian_network_SAO2_495(ctx, CPTs, _s_)
    end
    if _s_.node_id == 288
        return bayesian_network_SHUNT_288(ctx, CPTs, _s_)
    end
    if _s_.node_id == 837
        return bayesian_network_STROKEVOLUME_837(ctx, CPTs, _s_)
    end
    if _s_.node_id == 535
        return bayesian_network_TPR_535(ctx, CPTs, _s_)
    end
    if _s_.node_id == 412
        return bayesian_network_VENTALV_412(ctx, CPTs, _s_)
    end
    if _s_.node_id == 369
        return bayesian_network_VENTLUNG_369(ctx, CPTs, _s_)
    end
    if _s_.node_id == 170
        return bayesian_network_VENTMACH_170(ctx, CPTs, _s_)
    end
    if _s_.node_id == 209
        return bayesian_network_VENTTUBE_209(ctx, CPTs, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return bayesian_network(ctx, CPTs)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return bayesian_network(ctx, CPTs, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return bayesian_network_factor(ctx, CPTs, _s_, _addr_)
end
