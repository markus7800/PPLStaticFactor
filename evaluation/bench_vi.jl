using Printf

include("ppl.jl")
include("parse_args.jl")
seed = parse(Int, ARGS[3])
include("vi.jl")


name_to_N = Dict{String,Int}(
    "aircraft" => 1000,
    "bayesian_network" => 1000,
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

function runbench(seed::Int, N::Int, L::Int, learning_rate::Float64)
    println("seed = $seed")
    Random.seed!(seed)
    _, standard_avg_var = bbvi_standard(N, L, learning_rate, model)
    println("gradient variance standard: ", standard_avg_var)

    Random.seed!(seed)
    _, factored_avg_var = bbvi_factorised(N, L, learning_rate, model)
    println("gradient variance factorised: ", factored_avg_var, " (", standard_avg_var/factored_avg_var, ")")


    f = open("evaluation/vi_results.csv", "a")
    println(f, modelname, ",", N, ",", L, ",", standard_avg_var, ",", factored_avg_var, ",", standard_avg_var/factored_avg_var)

end

runbench(seed, name_to_N[modelname], L, learning_rate)


