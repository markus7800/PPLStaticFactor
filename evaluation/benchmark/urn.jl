include("ppl.jl")

modelname = "urn"

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
            n_black = n_black = get_n(balls, min(length(balls), ball_ix))
            k = k + 1
        end
    end
    sample(ctx, "n_black", Dirac(n_black), observed=5)
end

K = 10