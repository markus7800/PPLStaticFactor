

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
abstract type AbstractSampleRecordStateContext end
function sample_record_state(ctx::AbstractSampleRecordStateContext, s::AbstractState, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    error("Not implemented!")
end

mutable struct GenerateRecordStateContext <: AbstractSampleRecordStateContext
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

abstract type AbstractFactorRevisitContext end
abstract type AbstractManualRevisitContext end
abstract type AbstractManualResampleContext <: AbstractManualRevisitContext end

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