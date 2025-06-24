using Printf

include("ppl.jl")

include(ARGS[1] * "/generated/" * ARGS[2])
if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm", "lda_fixed_numtopic", "bayesian_network")
    include("finite/"  * ARGS[2])
end
if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
    include("custom/"  * ARGS[2])
end

include("smc.jl")



function runbench(N::Int, n_particles::Int)
    Random.seed!(0)
    particles = smc_factorised(n_particles)

    # println("gradient variance standard: ", standard_avg_var)

    # Random.seed!(seed)
    # _, factored_avg_var = bbvi_factorised(N, L, learning_rate, model)
    # println("gradient variance factorised: ", factored_avg_var, " (", standard_avg_var/factored_avg_var, ")")


    # f = open("evaluation/vi_results.csv", "a")
    # println(f, modelname, ",", N, ",", L, ",", standard_avg_var, ",", factored_avg_var, ",", standard_avg_var/factored_avg_var)

end

runbench(10, 1000)


