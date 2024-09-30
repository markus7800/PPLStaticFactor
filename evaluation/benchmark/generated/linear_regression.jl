# this file is auto-generated

include("../linear_regression.jl")

mutable struct State <: AbstractState
    node_id:: Int
    i::Int
    intercept::Float64
    slope::Float64
    function State()
        return new(
            0,
            zero(Int),
            zero(Float64),
            zero(Float64),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.i = _s_.i
    dst.intercept = _s_.intercept
    dst.slope = _s_.slope
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function lr(ctx::AbstractGenerateRecordStateContext, xs::Vector{Float64}, ys::Vector{Float64}, _s_::State)
    _s_.slope::Float64 = sample_record_state(ctx, _s_, 29, "slope", Normal(0.0, 3.0))
    _s_.intercept::Float64 = sample_record_state(ctx, _s_, 42, "intercept", Normal(0.0, 3.0))
    _s_.i::Int = 1
    while (_s_.i <= length(xs))
        _ = sample_record_state(ctx, _s_, 68, ("y_" * string(_s_.i)), Normal(((_s_.slope * get_n(xs, _s_.i)) + _s_.intercept), 1.0), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function lr_intercept_42(ctx::AbstractFactorResampleContext, xs::Vector{Float64}, ys::Vector{Float64}, _s_::State)
    _s_.intercept = resample(ctx, _s_, 42, "intercept", Normal(0.0, 3.0))
    _s_.i = 1
    while (_s_.i <= length(xs))
        score(ctx, _s_, 68, ("y_" * string(_s_.i)), Normal(((_s_.slope * get_n(xs, _s_.i)) + _s_.intercept), 1.0), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function lr_slope_29(ctx::AbstractFactorResampleContext, xs::Vector{Float64}, ys::Vector{Float64}, _s_::State)
    _s_.slope = resample(ctx, _s_, 29, "slope", Normal(0.0, 3.0))
    _s_.intercept = read(ctx, _s_, 42, "intercept")
    _s_.i = 1
    while (_s_.i <= length(xs))
        score(ctx, _s_, 68, ("y_" * string(_s_.i)), Normal(((_s_.slope * get_n(xs, _s_.i)) + _s_.intercept), 1.0), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function lr_factor(ctx::AbstractFactorResampleContext, xs::Vector{Float64}, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 42
        return lr_intercept_42(ctx, xs, ys, _s_)
    end
    if _s_.node_id == 29
        return lr_slope_29(ctx, xs, ys, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return lr(ctx, xs, ys)
end

function model(ctx::AbstractGenerateRecordStateContext, _s_::State)
    return lr(ctx, xs, ys, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return lr_factor(ctx, xs, ys, _s_, _addr_)
end
