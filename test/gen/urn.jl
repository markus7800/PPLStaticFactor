using Gen
include("lmh.jl")


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

function lmh_custom(n_iter::Int, model, args, observations)
    Random.seed!(0)

    trace, lp = generate(model, args, observations)
    # println(trace)

    n_accepted = 0
    for i in 1:n_iter
        resample_address1 = rand(setdiff(get_addresses(trace.trie), get_addresses(observations)))
        resample_address2 = rand(setdiff(get_addresses(trace.trie), get_addresses(observations)))
        # println(resample_address)
        new_trace, accept = mh(trace, select(resample_address1, resample_address2), observations=observations, check=true)
        accept = accept && (rand() < get_length(trace.trie) / get_length(new_trace.trie))

        if accept
            trace = new_trace
            n_accepted += 1
        end
    end  
    println(n_accepted / n_iter)
end

lmh(100_000, model, args, observations)
lmh_custom(100_000, model, args, observations)