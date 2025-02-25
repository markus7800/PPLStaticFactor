# include("ppl.jl")
using Plots

mutable struct LMHCtx <: SampleContext
    trace_current::Dict{String,SampleType}
    trace_proposed::Dict{String,SampleType}
    logprob_proposed::Float64
    Q_proposed::Dict{String,Float64}
    resample_addr::String
    Q_resample_addr::Float64
    function LMHCtx(trace_current::Dict{String,SampleType}, resample_addr::String)
        return new(trace_current, Dict{String,SampleType}(), 0., Dict{String,Float64}(), resample_addr, 0.)
    end
end

function sample(ctx::LMHCtx, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
    if !isnothing(observed)
        ctx.logprob_proposed += logpdf(distribution, observed)
        return observed
    end

    if address == ctx.resample_addr
        old_value = ctx.trace_current[address]
        forward_proposer = distribution # prior

        value = rand(forward_proposer)
        backward_proposer = distribution # prior

        ctx.Q_resample_addr = logpdf(backward_proposer, old_value) - logpdf(forward_proposer, value)

    elseif haskey(ctx.trace_current, address)
        value = ctx.trace_current[address]
    else
        value = rand(distribution)
    end

    ctx.trace_proposed[address] = value
    lp = logpdf(distribution, value)
    ctx.logprob_proposed += lp
    ctx.Q_proposed[address] = lp

    return value
end


function lmh_standard(n_iter::Int, model::Function)

    # init
    ctx = LMHCtx(Dict{String,SampleType}(), "")
    retval_current = model(ctx)
    trace_current = ctx.trace_proposed
    logprob_current = ctx.logprob_proposed
    Q_current = ctx.Q_proposed

    n_accepted = 0

    retvals = []
    for _ in 1:n_iter

        # randomly pick resample address
        resample_addr = rand(keys(trace_current))
        ctx = LMHCtx(trace_current, resample_addr)

        # run model with sampler
        retval_proposed = model(ctx)
        trace_proposed = ctx.trace_proposed
        logprob_proposed = ctx.logprob_proposed
        Q_proposed = ctx.Q_proposed
        Q_resample_addr = ctx.Q_resample_addr

        # compute acceptance probability
        log_α = logprob_proposed - logprob_current + Q_resample_addr + log(length(trace_current)) - log(length(trace_proposed))
        for (addr, q) in Q_proposed
            if !haskey(Q_current, addr) # resampled
                log_α -= q
            end
        end
        for (addr, q) in Q_current
            if !haskey(Q_proposed, addr) # resampled
                log_α += q
            end
        end

        # accept or reject
        if log(rand()) < log_α
            trace_current = trace_proposed
            logprob_current = logprob_proposed
            Q_current = Q_proposed
            retval_current = retval_proposed
            n_accepted += 1
        end
        # push!(retvals, retval_current)
    end
    # println([mean(retvals .== r) for r in 0:10])

    println(n_accepted / n_iter)
end