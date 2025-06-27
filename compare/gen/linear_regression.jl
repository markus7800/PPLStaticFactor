using Gen
include("lmh.jl")

modelname = "linear_regression"

@gen function lr(xs::Vector{Float64})
    slope::Float64 = {:slope} ~ normal(0.,3.)
    intercept::Float64 = {:intercept} ~ normal(0.,3.)

    i::Int = 1
    while i <= length(xs)
        {:y => i} ~ normal(slope * xs[i] + intercept, 1.)
        i = i + 1
    end
end


struct LinregLMHSelector <: LMHSelector end
function get_length(::LinregLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return 2
end
function get_resample_address(selector::LinregLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    return rand([:slope, :intercept])
end

xs = [
    0.85, 0.52, -0.96, -0.3, -0.89, 1.45, -0.63, -1.57, 0.43, -1.06, 0.98, 0.86, 0.2, 0.29, 2.25,
    -0.97, 0.26, 0.05, 0.5, -0.38, 0.77, 0.81, 0.88, -0.26, -0.26, -0.51, 0.17, 0.33, 0.59, 0.3,
    0.19, 0.83, -0.13, -0.31, 1.58, -0.13, 0.39, 0.25, -0.41, 0.47, -0.49, 0.58, -1.63, -1.02, 0.52,
    1.09, 0.75, -0.6, 1.11, -0.35, 0.49, 0.58, 0.15, -0.47, 0.68, -0.36, 0.26, -0.51, -0.45, 0.73,
    0.86, 0.04, 1.4, 0.27, 0.03, 0.48, -0.33, 0.08, 0.5, 1.59, 1.22, -0.46, 0.87, -0.74, -0.18, 0.35,
    0.5, 0.5, -1.17, -0.1, 0.01, -0.64, -0.47, 0.7, -0.73, 0.03, 0.63, -0.7, 0.65, 0.04, 0.92, 1.22,
    1.42, -0.0, 0.25, 0.99, -0.23, -0.98, 0.65, 1.15
]
ys = [
    1.83, 0.09, -3.15, -2.52, -2.65, 3.48, -1.27, -2.79, -0.4, -3.34, 0.34, 1.3, -0.25, -0.56,
    2.16, -2.69, -0.79, -2.44, -1.84, -0.59, 0.95, 0.3, 1.15, -1.64, -0.56, -1.65, -1.27, 0.5, 0.02,
    -0.32, -0.69, 1.42, 0.14, -1.96, 2.42, -1.51, -0.96, -1.75, -3.62, 0.54, -2.5, 0.33, -5.34, -3.28,
    -0.3, 1.96, -0.49, -3.69, 1.56, -1.5, -0.7, -0.42, 0.57, -3.49, 0.83, -2.13, -0.9, -0.86, -1.55,
    1.82, 1.72, -2.94, 0.23, -0.04, -0.99, 0.69, -0.81, -1.94, 0.67, 2.9, 0.05, -1.49, 0.01, -2.82,
    1.07, 0.57, 0.25, 2.38, -2.6, -2.58, 1.1, -2.64, -1.56, 1.32, -3.92, -0.97, 0.15, -0.42, 0.14,
    -3.54, 0.96, 1.39, 1.66, -1.04, 1.32, 0.97, -2.62, -3.53, 2.96, 2.63
]


N_iter = name_to_N[modelname]

model = lr
args = (xs,)
observations = choicemap();

for i in eachindex(ys)
    observations[:y => i] = ys[i]
end

selector = LinregLMHSelector()

acceptance_rate = lmh(N_seeds, N_iter, selector, model, args, observations, check=true)
res = @timed lmh(N_seeds, N_iter, selector, model, args, observations)
base_time = res.time / (N_iter * N_seeds)
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))

# === Implementation with Combinators  ===

@gen function observe_y(x::Float64, slope::Float64, intercept::Float64)
    {:y} ~ normal(slope * x + intercept, 1.)
end
const observe_ys = Map(observe_y)

@gen (static) function lr_combinator(xs::Vector{Float64})
    slope::Float64 = {:slope} ~ normal(0.,3.)
    intercept::Float64 = {:intercept} ~ normal(0.,3.)

    {:data} ~ observe_ys(xs, fill(slope, length(xs)), fill(intercept, length(xs)))
end

model = lr_combinator
args = (xs,)
observations = choicemap();

for i in eachindex(ys)
    observations[:data => i => :y] = ys[i]
end


acceptance_rate = lmh(N_seeds, N_iter, selector, model, args, observations, check=true)
res = @timed lmh(N_seeds, N_iter, selector, model, args, observations)
combinator_time = res.time / (N_iter * N_seeds)
println(@sprintf("Gen combinator time: %.3f μs", combinator_time * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


f = open("compare/gen/lmh_results.csv", "a")
println(f, modelname, ",", N_iter*N_seeds, ",", acceptance_rate, ",", base_time*10^6, ",", combinator_time*10^6, ",", combinator_time / base_time)