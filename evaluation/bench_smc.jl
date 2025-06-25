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
        println(f, modelname, ",", n_particles, ",", standard_time*10^6, ",", factored_time*10^6, ",", factored_time/standard_time)
    end
end

n_particles = 100

test_correctness(10, n_particles)

runbench(10, n_particles, false)
runbench(10, n_particles, true)

# 10 particles
# dirichlet_process.jl
# Test correctness: OK.
# Standard time 23.000 ms
# Factored time 2.134 ms (0.09)

# gmm_fixed_numclust.jl
# Test correctness: OK.
# Standard time 18.092 ms
# Factored time 3.189 ms (0.18)

# gmm_variable_numclust.jl
# Test correctness: OK.
# Standard time 16.033 ms
# Factored time 3.053 ms (0.19)

# hmm.jl
# Test correctness: OK.
# Standard time 3.345 ms
# Factored time 0.742 ms (0.22)

# lda_fixed_numtopic.jl
# Test correctness: OK.
# Standard time 134.384 ms
# Factored time 40.126 ms (0.30)

# lda_variable_numtopic.jl
# Test correctness: OK.
# Standard time 142.840 ms
# Factored time 41.647 ms (0.29)