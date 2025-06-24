# source: https://www.bnlearn.com/bnrepository/discrete-medium.html#alarm

include("../ppl.jl")

modelname = "bayesian_network"
proposers = Dict{String, Distribution}()

CPTsDict = Dict{String,Array{Float64}}

function get_cpt(CPTs::CPTsDict, addr::String)
    return CPTs[addr]
end

function get_cpt(CPTs::CPTsDict, addr::String, ix1::Int)
    return CPTs[addr][:,ix1]
end

function get_cpt(CPTs::CPTsDict, addr::String, ix1::Int, ix2::Int)
    return CPTs[addr][:,ix1, ix2]
end

function get_cpt(CPTs::CPTsDict, addr::String, ix1::Int, ix2::Int, ix3::Int)
    return CPTs[addr][:,ix1, ix2, ix3]
end

function get_cpt(CPTs::CPTsDict, addr::String, ix1::Int, ix2::Int, ix3::Int, ix4::Int)
    return CPTs[addr][:,ix1, ix2, ix3, ix4]
end

@model function bayesian_network(ctx::SampleContext, CPTs::CPTsDict)
    MINVOLSET::Int = sample(ctx, "MINVOLSET", Categorical(get_cpt(CPTs, "MINVOLSET"), check_args=false))
    VENTMACH::Int = sample(ctx, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", MINVOLSET), check_args=false))
    DISCONNECT::Int = sample(ctx, "DISCONNECT", Categorical(get_cpt(CPTs, "DISCONNECT"), check_args=false))
    VENTTUBE::Int = sample(ctx, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", DISCONNECT, VENTMACH), check_args=false))
    INTUBATION::Int = sample(ctx, "INTUBATION", Categorical(get_cpt(CPTs, "INTUBATION"), check_args=false))
    PULMEMBOLUS::Int = sample(ctx, "PULMEMBOLUS", Categorical(get_cpt(CPTs, "PULMEMBOLUS"), check_args=false))
    PAP::Int = sample(ctx, "PAP", Categorical(get_cpt(CPTs, "PAP", PULMEMBOLUS), check_args=false))
    SHUNT::Int = sample(ctx, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", INTUBATION, PULMEMBOLUS), check_args=false))
    FIO2::Int = sample(ctx, "FIO2", Categorical(get_cpt(CPTs, "FIO2"), check_args=false))
    KINKEDTUBE::Int = sample(ctx, "KINKEDTUBE", Categorical(get_cpt(CPTs, "KINKEDTUBE"), check_args=false))
    PRESS::Int = sample(ctx, "PRESS", Categorical(get_cpt(CPTs, "PRESS", INTUBATION, KINKEDTUBE, VENTTUBE), check_args=false))
    VENTLUNG::Int = sample(ctx, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION, KINKEDTUBE, VENTTUBE), check_args=false))
    MINVOL::Int = sample(ctx, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", INTUBATION, VENTLUNG), check_args=false))
    VENTALV::Int = sample(ctx, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", INTUBATION, VENTLUNG), check_args=false))
    ARTCO2::Int = sample(ctx, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", VENTALV), check_args=false))
    EXPCO2::Int = sample(ctx, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", ARTCO2, VENTLUNG), check_args=false))
    PVSAT::Int = sample(ctx, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", FIO2, VENTALV), check_args=false))
    SAO2::Int = sample(ctx, "SAO2", Categorical(get_cpt(CPTs, "SAO2", PVSAT, SHUNT), check_args=false))
    ANAPHYLAXIS::Int = sample(ctx, "ANAPHYLAXIS", Categorical(get_cpt(CPTs, "ANAPHYLAXIS"), check_args=false))
    TPR::Int = sample(ctx, "TPR", Categorical(get_cpt(CPTs, "TPR", ANAPHYLAXIS), check_args=false))
    INSUFFANESTH::Int = sample(ctx, "INSUFFANESTH", Categorical(get_cpt(CPTs, "INSUFFANESTH"), check_args=false))
    CATECHOL::Int = sample(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH, SAO2, TPR), check_args=false))
    HR::Int = sample(ctx, "HR", Categorical(get_cpt(CPTs, "HR", CATECHOL), check_args=false))
    ERRCAUTER::Int = sample(ctx, "ERRCAUTER", Categorical(get_cpt(CPTs, "ERRCAUTER"), check_args=false))
    HREKG::Int = sample(ctx, "HREKG", Categorical(get_cpt(CPTs, "HREKG", ERRCAUTER, HR), check_args=false))
    HRSAT::Int = sample(ctx, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", ERRCAUTER, HR), check_args=false))
    ERRLOWOUTPUT::Int = sample(ctx, "ERRLOWOUTPUT", Categorical(get_cpt(CPTs, "ERRLOWOUTPUT"), check_args=false))
    HRBP::Int = sample(ctx, "HRBP", Categorical(get_cpt(CPTs, "HRBP", ERRLOWOUTPUT, HR), check_args=false))
    LVFAILURE::Int = sample(ctx, "LVFAILURE", Categorical(get_cpt(CPTs, "LVFAILURE"), check_args=false))
    HISTORY::Int = sample(ctx, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", LVFAILURE), check_args=false))
    HYPOVOLEMIA::Int = sample(ctx, "HYPOVOLEMIA", Categorical(get_cpt(CPTs, "HYPOVOLEMIA"), check_args=false))
    LVEDVOLUME::Int = sample(ctx, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", HYPOVOLEMIA, LVFAILURE), check_args=false))
    PCWP::Int = sample(ctx, "PCWP", Categorical(get_cpt(CPTs, "PCWP", LVEDVOLUME), check_args=false))
    CVP::Int = sample(ctx, "CVP", Categorical(get_cpt(CPTs, "CVP", LVEDVOLUME), check_args=false))
    STROKEVOLUME::Int = sample(ctx, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", HYPOVOLEMIA, LVFAILURE), check_args=false))
    CO::Int = sample(ctx, "CO", Categorical(get_cpt(CPTs, "CO", HR, STROKEVOLUME), check_args=false))
    BP::Int = sample(ctx, "BP", Categorical(get_cpt(CPTs, "BP", CO, TPR), check_args=false))
end

CPTs = Dict{String, Array{Float64}}(
    "MINVOLSET" => [0.05, 0.9, 0.05],
    "VENTMACH" => [0.05 0.05 0.05; 0.93 0.01 0.01; 0.01 0.93 0.01; 0.01 0.01 0.93],
    "DISCONNECT" => [0.1, 0.9],
    "VENTTUBE" => [0.97 0.97; 0.01 0.01; 0.01 0.01; 0.01 0.01;;; 0.97 0.97; 0.01 0.01; 0.01 0.01; 0.01 0.01;;; 0.97 0.01; 0.01 0.97; 0.01 0.01; 0.01 0.01;;; 0.01 0.01; 0.01 0.01; 0.97 0.01; 0.01 0.97],
    "INTUBATION" => [0.92, 0.03, 0.05],
    "PULMEMBOLUS" => [0.01, 0.99],
    "PAP" => [0.01 0.05; 0.19 0.9; 0.8 0.05],
    "SHUNT" => [0.1 0.1 0.01; 0.9 0.9 0.99;;; 0.95 0.95 0.05; 0.05 0.05 0.95],
    "FIO2" => [0.05, 0.95],
    "KINKEDTUBE" => [0.04, 0.96],
    "PRESS" => [0.97 0.01 0.01; 0.01 0.3 0.01; 0.01 0.49 0.08; 0.01 0.2 0.9;;; 0.01 0.97 0.1; 0.01 0.01 0.84; 0.01 0.01 0.05; 0.97 0.01 0.01;;;; 0.05 0.01 0.97; 0.25 0.15 0.01; 0.25 0.25 0.01; 0.45 0.59 0.01;;; 0.01 0.01 0.01; 0.29 0.01 0.01; 0.3 0.08 0.01; 0.4 0.9 0.97;;;; 0.97 0.01 0.01; 0.01 0.97 0.01; 0.01 0.01 0.97; 0.01 0.01 0.01;;; 0.01 0.97 0.4; 0.01 0.01 0.58; 0.01 0.01 0.01; 0.97 0.01 0.01;;;; 0.2 0.2 0.97; 0.75 0.7 0.01; 0.04 0.09 0.01; 0.01 0.01 0.01;;; 0.01 0.01 0.01; 0.9 0.01 0.01; 0.08 0.38 0.01; 0.01 0.6 0.97],
    "VENTLUNG" => [0.97 0.95 0.4; 0.01 0.03 0.58; 0.01 0.01 0.01; 0.01 0.01 0.01;;; 0.3 0.97 0.97; 0.68 0.01 0.01; 0.01 0.01 0.01; 0.01 0.01 0.01;;;; 0.97 0.97 0.97; 0.01 0.01 0.01; 0.01 0.01 0.01; 0.01 0.01 0.01;;; 0.95 0.5 0.3; 0.03 0.48 0.68; 0.01 0.01 0.01; 0.01 0.01 0.01;;;; 0.97 0.01 0.01; 0.01 0.97 0.01; 0.01 0.01 0.97; 0.01 0.01 0.01;;; 0.01 0.97 0.97; 0.01 0.01 0.01; 0.01 0.01 0.01; 0.97 0.01 0.01;;;; 0.97 0.97 0.97; 0.01 0.01 0.01; 0.01 0.01 0.01; 0.01 0.01 0.01;;; 0.01 0.01 0.01; 0.97 0.01 0.01; 0.01 0.97 0.01; 0.01 0.01 0.97],
    "MINVOL" => [0.97 0.01 0.01; 0.01 0.97 0.01; 0.01 0.01 0.97; 0.01 0.01 0.01;;; 0.01 0.97 0.6; 0.01 0.01 0.38; 0.01 0.01 0.01; 0.97 0.01 0.01;;; 0.5 0.5 0.97; 0.48 0.48 0.01; 0.01 0.01 0.01; 0.01 0.01 0.01;;; 0.01 0.01 0.01; 0.97 0.01 0.01; 0.01 0.97 0.01; 0.01 0.01 0.97],
    "VENTALV" => [0.97 0.01 0.01; 0.01 0.97 0.01; 0.01 0.01 0.97; 0.01 0.01 0.01;;; 0.01 0.97 0.01; 0.01 0.01 0.97; 0.01 0.01 0.01; 0.97 0.01 0.01;;; 0.01 0.01 0.97; 0.01 0.01 0.01; 0.97 0.01 0.01; 0.01 0.97 0.01;;; 0.03 0.01 0.01; 0.95 0.94 0.88; 0.01 0.04 0.1; 0.01 0.01 0.01],
    "ARTCO2" => [0.01 0.01 0.04 0.9; 0.01 0.01 0.92 0.09; 0.98 0.98 0.04 0.01],
    "EXPCO2" => [0.97 0.01 0.01; 0.01 0.97 0.97; 0.01 0.01 0.01; 0.01 0.01 0.01;;; 0.01 0.97 0.01; 0.97 0.01 0.01; 0.01 0.01 0.97; 0.01 0.01 0.01;;; 0.01 0.01 0.97; 0.01 0.01 0.01; 0.97 0.97 0.01; 0.01 0.01 0.01;;; 0.01 0.01 0.01; 0.01 0.01 0.01; 0.01 0.01 0.01; 0.97 0.97 0.97],
    # "PVSAT" => [1.0 0.99; 0.0 0.01; 0.0 0.0;;; 0.95 0.95; 0.04 0.04; 0.01 0.01;;; 1.0 0.95; 0.0 0.04; 0.0 0.01;;; 0.01 0.01; 0.95 0.01; 0.04 0.98],
    "PVSAT" => [0.99 0.98; 0.005 0.015; 0.005 0.005;;; 0.95 0.95; 0.04 0.04; 0.01 0.01;;; 0.99 0.95; 0.005 0.04; 0.005 0.01;;; 0.01 0.01; 0.95 0.01; 0.04 0.98],
    "SAO2" => [0.98 0.01 0.01; 0.01 0.98 0.01; 0.01 0.01 0.98;;; 0.98 0.98 0.69; 0.01 0.01 0.3; 0.01 0.01 0.01],
    "ANAPHYLAXIS" => [0.01, 0.99],
    "TPR" => [0.98 0.3; 0.01 0.4; 0.01 0.3],
    "INSUFFANESTH" => [0.1, 0.9],
    "CATECHOL" => [0.01 0.01 0.01; 0.99 0.99 0.99;;; 0.01 0.01 0.01; 0.99 0.99 0.99;;;; 0.01 0.01 0.01; 0.99 0.99 0.99;;; 0.01 0.01 0.01; 0.99 0.99 0.99;;;; 0.01 0.01 0.01; 0.99 0.99 0.99;;; 0.05 0.05 0.01; 0.95 0.95 0.99;;;;; 0.01 0.01 0.01; 0.99 0.99 0.99;;; 0.05 0.05 0.01; 0.95 0.95 0.99;;;; 0.05 0.05 0.01; 0.95 0.95 0.99;;; 0.05 0.05 0.01; 0.95 0.95 0.99;;;; 0.05 0.05 0.01; 0.95 0.95 0.99;;; 0.05 0.05 0.01; 0.95 0.95 0.99;;;;; 0.7 0.7 0.1; 0.3 0.3 0.9;;; 0.7 0.7 0.1; 0.3 0.3 0.9;;;; 0.7 0.7 0.1; 0.3 0.3 0.9;;; 0.95 0.99 0.3; 0.05 0.01 0.7;;;; 0.95 0.99 0.3; 0.05 0.01 0.7;;; 0.95 0.99 0.3; 0.05 0.01 0.7],
    "HR" => [0.05 0.01; 0.9 0.09; 0.05 0.9],
    "ERRCAUTER" => [0.1, 0.9],
    "HREKG" => [0.3333333 0.3333333; 0.3333333 0.3333333; 0.3333333 0.3333333;;; 0.3333333 0.98; 0.3333333 0.01; 0.3333333 0.01;;; 0.01 0.01; 0.98 0.01; 0.01 0.98],
    "HRSAT" => [0.3333333 0.3333333; 0.3333333 0.3333333; 0.3333333 0.3333333;;; 0.3333333 0.98; 0.3333333 0.01; 0.3333333 0.01;;; 0.01 0.01; 0.98 0.01; 0.01 0.98],
    "ERRLOWOUTPUT" => [0.05, 0.95],
    "HRBP" => [0.98 0.4; 0.01 0.59; 0.01 0.01;;; 0.3 0.98; 0.4 0.01; 0.3 0.01;;; 0.01 0.01; 0.98 0.01; 0.01 0.98],
    "LVFAILURE" => [0.05, 0.95],
    "HISTORY" => [0.9 0.01; 0.1 0.99],
    "HYPOVOLEMIA" => [0.2, 0.8],
    "LVEDVOLUME" => [0.95 0.98; 0.04 0.01; 0.01 0.01;;; 0.01 0.05; 0.09 0.9; 0.9 0.05],
    "PCWP" => [0.95 0.04 0.01; 0.04 0.95 0.04; 0.01 0.01 0.95],
    "CVP" => [0.95 0.04 0.01; 0.04 0.95 0.29; 0.01 0.01 0.7],
    "STROKEVOLUME" => [0.98 0.95; 0.01 0.04; 0.01 0.01;;; 0.5 0.05; 0.49 0.9; 0.01 0.05],
    "CO" => [0.98 0.95 0.8; 0.01 0.04 0.19; 0.01 0.01 0.01;;; 0.95 0.04 0.01; 0.04 0.95 0.04; 0.01 0.01 0.95;;; 0.3 0.01 0.01; 0.69 0.3 0.01; 0.01 0.69 0.98],
    "BP" => [0.98 0.98 0.9; 0.01 0.01 0.09; 0.01 0.01 0.01;;; 0.98 0.1 0.05; 0.01 0.85 0.2; 0.01 0.05 0.75;;; 0.3 0.05 0.01; 0.6 0.4 0.09; 0.1 0.55 0.9],
)