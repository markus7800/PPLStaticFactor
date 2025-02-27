using Printf

include(ARGS[1] * "/generated/" * ARGS[2])
if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm_fixed_seqlen", "lda_fixed_numtopic")
    include("finite/"  * ARGS[2])
end
if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
    include("custom/"  * ARGS[2])
end

include("lmh_standard.jl")
include("lmh_factorised.jl")

function test_correctness(N::Int, n_iter::Int)

    gt_result = Tuple{Float64, Vector{Dict{String, SampleType}}, Vector{Float64}}[]
    Random.seed!(0)
    for _ in 1:N
        acceptance_rate, traces, log_αs = lmh_standard(n_iter, model, Val(true))
        push!(gt_result, (acceptance_rate, traces, log_αs))
    end
    
    Random.seed!(0)
    for i in 1:N
        gt_acceptance_rate, gt_traces, gt_log_αs = gt_result[i]
        acceptance_rate = lmh_factorised(n_iter, model, Val(true), gt_traces, gt_log_αs)
        @assert acceptance_rate == gt_acceptance_rate # this is a redundant check because we check traces anyways
    end

    println("OK.")
end


function runbench(N::Int, n_iter::Int, verbose::Bool)

    Random.seed!(0)
    res = @timed for _ in 1:N
        lmh_standard(n_iter, model, Val(false))
    end
    standard_time = res.time/(N*n_iter)

    acceptance_rate = 0.
    Random.seed!(0)
    res = @timed for _ in 1:N
        A = lmh_factorised(n_iter, model, Val(false), Dict{String, SampleType}[], Float64[])
        acceptance_rate += A / N
    end
    factored_time = res.time/(N*n_iter)
    
    verbose && println(@sprintf("Standard time %.3f μs", standard_time*10^6))
    verbose && println(@sprintf("Factored time %.3f μs (%.2f)", factored_time*10^6, factored_time / standard_time))
    verbose && println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))

    # Random.seed!(0)
    # updated_lps_2 = Vector{Float64}(undef, N)
    # state = State()
    # res = @timed for i in 1:N
    #     trace = state_traces[i]
    #     lp = lps[i]

    #     addr = addresses[i]

    #     ctx = SubstractFactorResampleContext(trace, lp)
    #     copy!(state, trace[addr][2])
    #     factor(ctx, state, addr)
    #     ctx = AddFactorResampleContext(trace, ctx.logprob)
    #     copy!(state, trace[addr][2])
    #     factor(ctx, state, addr)

    #     updated_lps_2[i] = isnan(ctx.logprob) ? -Inf : ctx.logprob
    # end
    # factored_time = res.time/N
    
    # verbose && println(@sprintf("Standard time %.3f μs", standard_time*10^6))
    # verbose && println(@sprintf("Factored time %.3f μs (%.2f)", factored_time*10^6, factored_time / standard_time))

    # @assert (updated_lps_1 ≈ updated_lps_2)

    # finite_time = NaN
    # if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm_fixed_seqlen", "lda_fixed_numtopic")
    #     Random.seed!(0)
    #     updated_lps_3 = Vector{Float64}(undef, N)
    #     res = @timed for i in 1:N
    #         trace = traces[i]
    #         lp = lps[i]

    #         addr = addresses[i]

    #         ctx = ManualResampleContext(trace, addr)
    #         finite_factor(ctx)

    #         updated_lps_3[i] = lp + ctx.logprob
    #     end
    #     finite_time = res.time/N

    #     verbose && println(@sprintf("Finite time %.3f μs (%.2f)", finite_time*10^6, finite_time / standard_time))
    #     @assert (updated_lps_1 ≈ updated_lps_3)
    # end

    # custom_time = NaN
    # if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
    #     Random.seed!(0)
    #     updated_lps_4 = Vector{Float64}(undef, N)
    #     res = @timed for i in 1:N
    #         trace = traces[i]
    #         lp = lps[i]

    #         addr = addresses[i]

    #         ctx = ManualResampleContext(trace, addr)
    #         custom_factor(ctx)

    #         updated_lps_4[i] = lp + ctx.logprob
    #     end
    #     custom_time = res.time/N

    #     verbose && println(@sprintf("Custom time %.3f μs (%.2f)", custom_time*10^6, custom_time / standard_time))
    #     @assert (updated_lps_1 ≈ updated_lps_4)
    # end

    # if verbose
    #     f = open("evaluation/results.csv", "a")
    #     print(f, modelname, ", ", standard_time*10^6, ", ", factored_time*10^6)
    #     if isnan(finite_time)
    #         print(f, ", NA")
    #     else
    #         print(f, ", ", finite_time*10^6)
    #     end
    #     if isnan(custom_time)
    #         println(f, ", NA")
    #     else
    #         println(f, ", ", custom_time*10^6)
    #     end
    #     close(f)
    # end

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

test_correctness(10, N_iter ÷ 10)

runbench(10, N_iter ÷ 10, false) # to JIT compile everthing
runbench(10, N_iter ÷ 10, true) # this will produce times without compilation
