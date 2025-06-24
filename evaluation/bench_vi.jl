using Printf

include(ARGS[1] * "/generated/" * ARGS[2])
if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm", "lda_fixed_numtopic", "bayesian_network")
    include("finite/"  * ARGS[2])
end
if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
    include("custom/"  * ARGS[2])
end

include("vi.jl")

# bbvi(1000, 100, 0.001, model)

name_to_N = Dict{String,Int}(
    "aircraft" => 1000,
    "bayesian_network" => 1000,
    "captcha" => 10,
    "dirichlet_process" => 1000,
    "geometric" => 1000,
    "gmm_fixed_numclust" => 1000,
    "hmm" => 1000,
    "hurricane" => 1000,
    "lda_fixed_numtopic" => 1000,
    "linear_regression" => 1000,
    "marsaglia" => 1000,
    "pcfg" => 1000,
    "pedestrian" => 1000,

    "gmm_fixed_numclust_unrolled" => 1000,
    "hmm_unrolled" => 1000,
    "lda_fixed_numtopic_unrolled" => 1000,
    "linear_regression_unrolled" => 1000,
)
L = 100
learning_rate = 0.001
println(modelname)
Random.seed!(0)
_, avg_var = bbvi(name_to_N[modelname], L, learning_rate, model)
# _, avg_var = bbvi(100, 10, 0.001, model)
println("avg_var: ", avg_var)


