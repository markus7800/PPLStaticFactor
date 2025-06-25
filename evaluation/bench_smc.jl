using Printf

include("ppl.jl")
include("parse_args.jl")
include("smc.jl")

function test_correctness(N::Int, n_particles::Int)
    print("Test correctness: ")
    Random.seed!(0)
    standard_logweights = []
    for _ in 1:N
        push!(standard_logweights, smc_standard(n_particles))
    end

    Random.seed!(0)
    factorised_logweights = []
    for _ in 1:N
        push!(factorised_logweights, smc_factorised(n_particles))
    end

    for i in 1:N
        @assert standard_logweights[i] ≈ factorised_logweights[i]
    end

    println("OK.")
end

function runbench(N::Int, n_particles::Int, verbose::Bool)
    Random.seed!(0)
    res = @timed for _ in 1:N
        smc_standard(n_particles)
    end
    standard_time = res.time/N
    Random.seed!(0)
    res = @timed for _ in 1:N
        smc_factorised(n_particles)
    end
    factored_time = res.time/N

    verbose && println(@sprintf("Standard time %.3f μs", standard_time*10^6))
    verbose && println(@sprintf("Factored time %.3f μs (%.2f)", factored_time*10^6, factored_time / standard_time))
    
end

test_correctness(10, 100)

runbench(10, 100, false)
runbench(10, 100, true)


# dirichlet_process.jl
# Test correctness: OK.
# Standard time 414114.879 μs
# Factored time 223073.096 μs (0.54)

# gmm_fixed_numclust.jl
# Test correctness: OK.
# Standard time 451342.121 μs
# Factored time 373635.688 μs (0.83)

# gmm_variable_numclust.jl
# Test correctness: OK.
# Standard time 471397.696 μs
# Factored time 370280.692 μs (0.79)

# hmm.jl
# Test correctness: OK.
# Standard time 96915.671 μs
# Factored time 84435.796 μs (0.87)

# lda_fixed_numtopic.jl
# Test correctness: ERROR: LoadError: AssertionError: standard_logweights[i] ≈ factorised_logweights[i]
# Stacktrace:
#  [1] test_correctness(N::Int64, n_particles::Int64)
#    @ Main ~/Documents/PPLStaticFactor/evaluation/bench_smc.jl:22
#  [2] top-level scope
#    @ ~/Documents/PPLStaticFactor/evaluation/bench_smc.jl:45
# in expression starting at /Users/markus/Documents/PPLStaticFactor/evaluation/bench_smc.jl:45

# lda_variable_numtopic.jl
# Test correctness: OK.
# Standard time 3494042.204 μs
# Factored time 2577801.150 μs (0.74)