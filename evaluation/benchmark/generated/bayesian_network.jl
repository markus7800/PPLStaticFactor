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
    _s_.MINVOLSET::Int = sample_record_state(ctx, _s_, 155, "MINVOLSET", Categorical(get_cpt(CPTs, "MINVOLSET"), check_args = false))
    _s_.VENTMACH::Int = sample_record_state(ctx, _s_, 174, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", _s_.MINVOLSET), check_args = false))
    _s_.DISCONNECT::Int = sample_record_state(ctx, _s_, 194, "DISCONNECT", Categorical(get_cpt(CPTs, "DISCONNECT"), check_args = false))
    _s_.VENTTUBE::Int = sample_record_state(ctx, _s_, 213, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", _s_.DISCONNECT, _s_.VENTMACH), check_args = false))
    _s_.INTUBATION::Int = sample_record_state(ctx, _s_, 234, "INTUBATION", Categorical(get_cpt(CPTs, "INTUBATION"), check_args = false))
    _s_.PULMEMBOLUS::Int = sample_record_state(ctx, _s_, 253, "PULMEMBOLUS", Categorical(get_cpt(CPTs, "PULMEMBOLUS"), check_args = false))
    _s_.PAP::Int = sample_record_state(ctx, _s_, 272, "PAP", Categorical(get_cpt(CPTs, "PAP", _s_.PULMEMBOLUS), check_args = false))
    _s_.SHUNT::Int = sample_record_state(ctx, _s_, 292, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", _s_.INTUBATION, _s_.PULMEMBOLUS), check_args = false))
    _s_.FIO2::Int = sample_record_state(ctx, _s_, 313, "FIO2", Categorical(get_cpt(CPTs, "FIO2"), check_args = false))
    _s_.KINKEDTUBE::Int = sample_record_state(ctx, _s_, 332, "KINKEDTUBE", Categorical(get_cpt(CPTs, "KINKEDTUBE"), check_args = false))
    _s_.PRESS::Int = sample_record_state(ctx, _s_, 351, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.VENTLUNG::Int = sample_record_state(ctx, _s_, 373, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.MINVOL::Int = sample_record_state(ctx, _s_, 395, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.VENTALV::Int = sample_record_state(ctx, _s_, 416, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.ARTCO2::Int = sample_record_state(ctx, _s_, 437, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", _s_.VENTALV), check_args = false))
    _s_.EXPCO2::Int = sample_record_state(ctx, _s_, 457, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", _s_.ARTCO2, _s_.VENTLUNG), check_args = false))
    _s_.PVSAT::Int = sample_record_state(ctx, _s_, 478, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", _s_.FIO2, _s_.VENTALV), check_args = false))
    _s_.SAO2::Int = sample_record_state(ctx, _s_, 499, "SAO2", Categorical(get_cpt(CPTs, "SAO2", _s_.PVSAT, _s_.SHUNT), check_args = false))
    _s_.ANAPHYLAXIS::Int = sample_record_state(ctx, _s_, 520, "ANAPHYLAXIS", Categorical(get_cpt(CPTs, "ANAPHYLAXIS"), check_args = false))
    _s_.TPR::Int = sample_record_state(ctx, _s_, 539, "TPR", Categorical(get_cpt(CPTs, "TPR", _s_.ANAPHYLAXIS), check_args = false))
    _s_.INSUFFANESTH::Int = sample_record_state(ctx, _s_, 559, "INSUFFANESTH", Categorical(get_cpt(CPTs, "INSUFFANESTH"), check_args = false))
    _s_.CATECHOL::Int = sample_record_state(ctx, _s_, 578, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
    _s_.HR::Int = sample_record_state(ctx, _s_, 601, "HR", Categorical(get_cpt(CPTs, "HR", _s_.CATECHOL), check_args = false))
    _s_.ERRCAUTER::Int = sample_record_state(ctx, _s_, 621, "ERRCAUTER", Categorical(get_cpt(CPTs, "ERRCAUTER"), check_args = false))
    _s_.HREKG::Int = sample_record_state(ctx, _s_, 640, "HREKG", Categorical(get_cpt(CPTs, "HREKG", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.HRSAT::Int = sample_record_state(ctx, _s_, 661, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.ERRLOWOUTPUT::Int = sample_record_state(ctx, _s_, 682, "ERRLOWOUTPUT", Categorical(get_cpt(CPTs, "ERRLOWOUTPUT"), check_args = false))
    _s_.HRBP::Int = sample_record_state(ctx, _s_, 701, "HRBP", Categorical(get_cpt(CPTs, "HRBP", _s_.ERRLOWOUTPUT, _s_.HR), check_args = false))
    _s_.LVFAILURE::Int = sample_record_state(ctx, _s_, 722, "LVFAILURE", Categorical(get_cpt(CPTs, "LVFAILURE"), check_args = false))
    _s_.HISTORY::Int = sample_record_state(ctx, _s_, 741, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", _s_.LVFAILURE), check_args = false))
    _s_.HYPOVOLEMIA::Int = sample_record_state(ctx, _s_, 761, "HYPOVOLEMIA", Categorical(get_cpt(CPTs, "HYPOVOLEMIA"), check_args = false))
    _s_.LVEDVOLUME::Int = sample_record_state(ctx, _s_, 780, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.PCWP::Int = sample_record_state(ctx, _s_, 801, "PCWP", Categorical(get_cpt(CPTs, "PCWP", _s_.LVEDVOLUME), check_args = false))
    _s_.CVP::Int = sample_record_state(ctx, _s_, 821, "CVP", Categorical(get_cpt(CPTs, "CVP", _s_.LVEDVOLUME), check_args = false))
    _s_.STROKEVOLUME::Int = sample_record_state(ctx, _s_, 841, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.CO::Int = sample_record_state(ctx, _s_, 862, "CO", Categorical(get_cpt(CPTs, "CO", _s_.HR, _s_.STROKEVOLUME), check_args = false))
    _s_.BP::Int = sample_record_state(ctx, _s_, 883, "BP", Categorical(get_cpt(CPTs, "BP", _s_.CO, _s_.TPR), check_args = false))
end

function bayesian_network_ANAPHYLAXIS_520(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.ANAPHYLAXIS = resample(ctx, _s_, 520, "ANAPHYLAXIS", Categorical(get_cpt(CPTs, "ANAPHYLAXIS"), check_args = false))
    _s_.TPR = score(ctx, _s_, 539, "TPR", Categorical(get_cpt(CPTs, "TPR", _s_.ANAPHYLAXIS), check_args = false))
end

function bayesian_network_ARTCO2_437(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.ARTCO2 = resample(ctx, _s_, 437, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", _s_.VENTALV), check_args = false))
    _s_.EXPCO2 = score(ctx, _s_, 457, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", _s_.ARTCO2, _s_.VENTLUNG), check_args = false))
    _s_.PVSAT = read(ctx, _s_, 478, "PVSAT")
    _s_.SAO2 = read(ctx, _s_, 499, "SAO2")
    _s_.ANAPHYLAXIS = read(ctx, _s_, 520, "ANAPHYLAXIS")
    _s_.TPR = read(ctx, _s_, 539, "TPR")
    _s_.INSUFFANESTH = read(ctx, _s_, 559, "INSUFFANESTH")
    _s_.CATECHOL = score(ctx, _s_, 578, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
end

function bayesian_network_BP_883(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.BP = resample(ctx, _s_, 883, "BP", Categorical(get_cpt(CPTs, "BP", _s_.CO, _s_.TPR), check_args = false))
end

function bayesian_network_CATECHOL_578(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.CATECHOL = resample(ctx, _s_, 578, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
    _s_.HR = score(ctx, _s_, 601, "HR", Categorical(get_cpt(CPTs, "HR", _s_.CATECHOL), check_args = false))
end

function bayesian_network_CO_862(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.CO = resample(ctx, _s_, 862, "CO", Categorical(get_cpt(CPTs, "CO", _s_.HR, _s_.STROKEVOLUME), check_args = false))
    _s_.BP = score(ctx, _s_, 883, "BP", Categorical(get_cpt(CPTs, "BP", _s_.CO, _s_.TPR), check_args = false))
end

function bayesian_network_CVP_821(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.CVP = resample(ctx, _s_, 821, "CVP", Categorical(get_cpt(CPTs, "CVP", _s_.LVEDVOLUME), check_args = false))
end

function bayesian_network_DISCONNECT_194(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.DISCONNECT = resample(ctx, _s_, 194, "DISCONNECT", Categorical(get_cpt(CPTs, "DISCONNECT"), check_args = false))
    _s_.VENTTUBE = score(ctx, _s_, 213, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", _s_.DISCONNECT, _s_.VENTMACH), check_args = false))
end

function bayesian_network_ERRCAUTER_621(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.ERRCAUTER = resample(ctx, _s_, 621, "ERRCAUTER", Categorical(get_cpt(CPTs, "ERRCAUTER"), check_args = false))
    _s_.HREKG = score(ctx, _s_, 640, "HREKG", Categorical(get_cpt(CPTs, "HREKG", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.HRSAT = score(ctx, _s_, 661, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", _s_.ERRCAUTER, _s_.HR), check_args = false))
end

function bayesian_network_ERRLOWOUTPUT_682(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.ERRLOWOUTPUT = resample(ctx, _s_, 682, "ERRLOWOUTPUT", Categorical(get_cpt(CPTs, "ERRLOWOUTPUT"), check_args = false))
    _s_.HRBP = score(ctx, _s_, 701, "HRBP", Categorical(get_cpt(CPTs, "HRBP", _s_.ERRLOWOUTPUT, _s_.HR), check_args = false))
end

function bayesian_network_EXPCO2_457(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.EXPCO2 = resample(ctx, _s_, 457, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", _s_.ARTCO2, _s_.VENTLUNG), check_args = false))
end

function bayesian_network_FIO2_313(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.FIO2 = resample(ctx, _s_, 313, "FIO2", Categorical(get_cpt(CPTs, "FIO2"), check_args = false))
    _s_.KINKEDTUBE = read(ctx, _s_, 332, "KINKEDTUBE")
    _s_.PRESS = read(ctx, _s_, 351, "PRESS")
    _s_.VENTLUNG = read(ctx, _s_, 373, "VENTLUNG")
    _s_.MINVOL = read(ctx, _s_, 395, "MINVOL")
    _s_.VENTALV = read(ctx, _s_, 416, "VENTALV")
    _s_.ARTCO2 = read(ctx, _s_, 437, "ARTCO2")
    _s_.EXPCO2 = read(ctx, _s_, 457, "EXPCO2")
    _s_.PVSAT = score(ctx, _s_, 478, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", _s_.FIO2, _s_.VENTALV), check_args = false))
end

function bayesian_network_HISTORY_741(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.HISTORY = resample(ctx, _s_, 741, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", _s_.LVFAILURE), check_args = false))
end

function bayesian_network_HRBP_701(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.HRBP = resample(ctx, _s_, 701, "HRBP", Categorical(get_cpt(CPTs, "HRBP", _s_.ERRLOWOUTPUT, _s_.HR), check_args = false))
end

function bayesian_network_HREKG_640(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.HREKG = resample(ctx, _s_, 640, "HREKG", Categorical(get_cpt(CPTs, "HREKG", _s_.ERRCAUTER, _s_.HR), check_args = false))
end

function bayesian_network_HRSAT_661(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.HRSAT = resample(ctx, _s_, 661, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", _s_.ERRCAUTER, _s_.HR), check_args = false))
end

function bayesian_network_HR_601(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.HR = resample(ctx, _s_, 601, "HR", Categorical(get_cpt(CPTs, "HR", _s_.CATECHOL), check_args = false))
    _s_.ERRCAUTER = read(ctx, _s_, 621, "ERRCAUTER")
    _s_.HREKG = score(ctx, _s_, 640, "HREKG", Categorical(get_cpt(CPTs, "HREKG", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.HRSAT = score(ctx, _s_, 661, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", _s_.ERRCAUTER, _s_.HR), check_args = false))
    _s_.ERRLOWOUTPUT = read(ctx, _s_, 682, "ERRLOWOUTPUT")
    _s_.HRBP = score(ctx, _s_, 701, "HRBP", Categorical(get_cpt(CPTs, "HRBP", _s_.ERRLOWOUTPUT, _s_.HR), check_args = false))
    _s_.LVFAILURE = read(ctx, _s_, 722, "LVFAILURE")
    _s_.HISTORY = read(ctx, _s_, 741, "HISTORY")
    _s_.HYPOVOLEMIA = read(ctx, _s_, 761, "HYPOVOLEMIA")
    _s_.LVEDVOLUME = read(ctx, _s_, 780, "LVEDVOLUME")
    _s_.PCWP = read(ctx, _s_, 801, "PCWP")
    _s_.CVP = read(ctx, _s_, 821, "CVP")
    _s_.STROKEVOLUME = read(ctx, _s_, 841, "STROKEVOLUME")
    _s_.CO = score(ctx, _s_, 862, "CO", Categorical(get_cpt(CPTs, "CO", _s_.HR, _s_.STROKEVOLUME), check_args = false))
end

function bayesian_network_HYPOVOLEMIA_761(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.HYPOVOLEMIA = resample(ctx, _s_, 761, "HYPOVOLEMIA", Categorical(get_cpt(CPTs, "HYPOVOLEMIA"), check_args = false))
    _s_.LVEDVOLUME = score(ctx, _s_, 780, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.PCWP = read(ctx, _s_, 801, "PCWP")
    _s_.CVP = read(ctx, _s_, 821, "CVP")
    _s_.STROKEVOLUME = score(ctx, _s_, 841, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
end

function bayesian_network_INSUFFANESTH_559(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.INSUFFANESTH = resample(ctx, _s_, 559, "INSUFFANESTH", Categorical(get_cpt(CPTs, "INSUFFANESTH"), check_args = false))
    _s_.CATECHOL = score(ctx, _s_, 578, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
end

function bayesian_network_INTUBATION_234(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.INTUBATION = resample(ctx, _s_, 234, "INTUBATION", Categorical(get_cpt(CPTs, "INTUBATION"), check_args = false))
    _s_.PULMEMBOLUS = read(ctx, _s_, 253, "PULMEMBOLUS")
    _s_.PAP = read(ctx, _s_, 272, "PAP")
    _s_.SHUNT = score(ctx, _s_, 292, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", _s_.INTUBATION, _s_.PULMEMBOLUS), check_args = false))
    _s_.FIO2 = read(ctx, _s_, 313, "FIO2")
    _s_.KINKEDTUBE = read(ctx, _s_, 332, "KINKEDTUBE")
    _s_.PRESS = score(ctx, _s_, 351, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.VENTLUNG = score(ctx, _s_, 373, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.MINVOL = score(ctx, _s_, 395, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.VENTALV = score(ctx, _s_, 416, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
end

function bayesian_network_KINKEDTUBE_332(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.KINKEDTUBE = resample(ctx, _s_, 332, "KINKEDTUBE", Categorical(get_cpt(CPTs, "KINKEDTUBE"), check_args = false))
    _s_.PRESS = score(ctx, _s_, 351, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.VENTLUNG = score(ctx, _s_, 373, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
end

function bayesian_network_LVEDVOLUME_780(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.LVEDVOLUME = resample(ctx, _s_, 780, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.PCWP = score(ctx, _s_, 801, "PCWP", Categorical(get_cpt(CPTs, "PCWP", _s_.LVEDVOLUME), check_args = false))
    _s_.CVP = score(ctx, _s_, 821, "CVP", Categorical(get_cpt(CPTs, "CVP", _s_.LVEDVOLUME), check_args = false))
end

function bayesian_network_LVFAILURE_722(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.LVFAILURE = resample(ctx, _s_, 722, "LVFAILURE", Categorical(get_cpt(CPTs, "LVFAILURE"), check_args = false))
    _s_.HISTORY = score(ctx, _s_, 741, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", _s_.LVFAILURE), check_args = false))
    _s_.HYPOVOLEMIA = read(ctx, _s_, 761, "HYPOVOLEMIA")
    _s_.LVEDVOLUME = score(ctx, _s_, 780, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.PCWP = read(ctx, _s_, 801, "PCWP")
    _s_.CVP = read(ctx, _s_, 821, "CVP")
    _s_.STROKEVOLUME = score(ctx, _s_, 841, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
end

function bayesian_network_MINVOLSET_155(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.MINVOLSET = resample(ctx, _s_, 155, "MINVOLSET", Categorical(get_cpt(CPTs, "MINVOLSET"), check_args = false))
    _s_.VENTMACH = score(ctx, _s_, 174, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", _s_.MINVOLSET), check_args = false))
end

function bayesian_network_MINVOL_395(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.MINVOL = resample(ctx, _s_, 395, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
end

function bayesian_network_PAP_272(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.PAP = resample(ctx, _s_, 272, "PAP", Categorical(get_cpt(CPTs, "PAP", _s_.PULMEMBOLUS), check_args = false))
end

function bayesian_network_PCWP_801(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.PCWP = resample(ctx, _s_, 801, "PCWP", Categorical(get_cpt(CPTs, "PCWP", _s_.LVEDVOLUME), check_args = false))
end

function bayesian_network_PRESS_351(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.PRESS = resample(ctx, _s_, 351, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
end

function bayesian_network_PULMEMBOLUS_253(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.PULMEMBOLUS = resample(ctx, _s_, 253, "PULMEMBOLUS", Categorical(get_cpt(CPTs, "PULMEMBOLUS"), check_args = false))
    _s_.PAP = score(ctx, _s_, 272, "PAP", Categorical(get_cpt(CPTs, "PAP", _s_.PULMEMBOLUS), check_args = false))
    _s_.SHUNT = score(ctx, _s_, 292, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", _s_.INTUBATION, _s_.PULMEMBOLUS), check_args = false))
end

function bayesian_network_PVSAT_478(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.PVSAT = resample(ctx, _s_, 478, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", _s_.FIO2, _s_.VENTALV), check_args = false))
    _s_.SAO2 = score(ctx, _s_, 499, "SAO2", Categorical(get_cpt(CPTs, "SAO2", _s_.PVSAT, _s_.SHUNT), check_args = false))
end

function bayesian_network_SAO2_499(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.SAO2 = resample(ctx, _s_, 499, "SAO2", Categorical(get_cpt(CPTs, "SAO2", _s_.PVSAT, _s_.SHUNT), check_args = false))
    _s_.ANAPHYLAXIS = read(ctx, _s_, 520, "ANAPHYLAXIS")
    _s_.TPR = read(ctx, _s_, 539, "TPR")
    _s_.INSUFFANESTH = read(ctx, _s_, 559, "INSUFFANESTH")
    _s_.CATECHOL = score(ctx, _s_, 578, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
end

function bayesian_network_SHUNT_292(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.SHUNT = resample(ctx, _s_, 292, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", _s_.INTUBATION, _s_.PULMEMBOLUS), check_args = false))
    _s_.FIO2 = read(ctx, _s_, 313, "FIO2")
    _s_.KINKEDTUBE = read(ctx, _s_, 332, "KINKEDTUBE")
    _s_.PRESS = read(ctx, _s_, 351, "PRESS")
    _s_.VENTLUNG = read(ctx, _s_, 373, "VENTLUNG")
    _s_.MINVOL = read(ctx, _s_, 395, "MINVOL")
    _s_.VENTALV = read(ctx, _s_, 416, "VENTALV")
    _s_.ARTCO2 = read(ctx, _s_, 437, "ARTCO2")
    _s_.EXPCO2 = read(ctx, _s_, 457, "EXPCO2")
    _s_.PVSAT = read(ctx, _s_, 478, "PVSAT")
    _s_.SAO2 = score(ctx, _s_, 499, "SAO2", Categorical(get_cpt(CPTs, "SAO2", _s_.PVSAT, _s_.SHUNT), check_args = false))
end

function bayesian_network_STROKEVOLUME_841(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.STROKEVOLUME = resample(ctx, _s_, 841, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", _s_.HYPOVOLEMIA, _s_.LVFAILURE), check_args = false))
    _s_.CO = score(ctx, _s_, 862, "CO", Categorical(get_cpt(CPTs, "CO", _s_.HR, _s_.STROKEVOLUME), check_args = false))
end

function bayesian_network_TPR_539(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.TPR = resample(ctx, _s_, 539, "TPR", Categorical(get_cpt(CPTs, "TPR", _s_.ANAPHYLAXIS), check_args = false))
    _s_.INSUFFANESTH = read(ctx, _s_, 559, "INSUFFANESTH")
    _s_.CATECHOL = score(ctx, _s_, 578, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", _s_.ARTCO2, _s_.INSUFFANESTH, _s_.SAO2, _s_.TPR), check_args = false))
    _s_.HR = read(ctx, _s_, 601, "HR")
    _s_.ERRCAUTER = read(ctx, _s_, 621, "ERRCAUTER")
    _s_.HREKG = read(ctx, _s_, 640, "HREKG")
    _s_.HRSAT = read(ctx, _s_, 661, "HRSAT")
    _s_.ERRLOWOUTPUT = read(ctx, _s_, 682, "ERRLOWOUTPUT")
    _s_.HRBP = read(ctx, _s_, 701, "HRBP")
    _s_.LVFAILURE = read(ctx, _s_, 722, "LVFAILURE")
    _s_.HISTORY = read(ctx, _s_, 741, "HISTORY")
    _s_.HYPOVOLEMIA = read(ctx, _s_, 761, "HYPOVOLEMIA")
    _s_.LVEDVOLUME = read(ctx, _s_, 780, "LVEDVOLUME")
    _s_.PCWP = read(ctx, _s_, 801, "PCWP")
    _s_.CVP = read(ctx, _s_, 821, "CVP")
    _s_.STROKEVOLUME = read(ctx, _s_, 841, "STROKEVOLUME")
    _s_.CO = read(ctx, _s_, 862, "CO")
    _s_.BP = score(ctx, _s_, 883, "BP", Categorical(get_cpt(CPTs, "BP", _s_.CO, _s_.TPR), check_args = false))
end

function bayesian_network_VENTALV_416(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.VENTALV = resample(ctx, _s_, 416, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.ARTCO2 = score(ctx, _s_, 437, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", _s_.VENTALV), check_args = false))
    _s_.EXPCO2 = read(ctx, _s_, 457, "EXPCO2")
    _s_.PVSAT = score(ctx, _s_, 478, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", _s_.FIO2, _s_.VENTALV), check_args = false))
end

function bayesian_network_VENTLUNG_373(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.VENTLUNG = resample(ctx, _s_, 373, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.MINVOL = score(ctx, _s_, 395, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.VENTALV = score(ctx, _s_, 416, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", _s_.INTUBATION, _s_.VENTLUNG), check_args = false))
    _s_.ARTCO2 = read(ctx, _s_, 437, "ARTCO2")
    _s_.EXPCO2 = score(ctx, _s_, 457, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", _s_.ARTCO2, _s_.VENTLUNG), check_args = false))
end

function bayesian_network_VENTMACH_174(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.VENTMACH = resample(ctx, _s_, 174, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", _s_.MINVOLSET), check_args = false))
    _s_.DISCONNECT = read(ctx, _s_, 194, "DISCONNECT")
    _s_.VENTTUBE = score(ctx, _s_, 213, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", _s_.DISCONNECT, _s_.VENTMACH), check_args = false))
end

function bayesian_network_VENTTUBE_213(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State)
    _s_.VENTTUBE = resample(ctx, _s_, 213, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", _s_.DISCONNECT, _s_.VENTMACH), check_args = false))
    _s_.INTUBATION = read(ctx, _s_, 234, "INTUBATION")
    _s_.PULMEMBOLUS = read(ctx, _s_, 253, "PULMEMBOLUS")
    _s_.PAP = read(ctx, _s_, 272, "PAP")
    _s_.SHUNT = read(ctx, _s_, 292, "SHUNT")
    _s_.FIO2 = read(ctx, _s_, 313, "FIO2")
    _s_.KINKEDTUBE = read(ctx, _s_, 332, "KINKEDTUBE")
    _s_.PRESS = score(ctx, _s_, 351, "PRESS", Categorical(get_cpt(CPTs, "PRESS", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
    _s_.VENTLUNG = score(ctx, _s_, 373, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", _s_.INTUBATION, _s_.KINKEDTUBE, _s_.VENTTUBE), check_args = false))
end

function bayesian_network_factor(ctx::AbstractFactorResampleContext, CPTs::CPTsDict, _s_::State, _addr_::String)
    if _s_.node_id == 520
        return bayesian_network_ANAPHYLAXIS_520(ctx, CPTs, _s_)
    end
    if _s_.node_id == 437
        return bayesian_network_ARTCO2_437(ctx, CPTs, _s_)
    end
    if _s_.node_id == 883
        return bayesian_network_BP_883(ctx, CPTs, _s_)
    end
    if _s_.node_id == 578
        return bayesian_network_CATECHOL_578(ctx, CPTs, _s_)
    end
    if _s_.node_id == 862
        return bayesian_network_CO_862(ctx, CPTs, _s_)
    end
    if _s_.node_id == 821
        return bayesian_network_CVP_821(ctx, CPTs, _s_)
    end
    if _s_.node_id == 194
        return bayesian_network_DISCONNECT_194(ctx, CPTs, _s_)
    end
    if _s_.node_id == 621
        return bayesian_network_ERRCAUTER_621(ctx, CPTs, _s_)
    end
    if _s_.node_id == 682
        return bayesian_network_ERRLOWOUTPUT_682(ctx, CPTs, _s_)
    end
    if _s_.node_id == 457
        return bayesian_network_EXPCO2_457(ctx, CPTs, _s_)
    end
    if _s_.node_id == 313
        return bayesian_network_FIO2_313(ctx, CPTs, _s_)
    end
    if _s_.node_id == 741
        return bayesian_network_HISTORY_741(ctx, CPTs, _s_)
    end
    if _s_.node_id == 701
        return bayesian_network_HRBP_701(ctx, CPTs, _s_)
    end
    if _s_.node_id == 640
        return bayesian_network_HREKG_640(ctx, CPTs, _s_)
    end
    if _s_.node_id == 661
        return bayesian_network_HRSAT_661(ctx, CPTs, _s_)
    end
    if _s_.node_id == 601
        return bayesian_network_HR_601(ctx, CPTs, _s_)
    end
    if _s_.node_id == 761
        return bayesian_network_HYPOVOLEMIA_761(ctx, CPTs, _s_)
    end
    if _s_.node_id == 559
        return bayesian_network_INSUFFANESTH_559(ctx, CPTs, _s_)
    end
    if _s_.node_id == 234
        return bayesian_network_INTUBATION_234(ctx, CPTs, _s_)
    end
    if _s_.node_id == 332
        return bayesian_network_KINKEDTUBE_332(ctx, CPTs, _s_)
    end
    if _s_.node_id == 780
        return bayesian_network_LVEDVOLUME_780(ctx, CPTs, _s_)
    end
    if _s_.node_id == 722
        return bayesian_network_LVFAILURE_722(ctx, CPTs, _s_)
    end
    if _s_.node_id == 155
        return bayesian_network_MINVOLSET_155(ctx, CPTs, _s_)
    end
    if _s_.node_id == 395
        return bayesian_network_MINVOL_395(ctx, CPTs, _s_)
    end
    if _s_.node_id == 272
        return bayesian_network_PAP_272(ctx, CPTs, _s_)
    end
    if _s_.node_id == 801
        return bayesian_network_PCWP_801(ctx, CPTs, _s_)
    end
    if _s_.node_id == 351
        return bayesian_network_PRESS_351(ctx, CPTs, _s_)
    end
    if _s_.node_id == 253
        return bayesian_network_PULMEMBOLUS_253(ctx, CPTs, _s_)
    end
    if _s_.node_id == 478
        return bayesian_network_PVSAT_478(ctx, CPTs, _s_)
    end
    if _s_.node_id == 499
        return bayesian_network_SAO2_499(ctx, CPTs, _s_)
    end
    if _s_.node_id == 292
        return bayesian_network_SHUNT_292(ctx, CPTs, _s_)
    end
    if _s_.node_id == 841
        return bayesian_network_STROKEVOLUME_841(ctx, CPTs, _s_)
    end
    if _s_.node_id == 539
        return bayesian_network_TPR_539(ctx, CPTs, _s_)
    end
    if _s_.node_id == 416
        return bayesian_network_VENTALV_416(ctx, CPTs, _s_)
    end
    if _s_.node_id == 373
        return bayesian_network_VENTLUNG_373(ctx, CPTs, _s_)
    end
    if _s_.node_id == 174
        return bayesian_network_VENTMACH_174(ctx, CPTs, _s_)
    end
    if _s_.node_id == 213
        return bayesian_network_VENTTUBE_213(ctx, CPTs, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return bayesian_network(ctx, CPTs)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return bayesian_network(ctx, CPTs, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return bayesian_network_factor(ctx, CPTs, _s_, _addr_)
end
