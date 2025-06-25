using Gen
include("lmh.jl")

modelname = "pedestrian"

@gen function pedestrian()
    start::Float64 = {:start} ~ uniform_continuous(0.,1.)
    position::Float64 = start
    distance::Float64 = 0
    i::Int = 1
    while position > 0 && distance < 10
        step = {:step => i} ~ uniform_continuous(-1.,1.)
        position = position + step
        distance = distance + abs(step)
        i = i + 1
    end
    {:final_distance} ~ normal(distance, 0.1)
end
struct PedestrianLMHSelector <: LMHSelector end
function get_length(::PedestrianLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return get_length(trace) - 1
end
function get_resample_address(selector::PedestrianLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)

    if rand() < 1/N
        return :start
    else
        return :step => rand(1:(N-1))
    end
end

N_iter = name_to_N[modelname]

model = pedestrian
args = ()
observations = choicemap()
observations[:final_distance] = 1.1

selector = PedestrianLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))

f = open("compare/gen/lmh_results.csv", "a")
println(f, modelname, ",", N_iter, ",", acceptance_rate, ",", base_time*10^6, ",", "NA", ",", "NA")