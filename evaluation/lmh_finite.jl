mutable struct LMHManualContext <: AbstractManualResampleContext
    trace::Dict{String,SampleType}
    logprob_diff::Float64
    resample_addr::String
    Q_resample_addr::Float64
    proposed_value::SampleType
    proposers::Dict{String, Distribution}
    function LMHManualContext(trace::Dict{String,SampleType}, resample_addr::String, proposers::Dict{String, Distribution})
        return new(trace, 0., resample_addr, 0., 0., proposers)
    end
end

function manual_visit(ctx::LMHManualContext, address::String, distribution::Distribution; observed=nothing)
    proposer = get(ctx.proposers, address, distribution)
    old_value = ctx.trace[address]
    new_value = rand(proposer)
    ctx.Q_resample_addr += logpdf(proposer, old_value) - logpdf(proposer, new_value)
    ctx.logprob_diff += logpdf(distribution, new_value) - logpdf(distribution, old_value)
    ctx.proposed_value = new_value
    return new_value
end

function manual_add_logpdf(ctx::LMHManualContext, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = ctx.trace[address]
    end
    ctx.logprob_diff += logpdf(distribution, value)
    return value
end
function manual_sub_logpdf(ctx::LMHManualContext, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = ctx.trace[address]
    end
    ctx.logprob_diff -= logpdf(distribution, value)
    return value
end

function manual_read(ctx::LMHManualContext, address::String)
    value = ctx.trace[address]
    return value
end



function lmh_finite(n_iter::Int, model::Function, proposers::Dict{String, Distribution}, ::Val{DEBUG}, ::Val{factor_fn}, gt_traces::Vector{Dict{String, SampleType}}, gt_log_αs::Vector{Float64}) where {DEBUG, factor_fn}

    # init
    generate_ctx = GenerateContext()
    model(generate_ctx)
    trace_current = generate_ctx.trace
    logprob_current = generate_ctx.logprob
    n_accepted = 0

    for i in 1:n_iter

        if DEBUG
            for (a, v) in trace_current
                if v isa Vector
                    @assert maximum(abs, v .- gt_traces[i][a]) < 1e-9
                else
                    @assert abs(v - gt_traces[i][a]) < 1e-9
                end
            end
        end

        # randomly pick resample address
        if DEBUG
            resample_addr = rand(sort(collect(keys(trace_current))))
        else
            resample_addr = rand(keys(trace_current))
        end

        ctx = LMHManualContext(trace_current, resample_addr, proposers)

        # run model with sampler
        factor_fn(ctx)
        logprob_diff = ctx.logprob_diff
        Q_resample_addr = ctx.Q_resample_addr

        # compute acceptance probability
        log_α = logprob_diff + Q_resample_addr
        
        if DEBUG
            if abs(log_α  - gt_log_αs[i]) > 1e-9
                error("error in $i: $log_α vs $(gt_log_αs[i])")
            end
        end

        # accept or reject
        if log(rand()) < log_α
            trace_current = copy(trace_current) # implemented as if we would store all traces
            trace_current[resample_addr] = ctx.proposed_value
            logprob_current = logprob_current + logprob_diff
            n_accepted += 1
        end

    end

    acceptance_rate = n_accepted / n_iter

    return acceptance_rate
end