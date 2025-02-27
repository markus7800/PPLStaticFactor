using Gen
include("lmh.jl")

modelname = "urn"

struct Dirac <: Gen.Distribution{Int} end
const dirac = Dirac()

function Gen.logpdf(::Dirac, x::Int, v::Int)
    return (x == v) ? log(1.) : -Inf
end
# function Gen.random(::Dirac, v::Int)
#     return v
# end
is_discrete(::Dirac) = true

@gen function urn(K::Int)
    N::Int = {:N} ~ poisson(6)
    balls::Vector{Int} = Int[]
    i::Int = 1
    while i <= N
        ball::Int = {:ball => i} ~ bernoulli(0.5)
        balls = vcat(balls, ball)
        i = i + 1
    end
    n_black::Int = 0
    if N > 0
        k::Int = 1
        while k <= K
            ball_ix::Int = {:drawn_ball => k} ~ uniform_discrete(1,N)
            n_black = n_black + balls[min(length(balls), ball_ix)]
            k = k + 1
        end
    end
    # {:n_black} ~ dirac(n_black)
    {:n_black} ~ normal(n_black, 0.1)
end

K = 10

model = urn
args = (K,)
observations = choicemap()
observations[:n_black] = 5

N = name_to_N[modelname]
acceptance_rate = lmh(10, N ÷ 10, model, args, observations)
res = @timed lmh(10, N ÷ 10, model, args, observations)
println(@sprintf("Gen time %.3f μs", res.time / N * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))