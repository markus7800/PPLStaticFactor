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
function get_length(::MarkovChainLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return get_length(trace)
end

N = name_to_N[modelname]

model = markov_chain
args = ()
observations = choicemap();
selector = MarkovChainLMHSelector()

acceptance_rate = lmh(10, N ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N ÷ 10, selector, model, args, observations)
println(@sprintf("Gen time: %.3f μs", res.time / N * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


# @gen function hmm_step(t::Int, current::Int, transition_probs::Matrix{Float64})::Int
#     current = {:state} ~ categorical(get_row(transition_probs, current))
#     {:obs} ~ normal(current, 1)
#     return current
# end

# const hmm_unfold = Unfold(hmm_step)

# @gen (static) function hmm_combinator(ys)

#     seqlen::Int = length(ys)

#     transition_probs::Matrix{Float64} = [
#         0.1 0.2 0.7;
#         0.1 0.8 0.1;
#         0.3 0.3 0.4;
#     ]

#     current::Int = {:initial_state} ~ categorical([0.33, 0.33, 0.34])
    
#     states ~ hmm_unfold(seqlen, current, transition_probs)
# end

# # tr, _ = generate(hmm_combinator, args, observations)
# # display(get_choices(tr))

# struct HMMCombinatorLMHSelector <: LMHSelector end
# function get_resample_address(selector::HMMCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
#     N = get_length(selector, trace, args, observations)
#     U = rand()
#     if U < 1/N
#         return :initial_state
#     else
#         i = rand(1:N-1)
#         return :states => i => :state
#     end
# end
# function get_length(::HMMCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
#     ys = args[1]
#     return length(ys) + 1
# end

# model = hmm_combinator
# observations = choicemap();
# for i in eachindex(ys)
#     observations[:states => i => :obs] = ys[i]
# end
# selector = HMMCombinatorLMHSelector()


# acceptance_rate = lmh(10, N ÷ 10, selector, model, args, observations, check=true)
# res = @timed lmh(10, N ÷ 10, selector, model, args, observations)
# println(@sprintf("Gen combinator, time: %.3f μs", res.time / N * 10^6))
# println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))
