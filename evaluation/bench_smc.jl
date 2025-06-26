using Printf

include("ppl.jl")
include("parse_args.jl")
include("smc.jl")

function test_correctness(N::Int, n_particles::Int)
    print("Test correctness: ")
    Random.seed!(0)
    standard_logweights = []
    for i in 1:N
        # println(i)
        push!(standard_logweights, smc_standard(n_particles, true))
        # println()
    end

    Random.seed!(0)
    factorised_logweights = []
    for i in 1:N
        # println(i)
        push!(factorised_logweights, smc_factorised(n_particles, true))
        # println()
    end

    for i in 1:N
        @assert standard_logweights[i] ≈ factorised_logweights[i] (i, standard_logweights[i], factorised_logweights[i])
    end

    println("OK.")
end

function runbench(N::Int, n_particles::Int, verbose::Bool)
    Random.seed!(0)
    res = @timed for _ in 1:N
        smc_standard(n_particles, false)
    end
    standard_time = res.time/N
    Random.seed!(0)
    res = @timed for _ in 1:N
        smc_factorised(n_particles, false)
    end
    factored_time = res.time/N

    verbose && println(@sprintf("Standard time %.3f ms", standard_time*10^3))
    verbose && println(@sprintf("Factored time %.3f ms (%.2f)", factored_time*10^3, factored_time / standard_time))
    
    if verbose
        f = open("evaluation/smc_results.csv", "a")
        println(f, modelname, ",", N_DATA, ", ", n_particles, ",", standard_time*10^3, ",", factored_time*10^3, ",", factored_time/standard_time)
    end
end

n_particles = 100

test_correctness(10, n_particles)

runbench(10, n_particles, false)
runbench(10, n_particles, true)
