
include("../ppl.jl")

modelname = "hmm_fixed_seqlen_unrolled"
proposers = Dict{String, Distribution}()

@model function hmm(ctx::SampleContext, ys::Vector{Float64})

    transition_probs::Matrix{Float64} = [
        0.1 0.2 0.7;
        0.1 0.8 0.1;
        0.3 0.3 0.4;
    ]

    current::Int = sample(ctx, "initial_state", Categorical([0.33, 0.33, 0.34]))
    for i in 1:10
        current = sample(ctx, "state_" * string(i), Categorical(get_row(transition_probs, current)))
        sample(ctx, "obs_" * string(i), Normal(current, 1), observed=get_n(ys,i))
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