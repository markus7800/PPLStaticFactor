using Printf

include("ppl.jl")
include("parse_args.jl")
include("smc.jl")

function runbench(N::Int, n_particles::Int)
    Random.seed!(0)
    factorised_logweights = smc_factorised(n_particles)

    Random.seed!(0)
    standard_logweights = smc_standard(n_particles)

    @assert factorised_logweights ≈ standard_logweights (factorised_logweights[1:10], standard_logweights[1:10])

    # println("gradient variance standard: ", standard_avg_var)

    # Random.seed!(seed)
    # _, factored_avg_var = bbvi_factorised(N, L, learning_rate, model)
    # println("gradient variance factorised: ", factored_avg_var, " (", standard_avg_var/factored_avg_var, ")")


    # f = open("evaluation/vi_results.csv", "a")
    # println(f, modelname, ",", N, ",", L, ",", standard_avg_var, ",", factored_avg_var, ",", standard_avg_var/factored_avg_var)

end

runbench(10, 10)


