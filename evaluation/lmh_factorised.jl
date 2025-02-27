
abstract type AbstractFactorResampleContext end

# executes model with respect to trace_proposed
# resamples at resample_address and samples from prior for other new addresses
mutable struct LMHForwardFactorContext <: AbstractFactorResampleContext
    trace_current::Dict{String,SampleType}
    trace_proposed::Dict{String,SampleType}
    logprob::Float64
    Q_proposed::Float64
    Q_resample_addr::Float64
    add_diff::Dict{String,State}
    update_diff::Dict{String,State}
    function LMHForwardFactorContext(trace_current::Dict{String,SampleType}, logprob::Float64)
        return new(trace_current, Dict{String,SampleType}(), logprob, 0., 0., Dict{String,State}(), Dict{String,State}())
    end
end

function resample(ctx::LMHForwardFactorContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    old_value = ctx.trace_current[address]
    forward_proposer = distribution # prior

    value = rand(forward_proposer)
    backward_proposer = distribution # prior

    ctx.Q_resample_addr = logpdf(backward_proposer, old_value) - logpdf(forward_proposer, value)
    
    ctx.logprob += logpdf(distribution, value)

    ctx.trace_proposed[address] = value

    return value
end

function score(ctx::LMHForwardFactorContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        ctx.logprob += logpdf(distribution, observed)
        return observed
    end

    if haskey(ctx.trace_current, address)
        value = ctx.trace_current[address]
        lp = logpdf(distribution, value)
        state = copy(s)
        state.node_id = node_id
        ctx.update_diff[address] = state

    else
        value = rand(distribution)
        lp = logpdf(distribution, value)
        ctx.Q_proposed += lp
        state = copy(s)
        state.node_id = node_id
        ctx.add_diff[address] = state

    end

    ctx.logprob += lp
    ctx.trace_proposed[address] = value
    return value
end

function read(ctx::LMHForwardFactorContext, s::State, node_id::Int, address::String; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = ctx.trace_current[address]
        state = copy(s)
        state.node_id = node_id
        ctx.update_diff[address] = state
    end
    return value
end


# executes model with respect to trace_current
mutable struct LMHBackwardFactorContext <: AbstractFactorResampleContext
    trace_current::Dict{String,SampleType}
    trace_proposed::Dict{String,SampleType}
    logprob::Float64
    Q_current::Float64
    sub_diff::Set{String}
    function LMHBackwardFactorContext(trace_current::Dict{String,SampleType}, logprob::Float64, trace_proposed::Dict{String,SampleType})
        return new(trace_current, trace_proposed, logprob, 0., Set{String}())
    end
end

function resample(ctx::LMHBackwardFactorContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    value = ctx.trace_current[address]
    ctx.logprob -= logpdf(distribution, value)
    return value
end

function score(ctx::LMHBackwardFactorContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        ctx.logprob -= logpdf(distribution, observed)
        return observed
    end

    value = ctx.trace_current[address]
    lp = logpdf(distribution, value)
    ctx.logprob -= lp

    if !haskey(ctx.trace_proposed, address)
        ctx.Q_current += lp
        push!(ctx.sub_diff, address)
    end

    return value
end

function read(ctx::LMHBackwardFactorContext, s::State, node_id::Int, address::String; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = ctx.trace_current[address]
    end
    return value
end


function lmh_factorised(n_iter::Int, model::Function, ::Val{DEBUG}, gt_traces::Vector{Dict{String, SampleType}}, gt_log_αs::Vector{Float64}) where DEBUG
    generate_ctx = GenerateContext()
    generate_ctx = GenerateRecordStateContext()
    model(generate_ctx, State())

    trace_current = Dict{String, SampleType}(addr => value for (addr, (value,_)) in generate_ctx.trace)
    states_current = Dict{String, State}(addr => state for (addr, (_,state)) in generate_ctx.trace)
    logprob_current = generate_ctx.logprob

    n_accepted = 0
    state = State()

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
        resample_addr = rand(sort(collect(keys(trace_current)))) # TODO: remove
        # resample_addr = rand(keys(trace_current))
        
        
        log_prob_diff = 0.

        forward_ctx = LMHForwardFactorContext(trace_current, log_prob_diff)
        copy!(state, states_current[resample_addr])
        factor(forward_ctx, state, resample_addr)

        log_prob_diff = forward_ctx.logprob
        backward_ctx = LMHBackwardFactorContext(trace_current, log_prob_diff, forward_ctx.trace_proposed)
        copy!(state, states_current[resample_addr])
        factor(backward_ctx, state, resample_addr)

        log_prob_diff = backward_ctx.logprob

        trace_proposed_length = length(trace_current) + length(forward_ctx.add_diff) - length(backward_ctx.sub_diff)
        log_α = log_prob_diff + forward_ctx.Q_resample_addr  + backward_ctx.Q_current - forward_ctx.Q_proposed + log(length(trace_current)) - log(trace_proposed_length)

        
        if DEBUG
            if abs(log_α  - gt_log_αs[i]) > 1e-9
                error("error in $i: $log_α vs $(gt_log_αs[i])")
            end
        end

        if log(rand()) < log_α
            for addr in backward_ctx.sub_diff
                delete!(trace_current, addr)
                delete!(states_current, addr)
            end
            for (addr, state) in forward_ctx.add_diff
                trace_current[addr] = forward_ctx.trace_proposed[addr]
                states_current[addr] = state
            end
            for (addr, state) in forward_ctx.update_diff
                states_current[addr] = state
            end 
            trace_current[resample_addr] = forward_ctx.trace_proposed[resample_addr]

            logprob_current = logprob_current + log_prob_diff
            n_accepted += 1
        end
    end

    return n_accepted / n_iter
end
