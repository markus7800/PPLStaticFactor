using Gen
include("lmh.jl")

modelname = "hmm"

get_row(x::AbstractMatrix, i) = x[i, :]

@gen function hmm(ys)

    seqlen::Int = length(ys)

    transition_probs::Matrix{Float64} = [
        0.1 0.2 0.7;
        0.1 0.8 0.1;
        0.3 0.3 0.4;
    ]

    current::Int = {:initial_state} ~ categorical([0.33, 0.33, 0.34])
    i::Int = 1 
    while i <= seqlen
        current = {:state => i} ~ categorical(get_row(transition_probs, current))
        {:obs => i} ~ normal(current, 1)
        i = i + 1
    end
end

struct HMMLMHSelector <: LMHSelector end
function get_length(::HMMLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    ys = args[1]
    return length(ys) + 1
end
function get_resample_address(selector::HMMLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)
    U = rand()
    if U < 1/N
        return :initial_state
    else
        i = rand(1:N-1)
        return :state => i
    end
end

ys = [
    3.36, 2.87, 1.54, 1.13, 2.05, 2.55, 3.08, 1.23, 2.37, 2.5,
    1.42, 1.46, 0.65, 1.15, 0.31, 2.89, 0.96, 2.23, 1.55, 1.52,
    2.72, 4.16, 2.4, 2.41, 1.05, 3.05, 2.04, 3.47, 1.08, 0.63,
    3.87, 0.08, 2.06, 2.21, 2.24, 1.77, 0.67, 2.45, 4.05, 2.95,
    1.65, 3.01, 3.74, 1.54, 2.47, 1.54, 3.7, 4.29, 0.93, 1.95, 
]

N_iter = name_to_N[modelname]

model = hmm
args = (ys,)
observations = choicemap();
for i in eachindex(ys)
    observations[:obs => i] = ys[i]
end
selector = HMMLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


# === Implementation with Combinators  ===


@gen function hmm_step(t::Int, current::Int, transition_probs::Matrix{Float64})::Int
    current = {:state} ~ categorical(get_row(transition_probs, current))
    {:obs} ~ normal(current, 1)
    return current
end

const hmm_unfold = Unfold(hmm_step)

@gen (static) function hmm_combinator(ys)

    seqlen::Int = length(ys)

    transition_probs::Matrix{Float64} = [
        0.1 0.2 0.7;
        0.1 0.8 0.1;
        0.3 0.3 0.4;
    ]

    current::Int = {:initial_state} ~ categorical([0.33, 0.33, 0.34])
    
    states ~ hmm_unfold(seqlen, current, transition_probs)
end

# tr, _ = generate(hmm_combinator, args, observations)
# display(get_choices(tr))

struct HMMCombinatorLMHSelector <: LMHSelector end
function get_length(::HMMCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    ys = args[1]
    return length(ys) + 1
end
function get_resample_address(selector::HMMCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)
    U = rand()
    if U < 1/N
        return :initial_state
    else
        i = rand(1:N-1)
        return :states => i => :state
    end
end

model = hmm_combinator
observations = choicemap();
for i in eachindex(ys)
    observations[:states => i => :obs] = ys[i]
end
selector = HMMCombinatorLMHSelector()


acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
combinator_time = res.time / N_iter
println(@sprintf("Gen combinator time: %.3f μs", combinator_time * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


f = open("compare/gen/results.csv", "a")
println(f, modelname, ",", acceptance_rate, ",", base_time*10^6, ",", combinator_time*10^6, ",", combinator_time / base_time)