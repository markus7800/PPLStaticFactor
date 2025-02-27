# include("ppl.jl")

LMH_STANDARD_DEBUG = false

mutable struct LMHCtx <: AbstractSampleRecordStateContext
    trace_current::Dict{String,SampleType}
    trace_proposed::Dict{String,SampleType}
    state_proposed::Dict{String, State}
    logprob_proposed::Float64
    Q_proposed::Dict{String,Float64}
    resample_addr::String
    Q_resample_addr::Float64
    function LMHCtx(trace_current::Dict{String,SampleType}, resample_addr::String)
        return new(trace_current, Dict{String,SampleType}(), Dict{String, State}(), 0., Dict{String,Float64}(), resample_addr, 0.)
    end
end

# function sample(ctx::LMHCtx, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
function sample_record_state(ctx::LMHCtx, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)

    if !isnothing(observed)
        ctx.logprob_proposed += logpdf(distribution, observed)
        LMH_STANDARD_DEBUG && println("  +Score: ", address, " ", logpdf(distribution, observed))
        return observed
    end

    if address == ctx.resample_addr
        old_value = ctx.trace_current[address]
        forward_proposer = distribution # prior

        value = rand(forward_proposer)
        backward_proposer = distribution # prior

        ctx.Q_resample_addr = logpdf(backward_proposer, old_value) - logpdf(forward_proposer, value)

        LMH_STANDARD_DEBUG && println("  Resample: ", address, " ", old_value, " => ", value)
    elseif haskey(ctx.trace_current, address)
        value = ctx.trace_current[address]
        LMH_STANDARD_DEBUG && println("  Reuse: ", address, " ", value)
    else
        value = rand(distribution)
        LMH_STANDARD_DEBUG && println("  Sample from prior: ", address, " ", value)
    end

    ctx.trace_proposed[address] = value
    lp = logpdf(distribution, value)
    ctx.logprob_proposed += lp
    ctx.Q_proposed[address] = lp

    s.node_id = node_id
    ctx.state_proposed[address] = copy(s)
    return value
end


function lmh_standard(n_iter::Int, model::Function)

    # init
    ctx = LMHCtx(Dict{String,SampleType}(), "")
    retval_current = model(ctx, State())
    trace_current = ctx.trace_proposed
    state_current = ctx.state_proposed
    logprob_current = ctx.logprob_proposed
    Q_current = ctx.Q_proposed

    n_accepted = 0
    log_αs = Vector{Float64}(undef, n_iter)
    traces = Dict{String, SampleType}[]
    states = Dict{String, State}[]

    global LMH_STANDARD_DEBUG = false
    for i in 1:n_iter
        # LMH_STANDARD_DEBUG = i == 10
        LMH_STANDARD_DEBUG && println("$i. ", trace_current)
        push!(traces, trace_current)
        push!(states, state_current)

        # randomly pick resample address
        resample_addr = rand(sort(collect(keys(trace_current)))) # TODO: remove
        # resample_addr = rand(keys(trace_current))
        LMH_STANDARD_DEBUG && println("resample_addr=", resample_addr)
        ctx = LMHCtx(trace_current, resample_addr)

        # run model with sampler
        retval_proposed = model(ctx, State())
        trace_proposed = ctx.trace_proposed
        state_proposed = ctx.state_proposed
        logprob_proposed = ctx.logprob_proposed
        Q_proposed = ctx.Q_proposed
        Q_resample_addr = ctx.Q_resample_addr

        # compute acceptance probability
        log_α = logprob_proposed - logprob_current + Q_resample_addr + log(length(trace_current)) - log(length(trace_proposed))

        Q1 = 0.
        for (addr, q) in Q_proposed
            if !haskey(Q_current, addr) # resampled
                LMH_STANDARD_DEBUG && println("  Add Q_proposed -> Q_current ", addr)
                Q1 += q
            end
        end
        log_α -= Q1

        Q2 = 0.
        for (addr, q) in Q_current
            if !haskey(Q_proposed, addr) # resampled
                LMH_STANDARD_DEBUG && println("  Sub Q_current -> Q_proposed ", addr)
                Q2 += q
            end
        end
        log_α += Q2

        if LMH_STANDARD_DEBUG
            println("  log_prob_diff=", logprob_proposed - logprob_current)
            println("  len_diff=", log(length(trace_current)) - log(length(trace_proposed)))
            println("  Q_resample_addr=", Q_resample_addr)
            println("  Q1=", Q1)
            println("  Q2=", Q2)
            println("  log_α=", log_α)
        end

        log_αs[i] = log_α

        # accept or reject
        if log(rand()) < log_α
            trace_current = trace_proposed
            state_current = state_proposed
            logprob_current = logprob_proposed
            Q_current = Q_proposed
            retval_current = retval_proposed
            n_accepted += 1
            LMH_STANDARD_DEBUG && println(" accept")
            # println(i, " accept ", log_α)
        else
            LMH_STANDARD_DEBUG && println(" reject")
            # println(i, " reject ", log_α)
        end
        # push!(retvals, retval_current)
    end
    # println([mean(retvals .== r) for r in 0:10])

    println(n_accepted / n_iter)
    return traces, states, log_αs
end