using Gen
include("lmh.jl")

modelname = "gmm_variable_numclust"

@gen function gmm(ys::Vector{Float64})
    δ::Float64 = 5.0
    ξ::Float64 = 0.0
    κ::Float64 = 0.01
    α::Float64 = 2.0
    β::Float64 = 10.0

    num_clusters::Int = {:num_clusters} ~ poisson(3.)
    num_clusters = num_clusters + 1

    w::Vector{Float64} = {:w} ~ dirichlet(fill(δ,num_clusters))

    k::Int = 1
    means::Vector{Float64} = Float64[]
    while k <= num_clusters
        mu::Float64 = {:mu => k} ~ normal(ξ, 1/sqrt(κ))
        means = vcat(means, mu)
        k = k + 1
    end
    k = 1
    vars::Vector{Float64} = Float64[]
    while k <= num_clusters
        var::Float64 = {:var => k} ~ inv_gamma(α, β)
        vars = vcat(vars, var)
        k = k + 1
    end


    i::Int = 1
    while i <= length(ys)
        z::Int = {:z => i} ~ categorical(w)
        z = min(z, length(means))
        {:y => i} ~ normal(means[z], vars[z])
        i = i + 1
    end

end

struct GMMLMHSelector <: LMHSelector
end
function get_length(::GMMLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    ys = args[1]
    N = length(ys)
    K = trace[:num_clusters] + 1
    return 2 + 2*K + N
end
function get_resample_address(::GMMLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    ys = args[1]
    N = length(ys)
    K = trace[:num_clusters] + 1
    total = 2 + 2*K + N

    U = rand()
    n = 1
    if U < n/total
        return :num_clusters
    end
    n += 1
    if U < n/total
        return :w
    end
    for k in 1:K
        n += 1
        if U < n/total
            return :mu => k
        end
        n += 1
        if U < n/total
            return :var => k
        end
    end
    for i in 1:N
        n += 1
        if U < n/total
            return :z => i
        end
    end
end


gt_k = 4
gt_ys = [-7.87951290075215, -23.251364738213493, -5.34679518882793, -3.163770449770572,
10.524424782864525, 5.911987013277482, -19.228378698266436, 0.3898087330050574,
8.576922415766697, 7.727416085566447, -18.043123523482492, 9.108136117789305,
29.398734347901787, 2.8578485031858003, -20.716691460295685, -18.5075008084623,
-21.52338318392563, 10.062657028986715, -18.900545157827718, 3.339430437507262,
3.688098690412526, 4.209808727262307, 3.371091291010914, 30.376814419984456,
12.778653273596902, 28.063124205174137, 10.70527515161964, -18.99693615834304,
8.135342537554163, 29.720363913218446, 29.426043027354385, 28.40516772785764,
31.975585225366686, -20.642437143912638, 30.84807631345935, -21.46602061526647,
12.854676808303978, 30.685416799345685, 5.833520737134923, 7.602680172973942,
10.045516408942117, 28.62342173081479, -20.120184774438087, -18.80125468061715,
12.849708921404385, 31.342270731653656, 4.02761078481315, -19.953549865339976,
-2.574052170014683, -21.551814470820258, -2.8751904316333268,
13.159719198798443, 8.060416669497197, 12.933573330915458, 0.3325664001681059,
11.10817217269102, 28.12989207125211, 11.631846911966806, -15.90042467317705,
-0.8270272159702201, 11.535190070081708, 4.023136673956579,
-22.589713328053048, 28.378124912868305, -22.57083855780972,
29.373356677376297, 31.87675796607244, 2.14864533495531, 12.332798078071061,
8.434664672995181, 30.47732238916884, 11.199950328766784, 11.072188217008367,
29.536932243938097, 8.128833670186253, -16.33296115562885, 31.103677511944685,
-20.96644212192335, -20.280485886015406, 30.37107537844197, 10.581901339669418,
-4.6722903116912375, -20.320978011296315, 9.141857987635252, -18.6727012563551,
7.067728508554964, 5.664227155828871, 30.751158861494442, -20.198961378110013,
-4.689645356611053, 30.09552608716476, -19.31787364001907, -22.432589846769154,
-0.9580412415863696, 14.180597007125487, 4.052110659466889,
-18.978055134755582, 13.441194891615718, 7.983890038551439, 7.759003567480592]
gt_zs = [2, 1, 2, 2, 3, 3, 1, 2, 3, 3, 1, 3, 4, 2, 1, 1, 1, 3, 1, 2, 2, 3, 2, 4, 3, 4,
      3, 1, 3, 4, 4, 4, 4, 1, 4, 1, 3, 4, 3, 3, 3, 4, 1, 1, 3, 4, 3, 1, 2, 1, 2,
      3, 3, 3, 2, 3, 4, 3, 1, 2, 3, 2, 1, 4, 1, 4, 4, 2, 3, 3, 4, 3, 3, 4, 3, 1,
      4, 1, 1, 4, 3, 2, 1, 3, 1, 3, 3, 4, 1, 2, 4, 1, 1, 2, 3, 2, 1, 3, 3, 3]
gt_ws = [0.20096082191563705, 0.22119959941799663, 0.3382086364817468, 0.23963094218461967]
gt_μs = [-20.0, 0.0, 10.0, 30.0]
gt_σ²s = [3.0, 8.0, 7.0, 1.0]

ys = gt_ys

N_iter = name_to_N[modelname]

model = gmm
args = (ys,)
observations = choicemap();
for i in eachindex(gt_ys)
    observations[:y => i] = gt_ys[i]
end
selector = GMMLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


# === Implementation with Combinators  ===

@gen function get_mu(k::Int)::Float64
    ξ::Float64 = 0.0
    κ::Float64 = 0.01
    mu::Float64 = {:mu} ~ normal(ξ, 1/sqrt(κ))
    return mu
end
const get_mus = Map(get_mu)

@gen function get_var(k::Int)::Float64
    α::Float64 = 2.0
    β::Float64 = 10.0
    var::Float64 = {:var} ~ inv_gamma(α, β)
    return var
end
const get_vars = Map(get_var)

@gen function observe_y(w::Vector{Float64}, means::AbstractVector{Float64}, vars::AbstractVector{Float64})
    z::Int = {:z} ~ categorical(w)
    z = min(z, length(means))
    {:y} ~ normal(means[z], vars[z])
end
const map_observe_y = Map(observe_y)

@gen (static) function gmm_combinator(ys::Vector{Float64})
    δ::Float64 = 5.0

    num_clusters::Int = {:num_clusters} ~ poisson(3.)
    num_clusters = num_clusters + 1

    w::Vector{Float64} = {:w} ~ dirichlet(fill(δ,num_clusters))

    means ~ get_mus(1:num_clusters)
    vars ~ get_vars(1:num_clusters)

    {:data} ~ map_observe_y(fill(w, length(ys)), fill(means, length(ys)), fill(vars, length(ys)))

end

struct GMMCombinatorLMHSelector <: LMHSelector
end
function get_length(::GMMCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    ys = args[1]
    N = length(ys)
    K = trace[:num_clusters] + 1
    return 2 + 2*K + N
end
function get_resample_address(::GMMCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    ys = args[1]
    N = length(ys)
    K = trace[:num_clusters] + 1
    total = 2 + 2*K + N

    U = rand()
    n = 1
    if U < n/total
        return :num_clusters
    end
    n += 1
    if U < n/total
        return :w
    end
    for k in 1:K
        n += 1
        if U < n/total
            return :means => k => :mu
        end
        n += 1
        if U < n/total
            return :vars => k => :var
        end
    end
    for i in 1:N
        n += 1
        if U < n/total
            return :data => i => :z
        end
    end
end

model = gmm_combinator
args = (ys,)
observations = choicemap();
for i in eachindex(gt_ys)
    observations[:data => i => :y] = gt_ys[i]
end
selector = GMMCombinatorLMHSelector()


acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
combinator_time = res.time / N_iter
println(@sprintf("Gen combinator time: %.3f μs", combinator_time * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


f = open("compare/gen/results.csv", "a")
println(f, modelname, ",", N_iter, ",", acceptance_rate, ",", base_time*10^6, ",", combinator_time*10^6, ",", combinator_time / base_time)