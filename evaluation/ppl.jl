

using Distributions
import Random

abstract type SampleContext end

const SampleType = Union{Real,Vector{<:Real}}

function sample(ctx::SampleContext, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
    error("Not implemented!")
end


mutable struct GenerateContext <: SampleContext
    trace::Dict{String,SampleType}
    logprob::Float64
    function GenerateContext()
        return new(Dict{String,SampleType}(), 0)
    end
end

function sample(ctx::GenerateContext, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = rand(distribution)
        ctx.trace[address] = value
    end
    ctx.logprob += logpdf(distribution, value)
    return value
end

mutable struct LogProbContext <: SampleContext
    trace::Dict{String,SampleType}
    logprob::Float64
    function LogProbContext(trace::Dict{String,SampleType})
        return new(trace, 0)
    end
end

function sample(ctx::LogProbContext, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = ctx.trace[address]
    end
    ctx.logprob += logpdf(distribution, value)
    return value
end


abstract type AbstractState end
abstract type AbstractGenerateRecordStateContext end

mutable struct GenerateRecordStateContext <: AbstractGenerateRecordStateContext
    trace::Dict{String,Tuple{SampleType,AbstractState}}
    logprob::Float64
    function GenerateRecordStateContext()
        return new(Dict{String,Tuple{SampleType,AbstractState}}(), 0.0)
    end
end

function sample_record_state(ctx::GenerateRecordStateContext, s::AbstractState, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = rand(distribution)
        state = copy(s)
        state.node_id = node_id
        ctx.trace[address] = (value, state)
    end
    ctx.logprob += logpdf(distribution, value)
    return value
end

mutable struct GenerateNoRecordStateContext <: AbstractGenerateRecordStateContext
    trace::Dict{String,SampleType}
    logprob::Float64
    function GenerateNoRecordStateContext()
        return new(Dict{String,Tuple{SampleType,AbstractState}}(), 0.0)
    end
end

function sample_record_state(ctx::GenerateNoRecordStateContext, s::AbstractState, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value = rand(distribution)
        ctx.trace[address] = value
    end
    ctx.logprob += logpdf(distribution, value)
    return value
end

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

abstract type AbstractFactorResampleContext end

mutable struct AddFactorResampleContext <: AbstractFactorResampleContext
    trace::Dict{String,Tuple{SampleType,AbstractState}}
    logprob::Float64
    function AddFactorResampleContext(trace::Dict{String,Tuple{SampleType,AbstractState}}, logprob::Float64)
        return new(trace, logprob)
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
    function SubstractFactorResampleContext(trace::Dict{String,Tuple{SampleType,AbstractState}}, logprob::Float64)
        return new(trace, logprob)
    end
end

function resample(ctx::SubstractFactorResampleContext, s::AbstractState, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    value, _ = ctx.trace[address]
    ctx.logprob -= logpdf(distribution, value)
    return value
end

function score(ctx::SubstractFactorResampleContext, s::AbstractState, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if !isnothing(observed)
        value = observed
    else
        value, _ = ctx.trace[address]
    end
    ctx.logprob -= logpdf(distribution, value)
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

mutable struct ManualResampleContext
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

function append(x::AbstractArray, el)
    x = copy(x)
    push!(x, el)
    return x
end
get_n(x::AbstractArray, i) = x[i]
get_row(x::AbstractMatrix, i) = x[i, :]
Base.zero(::Type{Vector{T}}) where T = T[]
Base.zero(::Type{Matrix{T}}) where T = Matrix{T}(undef, 0, 0)

Distributions.logpdf(d::Dirichlet{Float64,Vector{Float64}}, x::Vector{Float64}) = length(x) != length(d.alpha) ? -Inf : Distributions._logpdf(d, x)

macro model(func) func end