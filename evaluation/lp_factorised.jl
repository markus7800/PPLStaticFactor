mutable struct ResampleContext <: SampleContext
    trace::Dict{String,SampleType}
    logprob::Float64
    resample_addr::String
    function ResampleContext(trace::Dict{String,SampleType}, resample_addr::String)
        return new(trace, 0., resample_addr)
    end
end

function sample(ctx::ResampleContext, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
    if !isnothing(observed)
        value = observed
    elseif address == ctx.resample_addr
        value = rand(distribution)
    elseif haskey(ctx.trace, address)
        value = ctx.trace[address]
    else
        value = rand(distribution)
    end

    ctx.logprob += logpdf(distribution, value)
    return value
end

mutable struct AddFactorResampleContext <: AbstractFactorResampleContext
    trace::Dict{String,Tuple{SampleType,AbstractState}}
    logprob::Float64
    function AddFactorResampleContext(trace::Dict{String,Tuple{SampleType,AbstractState}})
        return new(trace, 0.)
    end
end

function resample(ctx::AddFactorResampleContext, s::AbstractState, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    value = rand(distribution)
    ctx.logprob += logpdf(distribution, value)
    return value
end

function score(ctx::AddFactorResampleContext, s::AbstractState, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        value = observed
    elseif haskey(ctx.trace, address)
        value, _ = ctx.trace[address]
    else
        value = rand(distribution)
    end
    ctx.logprob += logpdf(distribution, value)
    return value
end

function read(ctx::AddFactorResampleContext, s::AbstractState, node_id::Int, address::String; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value, _ = ctx.trace[address]
    end
    return value
end


mutable struct SubstractFactorResampleContext <: AbstractFactorResampleContext
    trace::Dict{String,Tuple{SampleType,AbstractState}}
    logprob::Float64
    function SubstractFactorResampleContext(trace::Dict{String,Tuple{SampleType,AbstractState}})
        return new(trace, 0.)
    end
end

function resample(ctx::SubstractFactorResampleContext, s::AbstractState, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    value, _ = ctx.trace[address]
    ctx.logprob += logpdf(distribution, value)
    return value
end

function score(ctx::SubstractFactorResampleContext, s::AbstractState, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value, _ = ctx.trace[address]
    end
    ctx.logprob += logpdf(distribution, value)
    return value
end

function read(ctx::SubstractFactorResampleContext, s::AbstractState, node_id::Int, address::String; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value, _ = ctx.trace[address]
    end
    return value
end

abstract type AbstractManualResampleContext end

mutable struct ManualResampleContext <: AbstractManualResampleContext
    trace::Dict{String,SampleType}
    logprob::Float64
    resample_addr::String
    function ManualResampleContext(trace::Dict{String,SampleType}, resample_addr::String)
        return new(trace, 0., resample_addr)
    end
end

function manual_resample(ctx::ManualResampleContext, address::String, distribution::Distribution; observed=nothing)
    old_value = ctx.trace[address]
    new_value = rand(distribution)
    ctx.logprob += logpdf(distribution, new_value) - logpdf(distribution, old_value)
    return new_value
end

function manual_add_logpdf(ctx::ManualResampleContext, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = ctx.trace[address]
    end
    ctx.logprob += logpdf(distribution, value)
    return value
end
function manual_sub_logpdf(ctx::ManualResampleContext, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = ctx.trace[address]
    end
    ctx.logprob -= logpdf(distribution, value)
    return value
end

function manual_read(ctx::ManualResampleContext, address::String)
    value = ctx.trace[address]
    return value
end