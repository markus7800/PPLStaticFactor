using Gen
include("lmh.jl")

modelname = "lda_variable_numtopic"

append = push!

@gen function lda(M::Int, N::Int, V::Int, doc::Vector{Int})
    K::Int = {:K} ~ poisson(2) # num topics
    K = K + 1

    thetas::Vector{Vector{Float64}} = Vector{Vector{Float64}}() # topic dist for doc m

    i::Int = 1
    while i <= M
        theta = {:theta => i} ~ dirichlet(fill(1/K, K))
        thetas = append(thetas, theta)
        i = i + 1
    end

    phis::Vector{Vector{Float64}} = Vector{Vector{Float64}}() # word dist for topic k

    i = 1
    while i <= K
        phi = {:phi => i} ~ dirichlet(fill(1/V,V))
        phis = append(phis, phi)
        i = i + 1
    end

    n::Int = 1
    while n <= N
        z = {:z => n} ~ categorical(thetas[doc[n]])
        z = min(length(phis),z)
        {:w => n} ~ categorical(phis[z])
        n = n + 1
    end
end

w::Vector{Int} = [4, 3, 5, 4, 3, 3, 3, 3, 3, 4, 5, 3, 4, 4, 5, 3, 4, 4, 4, 3, 5, 4, 5, 2, 3, 3, 1, 5, 5, 1, 4, 3, 1, 2, 5, 4, 4, 3, 5, 4, 2, 4, 5, 3, 4, 1, 4, 4, 3, 2, 1, 2, 1, 2, 2, 2, 1, 2, 2, 3, 1, 2, 2, 4, 4, 5, 4, 5, 5, 4, 3, 5, 4, 4, 4, 2, 2, 1, 1, 2, 1, 3, 1, 2, 1, 1, 1, 3, 2, 3, 3, 5, 4, 5, 4, 3, 5, 4, 2, 2, 2, 1, 3, 2, 1, 3, 1, 3, 1, 1, 2, 1, 2, 2, 4, 4, 4, 5, 5, 4, 4, 5, 4, 3, 3, 3, 1, 3, 3, 4, 2, 1, 3, 4, 4, 5, 4, 4, 4, 3, 4, 3, 4, 5, 1, 2, 1, 3, 2, 1, 1, 2, 3, 3, 3, 3, 4, 1, 4, 4, 4, 4, 3, 4, 4, 1, 2, 2, 3, 3, 1, 1, 4, 1, 3, 1, 5, 3, 2, 2, 1, 1, 2, 3, 3, 4, 4, 5, 3, 4, 3, 1, 5, 5, 5, 3, 3, 4, 5, 3, 3, 3, 2, 3, 1, 3, 3, 1, 3, 1, 5, 5, 5, 2, 2, 3, 3, 3, 1, 1, 5, 5, 5, 3, 1, 5, 4, 1, 3, 3, 3, 3, 4, 2, 5, 1, 3, 5, 2, 5, 5, 2, 1, 3, 3, 5, 3, 5, 3, 3, 5, 1, 2, 2, 1, 1, 2, 1, 2, 3, 1, 1]
doc::Vector{Int} = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 12, 12, 12, 12, 13, 13, 13, 13, 13, 13, 13, 13, 13, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 19, 19, 19, 19, 19, 19, 19, 19, 19, 20, 20, 20, 20, 20, 20, 20, 20, 20, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 22, 22, 22, 22, 22, 22, 22, 22, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25]
M = 25  # num docs
N = 262 # total word instances
V = 5  # num words

struct LDALMHSelector <: LMHSelector end
function get_length(::LDALMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    K = trace[:K] + 1
    M, N, V, _ = args
    return 1 + M + K + N
end
function get_resample_address(selector::LDALMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    total = get_length(selector, trace, args, observations)
    K = trace[:K] + 1
    M, N, V, _ = args
    U = rand()

    n = 1
    if U < n/total
        return :K
    end
    for i in 1:M
        n += 1
        if U < n/total
            return :theta => i
        end
    end
    for i in 1:K
        n += 1
        if U < n/total
            return :phi => i
        end
    end
    for i in 1:N
        n += 1
        if U < n/total
            return :z => i
        end
    end
end

N_iter = name_to_N[modelname]

model = lda
args = (M,N,V,doc)
observations = choicemap();
for n in eachindex(w)
    observations[:w => n] = w[n]
end

selector = LDALMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


# === Implementation with Combinators  ===


@gen function gen_theta(K::Int)::Vector{Float64}
    theta = {:theta} ~ dirichlet(fill(1/K, K))
    return theta
end
const gen_thetas = Map(gen_theta)

@gen function gen_phi(V::Int)::Vector{Float64}
    phi = {:phi} ~ dirichlet(fill(1/V,V))
    return phi
end
const gen_phis = Map(gen_phi)


@gen function gen_z(n::Int, thetas, phis)
    z = {:z} ~ categorical(thetas[doc[n]])
    z = min(length(phis),z)
    {:w} ~ categorical(phis[z])
end
const gen_zs = Map(gen_z)

@gen (static) function lda_combinator(M::Int, N::Int, V::Int, doc::Vector{Int})
    K::Int = {:K} ~ poisson(2) # num topics
    K = K + 1

    thetas ~ gen_thetas(fill(K,M))

    phis ~ gen_phis(fill(V,K))

    data ~ gen_zs(1:N, fill(thetas,N), fill(phis, N))
end


# tr, _ = generate(lda_combinator, args, observations);
# display(get_choices(tr))

struct LDACombinatorLMHSelector <: LMHSelector end
function get_length(::LDACombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    K = trace[:K] + 1
    M, N, V, _ = args
    return 1 + M + K + N
end
function get_resample_address(selector::LDACombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    total = get_length(selector, trace, args, observations)
    K = trace[:K] + 1
    M, N, V, _ = args
    U = rand()

    n = 1
    if U < n/total
        return :K
    end
    for i in 1:M
        n += 1
        if U < n/total
            return :thetas => i => :theta
        end
    end
    for i in 1:K
        n += 1
        if U < n/total
            return :phis => i => :phi
        end
    end
    for i in 1:N
        n += 1
        if U < n/total
            return :data => i => :z
        end
    end
end

model = lda_combinator

observations = choicemap();
for n in eachindex(w)
    observations[:data => n => :w] = w[n]
end

selector = LDACombinatorLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
combinator_time = res.time / N_iter
println(@sprintf("Gen combinator time: %.3f μs", combinator_time * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


f = open("compare/gen/results.csv", "a")
println(f, modelname, ",", acceptance_rate, ",", base_time*10^6, ",", combinator_time*10^6, ",", combinator_time / base_time)