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
    
end

test_correctness(10, 10)

runbench(10, 10, false)
runbench(10, 10, true)


# dirichlet_process.jl
# Test correctness: OK.
# Standard time 37.834 ms
# Factored time 20.712 ms (0.55)

# gmm_fixed_numclust.jl
# Test correctness: OK.
# Standard time 45.978 ms
# Factored time 36.817 ms (0.80)

# gmm_variable_numclust.jl
# Test correctness: OK.
# Standard time 44.110 ms
# Factored time 36.287 ms (0.82)

# hmm.jl
# Test correctness: OK.
# Standard time 10.139 ms
# Factored time 8.386 ms (0.83)

# lda_fixed_numtopic.jl
# Test correctness: OK.
# Standard time 315.597 ms
# Factored time 243.587 ms (0.77)

# lda_variable_numtopic.jl
# Test correctness: OK.
# Standard time 345.147 ms
# Factored time 262.009 ms (0.76)