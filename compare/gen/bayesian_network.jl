# source: https://www.bnlearn.com/bnrepository/discrete-medium.html#alarm

using Gen
include("lmh.jl")

modelname = "bayesian_network"

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

function Gen.random(::Gen.Categorical, probs::AbstractArray{U,1}) where {U <: Real}
    rand(Gen.Distributions.Categorical(probs, check_args=false))
end

@gen function bayesian_network(CPTs::CPTsDict)
    MINVOLSET ~ categorical(get_cpt(CPTs, "MINVOLSET"))
    VENTMACH ~ categorical(get_cpt(CPTs, "VENTMACH", MINVOLSET))
    DISCONNECT ~ categorical(get_cpt(CPTs, "DISCONNECT"))
    VENTTUBE ~ categorical(get_cpt(CPTs, "VENTTUBE", DISCONNECT, VENTMACH))
    INTUBATION ~ categorical(get_cpt(CPTs, "INTUBATION"))
    PULMEMBOLUS ~ categorical(get_cpt(CPTs, "PULMEMBOLUS"))
    PAP ~ categorical(get_cpt(CPTs, "PAP", PULMEMBOLUS))
    SHUNT ~ categorical(get_cpt(CPTs, "SHUNT", INTUBATION, PULMEMBOLUS))
    FIO2 ~ categorical(get_cpt(CPTs, "FIO2"))
    KINKEDTUBE ~ categorical(get_cpt(CPTs, "KINKEDTUBE"))
    PRESS ~ categorical(get_cpt(CPTs, "PRESS", INTUBATION, KINKEDTUBE, VENTTUBE))
    VENTLUNG ~ categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION, KINKEDTUBE, VENTTUBE))
    MINVOL ~ categorical(get_cpt(CPTs, "MINVOL", INTUBATION, VENTLUNG))
    VENTALV ~ categorical(get_cpt(CPTs, "VENTALV", INTUBATION, VENTLUNG))
    ARTCO2 ~ categorical(get_cpt(CPTs, "ARTCO2", VENTALV))
    EXPCO2 ~ categorical(get_cpt(CPTs, "EXPCO2", ARTCO2, VENTLUNG))
    PVSAT ~ categorical(get_cpt(CPTs, "PVSAT", FIO2, VENTALV))
    SAO2 ~ categorical(get_cpt(CPTs, "SAO2", PVSAT, SHUNT))
    ANAPHYLAXIS ~ categorical(get_cpt(CPTs, "ANAPHYLAXIS"))
    TPR ~ categorical(get_cpt(CPTs, "TPR", ANAPHYLAXIS))
    INSUFFANESTH ~ categorical(get_cpt(CPTs, "INSUFFANESTH"))
    CATECHOL ~ categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH, SAO2, TPR))
    HR ~ categorical(get_cpt(CPTs, "HR", CATECHOL))
    ERRCAUTER ~ categorical(get_cpt(CPTs, "ERRCAUTER"))
    HREKG ~ categorical(get_cpt(CPTs, "HREKG", ERRCAUTER, HR))
    HRSAT ~ categorical(get_cpt(CPTs, "HRSAT", ERRCAUTER, HR))
    ERRLOWOUTPUT ~ categorical(get_cpt(CPTs, "ERRLOWOUTPUT"))
    HRBP ~ categorical(get_cpt(CPTs, "HRBP", ERRLOWOUTPUT, HR))
    LVFAILURE ~ categorical(get_cpt(CPTs, "LVFAILURE"))
    HISTORY ~ categorical(get_cpt(CPTs, "HISTORY", LVFAILURE))
    HYPOVOLEMIA ~ categorical(get_cpt(CPTs, "HYPOVOLEMIA"))
    LVEDVOLUME ~ categorical(get_cpt(CPTs, "LVEDVOLUME", HYPOVOLEMIA, LVFAILURE))
    PCWP ~ categorical(get_cpt(CPTs, "PCWP", LVEDVOLUME))
    CVP ~ categorical(get_cpt(CPTs, "CVP", LVEDVOLUME))
    STROKEVOLUME ~ categorical(get_cpt(CPTs, "STROKEVOLUME", HYPOVOLEMIA, LVFAILURE))
    CO ~ categorical(get_cpt(CPTs, "CO", HR, STROKEVOLUME))
    BP ~ categorical(get_cpt(CPTs, "BP", CO, TPR))
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
    # "PVSAT" => [1.0 0.99; 0.0 0.01; 0.0 0.0;;; 0.95 0.95; 0.04 0.04; 0.01 0.01;;; 1.0 0.95; 0.0 0.04; 0.0 0.01;;; 0.01 0.01; 0.95 0.01; 0.04 0.98],    "PVSAT" => [0.99 0.98; 0.005 0.015; 0.005 0.005;;; 0.95 0.95; 0.04 0.04; 0.01 0.01;;; 0.99 0.95; 0.005 0.04; 0.005 0.01;;; 0.01 0.01; 0.95 0.01; 0.04 0.98],
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

