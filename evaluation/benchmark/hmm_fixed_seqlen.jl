# info: https://en.wikipedia.org/wiki/Hidden_Markov_model

include("../ppl.jl")

modelname = "hmm_fixed_seqlen"
proposers = Dict{String, Distribution}()

@model function hmm(ctx::SampleContext, ys::Vector{Float64})

    seqlen::Int = length(ys)

    transition_probs::Matrix{Float64} = [
        0.1 0.2 0.7;
        0.1 0.8 0.1;
        0.3 0.3 0.4;
    ]

    current::Int = sample(ctx, "initial_state", Categorical([0.33, 0.33, 0.34]))
    i::Int = 1 
    while i <= seqlen
        current = sample(ctx, "state_" * string(i), Categorical(get_row(transition_probs, current)))
        sample(ctx, "obs_" * string(i), Normal(current, 1), observed=get_n(ys,i))
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
    1.12
]