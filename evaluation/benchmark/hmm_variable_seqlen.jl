# info: https://en.wikipedia.org/wiki/Hidden_Markov_model

include("../ppl.jl")

modelname = "hmm_variable_seqlen"

@model function hmm(ctx::SampleContext, ys::Vector{Float64})
    TERMINAL_STATE::Int = 4
    transition_probs::Matrix{Float64} = [
        0.1 0.2 0.6 0.1;
        0.05 0.8 0.1 0.05;
        0.3 0.3 0.3 0.1
    ]

    current::Int = sample(ctx, "initial_state", Categorical([0.33, 0.33, 0.34]))
    i::Int = 1
    while current != TERMINAL_STATE
        current = sample(ctx, "state_" * string(i), Categorical(get_row(transition_probs, current)))
        if i <= length(ys)
            sample(ctx, "obs_" * string(i), Normal(current == TERMINAL_STATE ? 100.0 : current, 1.), observed=get_n(ys,i))
        end
        i = i + 1
    end
end

ys = [
    0.57,
    2.14,
    2.53,
    3.05,
    2.17,
    2.4,
    3.01,
    3.55,
    0.65,
    1.12,
    100.,
]