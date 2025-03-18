using Gen
include("lmh.jl")

modelname = "markov_chain"

get_row(x::AbstractMatrix, i) = x[i, :]

@gen function markov_chain()
    TERMINAL_STATE::Int = 4
    transition_probs::Matrix{Float64} = [
        0.1 0.2 0.6 0.1;
        0.05 0.8 0.1 0.05;
        0.3 0.3 0.3 0.1
    ]

    current::Int = {:initial_state} ~ categorical([0.33, 0.33, 0.34])
    i::Int = 1 
    while current != TERMINAL_STATE
        current = {:state => i} ~ categorical(get_row(transition_probs, current))
        i = i + 1
    end
end

struct MarkovChainLMHSelector <: LMHSelector end
function get_length(::MarkovChainLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return get_length(trace)
end

function get_resample_address(selector::MarkovChainLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)
    U = rand()
    if U < 1/N
        return :initial_state
    else
        i = rand(1:N-1)
        return :state => i
    end
end
N_iter = name_to_N[modelname]

model = markov_chain
args = ()
observations = choicemap();
selector = MarkovChainLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))

f = open("compare/gen/results.csv", "a")
println(f, modelname, ",", acceptance_rate, ",", base_time*10^6, ",", "-", ",", "-")