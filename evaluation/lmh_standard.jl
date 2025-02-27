# include("ppl.jl")

mutable struct LMHCtx <: AbstractSampleRecordStateContext
    trace_current::Dict{String,SampleType}
    trace_proposed::Dict{String,SampleType}
    logprob_proposed::Float64
    Q_proposed::Dict{String,Float64}
    resample_addr::String
    Q_resample_addr::Float64
    proposers::Dict{String, Distribution}
    function LMHCtx(trace_current::Dict{String,SampleType}, resample_addr::String, proposers::Dict{String, Distribution})
        return new(trace_current, Dict{String,SampleType}(), 0., Dict{String,Float64}(), resample_addr, 0., proposers)
    end
end

# function sample(ctx::LMHCtx, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
function sample_record_state(ctx::LMHCtx, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)

    if !isnothing(observed)
        ctx.logprob_proposed += logpdf(distribution, observed)
        return observed
    end

    if address == ctx.resample_addr
        proposer = get(ctx.proposers, address, distribution)
        old_value = ctx.trace_current[address]

        value = rand(proposer)

        ctx.Q_resample_addr = logpdf(proposer, old_value) - logpdf(proposer, value)

    elseif haskey(ctx.trace_current, address)
        value = ctx.trace_current[address]

    else
        value = rand(distribution)
    end

    ctx.trace_proposed[address] = value
    lp = logpdf(distribution, value)
    ctx.logprob_proposed += lp
    ctx.Q_proposed[address] = lp

    s.node_id = node_id
    return value
end


function lmh_standard(n_iter::Int, model::Function, proposers::Dict{String, Distribution}, ::Val{DEBUG}) where DEBUG

    # init
    ctx = LMHCtx(Dict{String,SampleType}(), "", proposers)
    retval_current = model(ctx, State())
    trace_current = ctx.trace_proposed
    logprob_current = ctx.logprob_proposed
    Q_current = ctx.Q_proposed

    n_accepted = 0
    if DEBUG
        log_αs = Vector{Float64}(undef, n_iter)
        traces = Dict{String, SampleType}[]
    end

    for i in 1:n_iter
        if DEBUG
            push!(traces, trace_current)
        end

        # randomly pick resample address
        if DEBUG
            resample_addr = rand(sort(collect(keys(trace_current))))
        else
            resample_addr = rand(keys(trace_current))
        end

        ctx = LMHCtx(trace_current, resample_addr, proposers)

        # run model with sampler
        retval_proposed = model(ctx, State())
        trace_proposed = ctx.trace_proposed
        logprob_proposed = ctx.logprob_proposed
        Q_proposed = ctx.Q_proposed
        Q_resample_addr = ctx.Q_resample_addr

        # compute acceptance probability
        log_α = logprob_proposed - logprob_current + Q_resample_addr + log(length(trace_current)) - log(length(trace_proposed))

        Q1 = 0.
        for (addr, q) in Q_proposed
            if !haskey(Q_current, addr) # resampled
                Q1 += q
            end
        end
        log_α -= Q1

        Q2 = 0.
        for (addr, q) in Q_current
            if !haskey(Q_proposed, addr) # resampled
                Q2 += q
            end
        end
        log_α += Q2

        if DEBUG
            log_αs[i] = log_α
        end

        # accept or reject
        if log(rand()) < log_α
            trace_current = trace_proposed
            logprob_current = logprob_proposed
            Q_current = Q_proposed
            retval_current = retval_proposed
            n_accepted += 1
        end

    end

    acceptance_rate = n_accepted / n_iter

    if DEBUG
        return acceptance_rate, traces, log_αs
    else
        return acceptance_rate
    end
end