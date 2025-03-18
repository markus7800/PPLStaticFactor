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
    return i
end

struct GeometricLMHSelector <: LMHSelector end
function get_resample_address(selector::GeometricLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    total = get_length(selector, trace, args, observations)
    return :blib => rand(0:total-1)
end
function get_length(::GeometricLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return get_length(trace)
end

N = name_to_N[modelname]

model = geometric
args = (0.5,)
observations = choicemap();

selector = GeometricLMHSelector()

acceptance_rate = lmh(10, N ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N ÷ 10, selector, model, args, observations)
println(@sprintf("Gen time: %.3f μs", res.time / N * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))