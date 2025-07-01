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
    res = @timed bbvi_standard(N, L, learning_rate, model)
    _, standard_avg_var = res.value
    standard_time = res.time
    println("gradient variance standard: ", standard_avg_var, " in ", standard_time, "s")

    Random.seed!(seed)
    res = @timed bbvi_factorised(N, L, learning_rate, model)
    _, factored_avg_var = res.value
    factored_time = res.time
    println("gradient variance factorised: ", factored_avg_var, " in ", factored_time,  "s (", standard_avg_var/factored_avg_var, ")")


    f = open("evaluation/vi_results.csv", "a")
    println(f, modelname, ",", N, ",", L, ",", standard_avg_var, ",", standard_time, ",", factored_avg_var, ",", factored_time, ",", standard_avg_var/factored_avg_var)

end

runbench(seed, N_iter, L, learning_rate)


