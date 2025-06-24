# this file is auto-generated

include("../pedestrian.jl")

mutable struct State <: AbstractState
    node_id:: Int
    distance::Float64
    i::Int
    position::Float64
    start::Float64
    function State()
        return new(
            0,
            zero(Float64),
            zero(Int),
            zero(Float64),
            zero(Float64),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.distance = _s_.distance
    dst.i = _s_.i
    dst.position = _s_.position
    dst.start = _s_.start
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function pedestrian(ctx::AbstractSampleRecordStateContext, _s_::State)
    _s_.start::Float64 = sample_record_state(ctx, _s_, 22, "start", Uniform(0.0, 1.0))
    _s_.position::Float64 = _s_.start
    _s_.distance::Float64 = 0
    _s_.i::Int = 1
    while ((_s_.position > 0) && (_s_.distance < 10))
        step = sample_record_state(ctx, _s_, 61, ("step_" * string(_s_.i)), Uniform(-1.0, 1.0))
        _s_.position = (_s_.position + step)
        _s_.distance = (_s_.distance + abs(step))
        _s_.i = (_s_.i + 1)
    end
    _ = sample_record_state(ctx, _s_, 97, "final_distance", Normal(_s_.distance, 0.1), observed = 1.1)
end

function pedestrian_start_22(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.start = revisit(ctx, _s_, 22, "start", Uniform(0.0, 1.0))
    _s_.position = _s_.start
    _s_.distance = 0
    _s_.i = 1
    while ((_s_.position > 0) && (_s_.distance < 10))
        step = score(ctx, _s_, 61, ("step_" * string(_s_.i)), Uniform(-1.0, 1.0))
        _s_.position = (_s_.position + step)
        _s_.distance = (_s_.distance + abs(step))
        _s_.i = (_s_.i + 1)
    end
    score(ctx, _s_, 97, "final_distance", Normal(_s_.distance, 0.1), observed = 1.1)
end

function pedestrian_step__61(ctx::AbstractFactorRevisitContext, _s_::State)
    step = revisit(ctx, _s_, 61, ("step_" * string(_s_.i)), Uniform(-1.0, 1.0))
    _s_.position = (_s_.position + step)
    _s_.distance = (_s_.distance + abs(step))
    _s_.i = (_s_.i + 1)
    while ((_s_.position > 0) && (_s_.distance < 10))
        step = score(ctx, _s_, 61, ("step_" * string(_s_.i)), Uniform(-1.0, 1.0))
        _s_.position = (_s_.position + step)
        _s_.distance = (_s_.distance + abs(step))
        _s_.i = (_s_.i + 1)
    end
    score(ctx, _s_, 97, "final_distance", Normal(_s_.distance, 0.1), observed = 1.1)
end

function pedestrian_factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    if _s_.node_id == 22
        return pedestrian_start_22(ctx, _s_)
    end
    if _s_.node_id == 61
        return pedestrian_step__61(ctx, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return pedestrian(ctx)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return pedestrian(ctx, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return pedestrian_factor(ctx, _s_, _addr_)
end

function resume(ctx::AbstractFactorResumeContext, _s_::State, _addr_::String)
    return pedestrian_resume(ctx, _s_, _addr_)
end

