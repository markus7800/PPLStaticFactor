# this file is auto-generated

include("../marsaglia.jl")

mutable struct State <: AbstractState
    node_id:: Int
    i::Int
    s::Float64
    x::Float64
    y::Float64
    z::Float64
    function State()
        return new(
            0,
            zero(Int),
            zero(Float64),
            zero(Float64),
            zero(Float64),
            zero(Float64),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.i = _s_.i
    dst.s = _s_.s
    dst.x = _s_.x
    dst.y = _s_.y
    dst.z = _s_.z
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function marsaglia(ctx::AbstractSampleRecordStateContext, _s_::State)
    _s_.s::Float64 = Inf
    _s_.x::Float64 = 0.0
    _s_.y::Float64 = 0.0
    _s_.i::Int = 1
    while (_s_.s > 1)
        _s_.x = sample_record_state(ctx, _s_, 52, ("x_" * string(_s_.i)), Uniform(-1.0, 1.0))
        _s_.y = sample_record_state(ctx, _s_, 68, ("y_" * string(_s_.i)), Uniform(-1.0, 1.0))
        _s_.s = ((_s_.x ^ 2) + (_s_.y ^ 2))
        _s_.i = (_s_.i + 1)
    end
    _s_.z::Float64 = (_s_.x * sqrt(((-2 * log(_s_.s)) / _s_.s)))
    return _s_.z
end

function marsaglia_x__52(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.x = resample(ctx, _s_, 52, ("x_" * string(_s_.i)), Uniform(-1.0, 1.0))
    _s_.y = score(ctx, _s_, 68, ("y_" * string(_s_.i)), Uniform(-1.0, 1.0))
    _s_.s = ((_s_.x ^ 2) + (_s_.y ^ 2))
    _s_.i = (_s_.i + 1)
    while (_s_.s > 1)
        _s_.x = score(ctx, _s_, 52, ("x_" * string(_s_.i)), Uniform(-1.0, 1.0))
        _s_.y = score(ctx, _s_, 68, ("y_" * string(_s_.i)), Uniform(-1.0, 1.0))
        _s_.s = ((_s_.x ^ 2) + (_s_.y ^ 2))
        _s_.i = (_s_.i + 1)
    end
end

function marsaglia_y__68(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.y = resample(ctx, _s_, 68, ("y_" * string(_s_.i)), Uniform(-1.0, 1.0))
    _s_.s = ((_s_.x ^ 2) + (_s_.y ^ 2))
    _s_.i = (_s_.i + 1)
    while (_s_.s > 1)
        _s_.x = score(ctx, _s_, 52, ("x_" * string(_s_.i)), Uniform(-1.0, 1.0))
        _s_.y = score(ctx, _s_, 68, ("y_" * string(_s_.i)), Uniform(-1.0, 1.0))
        _s_.s = ((_s_.x ^ 2) + (_s_.y ^ 2))
        _s_.i = (_s_.i + 1)
    end
end

function marsaglia_factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    if _s_.node_id == 52
        return marsaglia_x__52(ctx, _s_)
    end
    if _s_.node_id == 68
        return marsaglia_y__68(ctx, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return marsaglia(ctx)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return marsaglia(ctx, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return marsaglia_factor(ctx, _s_, _addr_)
end
