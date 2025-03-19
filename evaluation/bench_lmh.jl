using Printf

# ARGS = ["benchmark", "lda_variable_numtopic.jl"]

include(ARGS[1] * "/generated/" * ARGS[2])
if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm", "lda_fixed_numtopic", "bayesian_network")
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


    if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm", "lda_fixed_numtopic", "bayesian_network")
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
    if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm", "lda_fixed_numtopic", "bayesian_network")
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
        f = open("evaluation/lmh_results.csv", "a")
        print(f, modelname, ",", N*n_iter, ",", acceptance_rate, ",", standard_time*10^6, ",", factored_time*10^6, ",", factored_time/standard_time)
        if isnan(finite_time)
            print(f, ",NA,NA")
        else
            print(f, ",", finite_time*10^6, ",", finite_time/standard_time)
        end
        if isnan(custom_time)
            println(f, ",NA,NA")
        else
            println(f, ",", custom_time*10^6, ",", custom_time/standard_time)
        end
        close(f)
    end

end

include("N_iters.jl")
N_iter = name_to_N[modelname]


test_correctness(10, N_iter ÷ 10, proposers)

runbench(10, N_iter ÷ 10, proposers, false) # to JIT compile everything
runbench(10, N_iter ÷ 10, proposers, true) # this will produce times without compilation
