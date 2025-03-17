# info: https://en.wikipedia.org/wiki/Hidden_Markov_model

include("../ppl.jl")

modelname = "markov_chain"
proposers = Dict{String, Distribution}()

@model function markov_chain(ctx::SampleContext)
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
        i = i + 1
    end
end