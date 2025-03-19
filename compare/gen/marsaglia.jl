using Gen
include("lmh.jl")

modelname = "marsaglia"

@gen function marsaglia()
    s::Float64 = Inf
    x::Float64 = 0.
    y::Float64 = 0.
    i::Int = 1
    while s > 1
        x = {:x => i} ~ uniform_continuous(-1.,1.)
        y = {:y => i} ~ uniform_continuous(-1.,1.)
        s = x^2 + y^2
        i = i + 1
    end
    z::Float64 = x * sqrt(-2 * log(s) / s)
    return z
end

struct MarsagliaLMHSelector <: LMHSelector end
function get_length(::MarsagliaLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return get_length(trace)
end
function get_resample_address(selector::MarsagliaLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)

    i = rand(1:(N÷2))
    if rand() < 0.5
        return :x => i
    else
        return :y => i
    end
end


N_iter = name_to_N[modelname]

model = marsaglia
args = ()
observations = choicemap();

selector = MarsagliaLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))

f = open("compare/gen/results.csv", "a")
println(f, modelname, ",", N_iter, ",", acceptance_rate, ",", base_time*10^6, ",", "NA", ",", "NA")