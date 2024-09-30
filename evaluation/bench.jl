
if startswith(ARGS[1], "unrolled/")
    include("unrolled/generated/" * ARGS[1][length("unrolled/"):end])
else
    include("generated/" * ARGS[1])
    if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm_fixed_seqlen", "lda_fixed_numtopic")
        include("handwritten/"  * ARGS[1])
    end
end

function bench(N::Int, verbose::Bool)
    Random.seed!(0)
    traces = Vector{Dict{String,SampleType}}(undef, N)
    res = @timed for i in 1:N
        ctx = GenerateContext()
        model(ctx)
        traces[i] = ctx.trace
    end
    verbose && println("GenerateContext: ", res.time / N)

    res = @timed for i in 1:N
        ctx = GenerateNoRecordStateContext()
        model(ctx, State())
        traces[i] = ctx.trace
    end
    verbose && println("GenerateNoRecordStateContext: ", res.time / N)

    traces = Vector{Dict{String,Tuple{SampleType,State}}}(undef, N)
    res = @timed for i in 1:N
        ctx = GenerateRecordStateContext()
        model(ctx, State())
        traces[i] = ctx.trace
    end
    verbose && println("GenerateRecordStateContext: ", res.time / N)
end
# bench(1000, false)
# bench(1000, true)
# exit()

function runtest(N::Int, verbose::Bool)

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

        ctx = SubstractFactorResampleContext(trace, lp)
        copy!(state, trace[addr][2])
        factor(ctx, state, addr)
        ctx = AddFactorResampleContext(trace, ctx.logprob)
        copy!(state, trace[addr][2])
        factor(ctx, state, addr)

        updated_lps_2[i] = isnan(ctx.logprob) ? -Inf : ctx.logprob
    end
    factored_time = res.time/N
    
    verbose && println("Standard time $(round(standard_time*10^6, sigdigits=3)) μs")
    verbose && println("Factored time $(round(factored_time*10^6, sigdigits=3)) μs ($(round(factored_time / standard_time, sigdigits=2)))")

    # mask = .!(updated_lps_1 .≈ updated_lps_2)
    # println(updated_lps_1[mask])
    # println("versus")
    # println(updated_lps_2[mask])
    @assert (updated_lps_1 ≈ updated_lps_2)

    if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm_fixed_seqlen", "lda_fixed_numtopic")
        Random.seed!(0)
        updated_lps_3 = Vector{Float64}(undef, N)
        res = @timed for i in 1:N
            trace = traces[i]
            lp = lps[i]

            addr = addresses[i]

            ctx = ManualResampleContext(trace, addr)
            manual_factor(ctx)

            updated_lps_3[i] = lp + ctx.logprob
        end
        handwritten_time = res.time/N

        verbose && println("Handwritten time $(round(handwritten_time*10^6, sigdigits=3)) μs ($(round(handwritten_time / standard_time, sigdigits=2)))")
        @assert (updated_lps_1 ≈ updated_lps_3)
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
N_iter = name_to_N[modelname]

runtest(N_iter, false)
runtest(N_iter, true)

