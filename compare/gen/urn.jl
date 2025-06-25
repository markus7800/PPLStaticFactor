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


struct UrnLMHSelector <: LMHSelector end
function get_length(::UrnLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    K = args[1]
    N = trace[:N]
    return N > 0 ? 1 + N + K : 1
end
function get_resample_address(selector::UrnLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)
    K = args[1]
    N = trace[:N]

    U = rand()

    n = 1
    if U < n/N
        return :N
    end

    for i in 1:N
        n += 1
        if U < n/N
            return :ball => i
        end
    end
    if N > 0
        for k in 1:K
            n += 1
            if U < n/N
                return :drawn_ball => k
            end
        end
    end
end

K = 10

N_iter = name_to_N[modelname]

model = urn
args = (K,)
observations = choicemap()
observations[:n_black] = 5

selector = UrnLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


# === Implementation with Combinators  ===

@gen function gen_ball(i::Int)::Int
    ball::Int = {:ball} ~ bernoulli(0.5)
    return ball
end
const gen_balls = Map(gen_ball)

@gen function draw_ball(N::Int)::Int
    if N > 0
        ball_ix::Int = {:drawn_ball} ~ uniform_discrete(1,N)
        return ball_ix
    else
        return 0
    end
end
const draw_balls = Map(draw_ball)

function count_n_black(N::Int, balls::AbstractVector, drawn_ball_ixs::AbstractVector)::Int
    if N > 0
        return sum(balls[min(length(balls), ix)] for ix in drawn_ball_ixs)
    else
        return 0
    end
end

@gen (static) function urn_combinator(K::Int)
    N::Int = {:N} ~ poisson(6)
    balls ~ gen_balls(1:N)
    drawn_ball_ixs ~ draw_balls(fill(N,K))
    n_black = count_n_black(N, balls, drawn_ball_ixs)
    # {:n_black} ~ dirac(n_black)
    {:n_black} ~ normal(n_black, 0.1)
end

# tr, _ = generate(urn_combinator, args, observations);
# get_choices(tr)


struct UrnCombinatorLMHSelector <: LMHSelector end
function get_length(::UrnCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    K = args[1]
    N = trace[:N]
    return N > 0 ? 1 + N + K : 1
end
function get_resample_address(selector::UrnCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)
    K = args[1]
    N = trace[:N]

    U = rand()

    n = 1
    if U < n/N
        return :N
    end

    for i in 1:N
        n += 1
        if U < n/N
            return :balls => i => :ball
        end
    end
    if N > 0
        for k in 1:K
            n += 1
            if U < n/N
                return :drawn_ball_ixs => k => :drawn_ball
            end
        end
    end
end

model = urn_combinator
selector = UrnCombinatorLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
combinator_time = res.time / N_iter
println(@sprintf("Gen combinator time: %.3f μs", combinator_time * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


f = open("compare/gen/lmh_results.csv", "a")
println(f, modelname, ",", N_iter, ",", acceptance_rate, ",", base_time*10^6, ",", combinator_time*10^6, ",", combinator_time / base_time)