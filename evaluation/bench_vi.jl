using Printf

include("ppl.jl")
include("parse_args.jl")
const seed = parse(Int, ARGS[3])
include("vi.jl")



N_iter = 1000
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

runbench(seed, N_iter, L, learning_rate)


