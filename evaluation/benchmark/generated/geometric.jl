# this file is auto-generated

include("../geometric.jl")

mutable struct State <: AbstractState
    node_id:: Int
    b::Bool
    i::Int
    function State()
        return new(
            0,
            zero(Bool),
            zero(Int),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.b = _s_.b
    dst.i = _s_.i
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function geometric(ctx::AbstractSampleRecordStateContext, _s_::State)
    _s_.i::Int = -1
    _s_.b::Bool = true
    while _s_.b
        _s_.i = (_s_.i + 1)
        _s_.b = sample_record_state(ctx, _s_, 41, ("b_" * string(_s_.i)), Bernoulli(0.5))
    end
    _ = sample_record_state(ctx, _s_, 56, "x", Normal(_s_.i, 1.0), observed = 5.0)
    return _s_.i
end

function geometric_b__41(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.b = revisit(ctx, _s_, 41, ("b_" * string(_s_.i)), Bernoulli(0.5))
    while _s_.b
        _s_.i = (_s_.i + 1)
        _s_.b = score(ctx, _s_, 41, ("b_" * string(_s_.i)), Bernoulli(0.5))
    end
    score(ctx, _s_, 56, "x", Normal(_s_.i, 1.0), observed = 5.0)
end

function geometric_factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    if _s_.node_id == 41
        return geometric_b__41(ctx, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return geometric(ctx)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return geometric(ctx, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return geometric_factor(ctx, _s_, _addr_)
end

function resume(ctx::AbstractFactorResumeContext, _s_::State, _addr_::String)
    return geometric_resume(ctx, _s_, _addr_)
end

