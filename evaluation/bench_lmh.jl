using Printf

# ARGS = ["benchmark", "lda_variable_numtopic.jl"]

include(ARGS[1] * "/generated/" * ARGS[2])
if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm_fixed_seqlen", "lda_fixed_numtopic")
    include("finite/"  * ARGS[2])
end
if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
    include("custom/"  * ARGS[2])
end

include("lmh_standard.jl")
include("lmh_factorised.jl")
include("lmh_finite.jl")

function test_correctness(N::Int, n_iter::Int, proposers::Dict{String, Distribution})
    print("Test correctness: ")

    gt_result = Tuple{Float64, Vector{Dict{String, SampleType}}, Vector{Float64}}[]
    Random.seed!(0)
    for _ in 1:N
        acceptance_rate, traces, log_αs = lmh_standard(n_iter, model, proposers, Val(true))
        push!(gt_result, (acceptance_rate, traces, log_αs))
    end
    
    Random.seed!(0)
    for i in 1:N
        gt_acceptance_rate, gt_traces, gt_log_αs = gt_result[i]
        acceptance_rate = lmh_factorised(n_iter, model, proposers, Val(true), gt_traces, gt_log_αs)
        @assert acceptance_rate == gt_acceptance_rate # this is a redundant check because we check traces anyways
    end


    if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm_fixed_seqlen", "lda_fixed_numtopic")
        Random.seed!(0)
        for i in 1:N
            gt_acceptance_rate, gt_traces, gt_log_αs = gt_result[i]
            acceptance_rate = lmh_finite(n_iter, model, proposers, Val(true), Val(finite_factor), gt_traces, gt_log_αs)
            @assert acceptance_rate == gt_acceptance_rate # this is a redundant check because we check traces anyways
        end
    end

    if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
        Random.seed!(0)
        for i in 1:N
            gt_acceptance_rate, gt_traces, gt_log_αs = gt_result[i]
            acceptance_rate = lmh_finite(n_iter, model, proposers, Val(true), Val(custom_factor), gt_traces, gt_log_αs)
            @assert acceptance_rate == gt_acceptance_rate # this is a redundant check because we check traces anyways
        end
    end

    println("OK.")
end


function runbench(N::Int, n_iter::Int, proposers::Dict{String, Distribution}, verbose::Bool)

    Random.seed!(0)
    res = @timed for _ in 1:N
        lmh_standard(n_iter, model, proposers, Val(false))
    end
    standard_time = res.time/(N*n_iter)

    acceptance_rate = 0.
    Random.seed!(0)
    res = @timed for _ in 1:N
        A = lmh_factorised(n_iter, model, proposers, Val(false), Dict{String, SampleType}[], Float64[])
        acceptance_rate += A / N
    end
    factored_time = res.time/(N*n_iter)
    
    verbose && println(@sprintf("Standard time %.3f μs", standard_time*10^6))
    verbose && println(@sprintf("Factored time %.3f μs (%.2f)", factored_time*10^6, factored_time / standard_time))


    finite_time = NaN
    if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm_fixed_seqlen", "lda_fixed_numtopic")
        res = @timed for _ in 1:N
            lmh_finite(n_iter, model, proposers, Val(false), Val(finite_factor), Dict{String, SampleType}[], Float64[])
        end
        finite_time = res.time/(N*n_iter)
        verbose && println(@sprintf("Finite time %.3f μs (%.2f)", finite_time*10^6, finite_time / standard_time))
    end

    custom_time = NaN
    if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
        res = @timed for _ in 1:N
            lmh_finite(n_iter, model, proposers, Val(false), Val(custom_factor), Dict{String, SampleType}[], Float64[])
        end
        custom_time = res.time/(N*n_iter)
        verbose && println(@sprintf("Custom time %.3f μs (%.2f)", custom_time*10^6, custom_time / standard_time))
    end

    verbose && println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))
    
    if verbose
        f = open("evaluation/results.csv", "a")
        print(f, modelname, ", ", acceptance_rate, ", ", standard_time*10^6, ", ", factored_time*10^6)
        if isnan(finite_time)
            print(f, ", NA")
        else
            print(f, ", ", finite_time*10^6)
        end
        if isnan(custom_time)
            println(f, ", NA")
        else
            println(f, ", ", custom_time*10^6)
        end
        close(f)
    end

end

# chosen such that every runtest takes 1-2s
name_to_N = Dict{String,Int}(
    "aircraft" => 75_000,
    "captcha" => 1_000,
    "dirichlet_process" => 10_000,
    "geometric" => 500_000,
    "gmm_fixed_numclust" => 25_000,
    "gmm_variable_numclust" => 25_000,
    "hmm_fixed_seqlen" => 100_000,
    "hmm_variable_seqlen" => 100_000,
    "hurricane" => 1_000_000,
    "lda_fixed_numtopic" => 10_000,
    "lda_variable_numtopic" => 10_000,
    "linear_regression" => 100_000,
    "marsaglia" => 500_000,
    "pedestrian" => 100_000,
    "urn" => 100_000,

    "gmm_fixed_numclust_unrolled" => 25_000,
    "hmm_fixed_seqlen_unrolled" => 100_000,
    "lda_fixed_numtopic_unrolled" => 10_000,
    "linear_regression_unrolled" => 100_000,
)
N_iter = get(name_to_N, modelname, 10_000)



# runbench(1, 500_000, false)
# runbench(1, 500_000, true)

test_correctness(10, N_iter ÷ 10, proposers)

runbench(10, N_iter ÷ 10, proposers, false) # to JIT compile everthing
runbench(10, N_iter ÷ 10, proposers, true) # this will produce times without compilation
