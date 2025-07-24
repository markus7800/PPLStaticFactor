using Printf

include("ppl.jl")
include("parse_args.jl")
include("N_iters.jl")
include("smc.jl")

const RESAMPLING = true

function test_correctness(N::Int, n_particles::Int)
    print("Test correctness: ")
    Random.seed!(0)
    standard_logweights = []
    for _ in 1:N
        push!(standard_logweights, smc_standard(n_particles, RESAMPLING, true))
    end

    Random.seed!(0)
    factorised_logweights = []
    for _ in 1:N
        push!(factorised_logweights, smc_factorised(n_particles, RESAMPLING, true))
    end

    for i in 1:N
        @assert standard_logweights[i] ≈ factorised_logweights[i] (i, standard_logweights[i], factorised_logweights[i])
    end

    println("OK.")
end

function runbench(N::Int, n_particles::Int, verbose::Bool)
    if isnothing(model_t)
        standard_time = 0.
    else
        Random.seed!(0)
        res = @timed for _ in 1:N
            smc_standard(n_particles, RESAMPLING, false)
        end
        standard_time = res.time/N
    end

    Random.seed!(0)
    res = @timed for _ in 1:N
        smc_factorised(n_particles, RESAMPLING, false)
    end
    factored_time = res.time/N

    verbose && println(@sprintf("Standard time %.3f ms", standard_time*10^3))
    verbose && println(@sprintf("Factored time %.3f ms (%.2f)", factored_time*10^3, factored_time / standard_time))
    
    if verbose
        if MODEL_DIRECTORY == "models"
            f = open("evaluation/models/smc_results.csv", "a")
        else
            f = open("evaluation/smc_results.csv", "a")
        end
        println(f, modelname, ",", N_DATA, ", ", n_particles, ",", standard_time*10^3, ",", factored_time*10^3, ",", factored_time/standard_time)
    end
end

n_particles = 100

if !isnothing(model_t)
    test_correctness(N_seeds, n_particles)
else
    @warn "Data annealed model not implemented for $modelname. Only running smc_factorised."
end
runbench(N_seeds, n_particles, false)
runbench(N_seeds, n_particles, true)
