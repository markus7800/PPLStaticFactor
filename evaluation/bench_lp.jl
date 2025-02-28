using Printf

include(ARGS[1] * "/generated/" * ARGS[2])
if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm_fixed_seqlen", "lda_fixed_numtopic")
    include("finite/"  * ARGS[2])
end
if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
    include("custom/"  * ARGS[2])
end

function runbench(N::Int, verbose::Bool)

    state_traces = Vector{Dict{String,Tuple{SampleType,AbstractState}}}(undef,N)
    traces = Vector{Dict{String,SampleType}}(undef,N)
    lps = Vector{Float64}(undef, N)
    Random.seed!(0)
    for i in 1:N
        ctx = GenerateRecordStateContext()
        model(ctx, State())
        state_traces[i] = ctx.trace
        traces[i] = Dict{String, SampleType}(addr => value for (addr, (value,_)) in ctx.trace)
        lps[i] = ctx.logprob
    end


    addresses = Vector{String}(undef,N)
    for i in 1:N
        trace = state_traces[i]
        addresses[i] = rand(keys(trace))
    end


    Random.seed!(0)
    updated_lps_1 = Vector{Float64}(undef, N)
    res = @timed for i in 1:N
        trace = traces[i]

        addr = addresses[i]

        ctx = ResampleContext(trace, addr)
        model(ctx)
        updated_lps_1[i] = ctx.logprob
    end
    standard_time = res.time/N

    Random.seed!(0)
    updated_lps_2 = Vector{Float64}(undef, N)
    state = State()
    res = @timed for i in 1:N
        trace = state_traces[i]
        lp = lps[i]

        addr = addresses[i]

        sub_ctx = SubstractFactorResampleContext(trace)
        copy!(state, trace[addr][2])
        factor(sub_ctx, state, addr)
        add_ctx = AddFactorResampleContext(trace)
        copy!(state, trace[addr][2])
        factor(add_ctx, state, addr)
        
        updated_lps_2[i] = lp + add_ctx.logprob - sub_ctx.logprob
    end
    factored_time = res.time/N
    
    verbose && println(@sprintf("Standard time %.3f μs", standard_time*10^6))
    verbose && println(@sprintf("Factored time %.3f μs (%.2f)", factored_time*10^6, factored_time / standard_time))

    @assert (updated_lps_1 ≈ updated_lps_2)

    finite_time = NaN
    if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm_fixed_seqlen", "lda_fixed_numtopic")
        Random.seed!(0)
        updated_lps_3 = Vector{Float64}(undef, N)
        res = @timed for i in 1:N
            trace = traces[i]
            lp = lps[i]

            addr = addresses[i]

            ctx = ManualResampleContext(trace, addr)
            finite_factor(ctx)

            updated_lps_3[i] = lp + ctx.logprob
        end
        finite_time = res.time/N

        verbose && println(@sprintf("Finite time %.3f μs (%.2f)", finite_time*10^6, finite_time / standard_time))
        @assert (updated_lps_1 ≈ updated_lps_3)
    end

    custom_time = NaN
    if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
        Random.seed!(0)
        updated_lps_4 = Vector{Float64}(undef, N)
        res = @timed for i in 1:N
            trace = traces[i]
            lp = lps[i]

            addr = addresses[i]

            ctx = ManualResampleContext(trace, addr)
            custom_factor(ctx)

            updated_lps_4[i] = lp + ctx.logprob
        end
        custom_time = res.time/N

        verbose && println(@sprintf("Custom time %.3f μs (%.2f)", custom_time*10^6, custom_time / standard_time))
        @assert (updated_lps_1 ≈ updated_lps_4)
    end

    if verbose
        f = open("evaluation/results.csv", "a")
        print(f, modelname, ",", standard_time*10^6, ",", factored_time*10^6)
        if isnan(finite_time)
            print(f, ",NA")
        else
            print(f, ",", finite_time*10^6)
        end
        if isnan(custom_time)
            println(f, ",NA")
        else
            println(f, ",", custom_time*10^6)
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

runbench(N_iter, false) # to JIT compile everthing
runbench(N_iter, true) # this will produce times without compilation

