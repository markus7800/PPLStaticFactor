using Gen
include("lmh.jl")

modelname = "geometric"

@gen function geometric(p::Float64)
    i::Int = -1
    b::Bool = true
    while b 
        i = i + 1
        b = {:b => i} ~ bernoulli(p)
    end
    {:x} ~ normal(i, 1.0)
    return i
end

struct GeometricLMHSelector <: LMHSelector end
function get_length(::GeometricLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return get_length(trace) - 1
end
function get_resample_address(selector::GeometricLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    total = get_length(selector, trace, args, observations)
    return :b => rand(0:total-1)
end

N_iter = name_to_N[modelname]

model = geometric
args = (0.5,)
observations = choicemap(:x => 5.);

selector = GeometricLMHSelector()

acceptance_rate = lmh(N_seeds, N_iter, selector, model, args, observations, check=true)
res = @timed lmh(N_seeds, N_iter, selector, model, args, observations)
base_time = res.time / (N_iter * N_seeds)
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))

f = open("compare/gen/lmh_results.csv", "a")
println(f, modelname, ",", N_iter, ",", acceptance_rate, ",", base_time*10^6, ",", "NA", ",", "NA")