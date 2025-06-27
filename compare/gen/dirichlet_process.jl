using Gen
include("lmh.jl")

modelname = "dirichlet_process"

@gen function dp(xs::Vector{Float64})
    alpha::Float64 = 5.0
    stick::Float64 = 1.0
    beta::Float64 = 0.0
    cumprod::Float64 = 1.0

    weights::Vector{Float64} = Float64[]
    thetas::Vector{Float64} = Float64[]
    i::Int = 0
    while stick > 0.01
        i = i + 1
        cumprod = cumprod * (1. - beta)
        beta = {:beta => i} ~ Gen.beta(1., alpha)
        theta::Float64 = {:theta => i} ~ normal(0.,1.)
        stick = stick - beta * cumprod

        weights = vcat(weights, beta * cumprod)
        thetas = vcat(thetas, theta)
    end

    j::Int = 1
    while j <= length(xs)
        z::Int = {:z => j} ~ categorical(weights / sum(weights))
        z = min(z, length(thetas))
        {:x => j} ~ normal(thetas[z], 0.1)
        j = j + 1
    end
end

means = [0.76, 0.30, 0.89, 0.34, 0.16, 0.69, 0.28, 0.39, 0.55]
zs = [7, 8, 5, 7, 4, 6, 3, 3, 6, 1, 3, 1, 3, 1, 4, 3, 4, 4, 8, 8, 5, 7, 8, 4, 5, 9, 5, 3, 2, 1, 7, 6, 2, 4, 5, 8, 2, 8, 3, 3, 1, 7, 1, 7, 4, 9, 2, 3, 8, 3]
xs = [0.42, 0.29, -0.01, 0.37, 0.23, 0.54, 0.95, 0.9, 0.48, 0.82, 0.88, 0.61, 0.83, 0.56, 0.42, 0.83, 0.36, 0.41, 0.51, 0.39, 0.06, 0.23, 0.4, 0.33, 0.23, 0.49, 0.13, 1.06, 0.22, 0.65, 0.25, 0.6, 0.25, 0.28, 0.23, 0.45, 0.34, 0.29, 0.88, 0.83, 0.81, 0.27, 0.72, 0.27, 0.43, 0.51, 0.35, 0.91, 0.31, 0.83]


struct DirichletProcessLMHSelector <: LMHSelector end
function get_length(::DirichletProcessLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    xs = args[1]
    return get_length(trace) - length(xs)
end
function get_resample_address(selector::DirichletProcessLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    total = get_length(selector, trace, args, observations)
    xs = args[1]
    N_data = length(xs)
    N_stick = (total - N_data) ÷ 2
    if rand() < N_data / total
        return :z => rand(1:N_data)
    else
        i = rand(1:N_stick)
        if rand() < 0.5
            return :beta => i
        else
            return :theta => i
        end
    end
end


N_iter = name_to_N[modelname]

model = dp
args = (xs,)
observations = choicemap();
for j in eachindex(xs)
    observations[:x => j] = xs[j]
end

selector = DirichletProcessLMHSelector()

acceptance_rate = lmh(N_seeds, N_iter, selector, model, args, observations, check=true)
res = @timed lmh(N_seeds, N_iter, selector, model, args, observations)
base_time = res.time / (N_iter * N_seeds)
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


f = open("compare/gen/lmh_results.csv", "a")
println(f, modelname, ",", N_iter, ",", acceptance_rate, ",", base_time*10^6, ",", "NA", ",", "NA")