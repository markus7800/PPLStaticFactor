
abstract type AbstractFactorResampleContext end

# executes model with respect to trace_proposed
# resamples at resample_address and samples from prior for other new addresses
mutable struct LMHForwardFactorContext <: AbstractFactorResampleContext
    trace_current::Dict{String,SampleType}
    trace_proposed::Dict{String,SampleType}
    logprob::Float64
    Q_proposed::Float64
    Q_resample_addr::Float64
    add_diff::Set{String}
    proposers::Dict{String, Distribution}
    function LMHForwardFactorContext(trace_current::Dict{String,SampleType}, proposers::Dict{String, Distribution})
        return new(trace_current, Dict{String,SampleType}(), 0., 0., 0., Set{String}(), proposers)
    end
end

function resample(ctx::LMHForwardFactorContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    proposer = get(ctx.proposers, address, distribution)
    old_value = ctx.trace_current[address]

    value = rand(proposer)
    ctx.Q_resample_addr = logpdf(proposer, old_value) - logpdf(proposer, value)
    
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

    else
        value = rand(distribution)
        lp = logpdf(distribution, value)
        ctx.Q_proposed += lp
        push!(ctx.add_diff, address)
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
    function LMHBackwardFactorContext(trace_current::Dict{String,SampleType}, trace_proposed::Dict{String,SampleType})
        return new(trace_current, trace_proposed, 0., 0., Set{String}())
    end
end

function resample(ctx::LMHBackwardFactorContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    value = ctx.trace_current[address]
    ctx.logprob += logpdf(distribution, value)
    return value
end

function score(ctx::LMHBackwardFactorContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        ctx.logprob += logpdf(distribution, observed)
        return observed
    end

    value = ctx.trace_current[address]
    lp = logpdf(distribution, value)
    ctx.logprob += lp

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

struct LMHUpdateStatesContext <: AbstractFactorResampleContext
    trace::Dict{String,SampleType}
    states::Dict{String,State}
    add_diff::Set{String}
end


function resample(ctx::LMHUpdateStatesContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    value = ctx.trace[address]
    return value
end

function score(ctx::LMHUpdateStatesContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        return observed
    end
    if address in ctx.add_diff
        # add state
        state = copy(s)
        state.node_id = node_id
        ctx.states[address] = state
    else
        # update state
        copy!(ctx.states[address], s)
        ctx.states[address].node_id = node_id
    end
    value = ctx.trace[address]
    return value
end

function read(ctx::LMHUpdateStatesContext, s::State, node_id::Int, address::String; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        # update state
        copy!(ctx.states[address], s)
        ctx.states[address].node_id = node_id
        value = ctx.trace[address]
    end
    return value
end



function lmh_factorised(n_iter::Int, model::Function, proposers::Dict{String, Distribution}, ::Val{DEBUG}, gt_traces::Vector{Dict{String, SampleType}}, gt_log_αs::Vector{Float64}) where DEBUG
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
        if DEBUG
            resample_addr = rand(sort(collect(keys(trace_current))))
        else
            resample_addr = rand(keys(trace_current))
        end
        
        forward_ctx = LMHForwardFactorContext(trace_current, proposers)
        copy!(state, states_current[resample_addr])
        factor(forward_ctx, state, resample_addr)

        backward_ctx = LMHBackwardFactorContext(trace_current, forward_ctx.trace_proposed)
        copy!(state, states_current[resample_addr])
        factor(backward_ctx, state, resample_addr)

        log_prob_diff = forward_ctx.logprob - backward_ctx.logprob

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
            for addr in forward_ctx.add_diff
                trace_current[addr] = forward_ctx.trace_proposed[addr]
            end
            trace_current[resample_addr] = forward_ctx.trace_proposed[resample_addr]

            update_ctx = LMHUpdateStatesContext(trace_current, states_current, forward_ctx.add_diff)
            copy!(state, states_current[resample_addr])
            factor(update_ctx, state, resample_addr)


            logprob_current = logprob_current + log_prob_diff
            n_accepted += 1
        end
    end

    return n_accepted / n_iter
end
