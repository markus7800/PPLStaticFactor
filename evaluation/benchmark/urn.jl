# source: Brian Milch, Bhaskara Marthi, David Sontag, Stuart Russell, Daniel L Ong, and Andrey Kolobov. 2005.
# Approximate inference for infinite contingent Bayesian networks. In International Workshop on Artificial Intelligence and Statistics. PMLR, 238–245.

include("../ppl.jl")

modelname = "urn"
proposers = Dict{String, Distribution}()

@model function urn(ctx::SampleContext, K::Int)
    N::Int = sample(ctx, "N", Poisson(6))
    balls::Vector{Int} = Int[]
    i::Int = 1
    while i <= N
        ball::Int = sample(ctx, "ball_" * string(i), Bernoulli(0.5))
        balls = vcat(balls, ball)
        i = i + 1
    end
    n_black::Int = 0
    if N > 0
        k::Int = 1
        while k <= K
            ball_ix::Int = sample(ctx, "drawn_ball_" * string(k), DiscreteUniform(1,N))
            n_black = n_black + get_n(balls, min(length(balls), ball_ix))
            k = k + 1
        end
    end
    # sample(ctx, "n_black", Dirac(n_black), observed=5)
    sample(ctx, "n_black", Normal(n_black, 0.1), observed=5.) # make noisy to make single-site updates possible
end

K = 10