struct BayesianNetworkLMHSelector <: LMHSelector end
function get_length(::BayesianNetworkLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return 37
end
function get_resample_address(selector::BayesianNetworkLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    return rand([:MINVOLSET, :VENTMACH, :DISCONNECT, :VENTTUBE, :INTUBATION, :PULMEMBOLUS, :PAP, :SHUNT, :FIO2, :KINKEDTUBE, :PRESS, :VENTLUNG, :MINVOL, :VENTALV, :ARTCO2, :EXPCO2, :PVSAT, :SAO2, :ANAPHYLAXIS, :TPR, :INSUFFANESTH, :CATECHOL, :HR, :ERRCAUTER, :HREKG, :HRSAT, :ERRLOWOUTPUT, :HRBP, :LVFAILURE, :HISTORY, :HYPOVOLEMIA, :LVEDVOLUME, :PCWP, :CVP, :STROKEVOLUME, :CO, :BP])
end

N_iter = name_to_N[modelname]

model = bayesian_network
args = (CPTs,)
observations = choicemap()

selector = BayesianNetworkLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


# === Implementation with Combinators  ===


@gen (static) function bayesian_network_static(CPTs::CPTsDict)
    MINVOLSET ~ categorical(get_cpt(CPTs, "MINVOLSET"))
    VENTMACH ~ categorical(get_cpt(CPTs, "VENTMACH", MINVOLSET))
    DISCONNECT ~ categorical(get_cpt(CPTs, "DISCONNECT"))
    VENTTUBE ~ categorical(get_cpt(CPTs, "VENTTUBE", DISCONNECT, VENTMACH))
    INTUBATION ~ categorical(get_cpt(CPTs, "INTUBATION"))
    PULMEMBOLUS ~ categorical(get_cpt(CPTs, "PULMEMBOLUS"))
    PAP ~ categorical(get_cpt(CPTs, "PAP", PULMEMBOLUS))
    SHUNT ~ categorical(get_cpt(CPTs, "SHUNT", INTUBATION, PULMEMBOLUS))
    FIO2 ~ categorical(get_cpt(CPTs, "FIO2"))
    KINKEDTUBE ~ categorical(get_cpt(CPTs, "KINKEDTUBE"))
    PRESS ~ categorical(get_cpt(CPTs, "PRESS", INTUBATION, KINKEDTUBE, VENTTUBE))
    VENTLUNG ~ categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION, KINKEDTUBE, VENTTUBE))
    MINVOL ~ categorical(get_cpt(CPTs, "MINVOL", INTUBATION, VENTLUNG))
    VENTALV ~ categorical(get_cpt(CPTs, "VENTALV", INTUBATION, VENTLUNG))
    ARTCO2 ~ categorical(get_cpt(CPTs, "ARTCO2", VENTALV))
    EXPCO2 ~ categorical(get_cpt(CPTs, "EXPCO2", ARTCO2, VENTLUNG))
    PVSAT ~ categorical(get_cpt(CPTs, "PVSAT", FIO2, VENTALV))
    SAO2 ~ categorical(get_cpt(CPTs, "SAO2", PVSAT, SHUNT))
    ANAPHYLAXIS ~ categorical(get_cpt(CPTs, "ANAPHYLAXIS"))
    TPR ~ categorical(get_cpt(CPTs, "TPR", ANAPHYLAXIS))
    INSUFFANESTH ~ categorical(get_cpt(CPTs, "INSUFFANESTH"))
    CATECHOL ~ categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH, SAO2, TPR))
    HR ~ categorical(get_cpt(CPTs, "HR", CATECHOL))
    ERRCAUTER ~ categorical(get_cpt(CPTs, "ERRCAUTER"))
    HREKG ~ categorical(get_cpt(CPTs, "HREKG", ERRCAUTER, HR))
    HRSAT ~ categorical(get_cpt(CPTs, "HRSAT", ERRCAUTER, HR))
    ERRLOWOUTPUT ~ categorical(get_cpt(CPTs, "ERRLOWOUTPUT"))
    HRBP ~ categorical(get_cpt(CPTs, "HRBP", ERRLOWOUTPUT, HR))
    LVFAILURE ~ categorical(get_cpt(CPTs, "LVFAILURE"))
    HISTORY ~ categorical(get_cpt(CPTs, "HISTORY", LVFAILURE))
    HYPOVOLEMIA ~ categorical(get_cpt(CPTs, "HYPOVOLEMIA"))
    LVEDVOLUME ~ categorical(get_cpt(CPTs, "LVEDVOLUME", HYPOVOLEMIA, LVFAILURE))
    PCWP ~ categorical(get_cpt(CPTs, "PCWP", LVEDVOLUME))
    CVP ~ categorical(get_cpt(CPTs, "CVP", LVEDVOLUME))
    STROKEVOLUME ~ categorical(get_cpt(CPTs, "STROKEVOLUME", HYPOVOLEMIA, LVFAILURE))
    CO ~ categorical(get_cpt(CPTs, "CO", HR, STROKEVOLUME))
    BP ~ categorical(get_cpt(CPTs, "BP", CO, TPR))
end


model = bayesian_network_static

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
combinator_time = res.time / N_iter
println(@sprintf("Gen combinator time: %.3f μs", combinator_time * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))

f = open("compare/gen/results.csv", "a")
println(f, modelname, ",", N_iter, ",", acceptance_rate, ",", base_time*10^6, ",", combinator_time*10^6, ",", combinator_time / base_time)