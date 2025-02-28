# this file is auto-generated

include("../linear_regression.jl")

mutable struct State <: AbstractState
    node_id:: Int
    intercept::Float64
    slope::Float64
    function State()
        return new(
            0,
            zero(Float64),
            zero(Float64),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.intercept = _s_.intercept
    dst.slope = _s_.slope
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function lr(ctx::AbstractSampleRecordStateContext, xs::Vector{Float64}, ys::Vector{Float64}, _s_::State)
    _s_.slope::Float64 = sample_record_state(ctx, _s_, 52, "slope", Normal(0.0, 3.0))
    _s_.intercept::Float64 = sample_record_state(ctx, _s_, 65, "intercept", Normal(0.0, 3.0))
    _ = sample_record_state(ctx, _s_, 79, ("y_" * string(1)), Normal(((_s_.slope * get_n(xs, 1)) + _s_.intercept), 1.0), observed = get_n(ys, 1))
    _ = sample_record_state(ctx, _s_, 110, ("y_" * string(2)), Normal(((_s_.slope * get_n(xs, 2)) + _s_.intercept), 1.0), observed = get_n(ys, 2))
    _ = sample_record_state(ctx, _s_, 141, ("y_" * string(3)), Normal(((_s_.slope * get_n(xs, 3)) + _s_.intercept), 1.0), observed = get_n(ys, 3))
    _ = sample_record_state(ctx, _s_, 172, ("y_" * string(4)), Normal(((_s_.slope * get_n(xs, 4)) + _s_.intercept), 1.0), observed = get_n(ys, 4))
    _ = sample_record_state(ctx, _s_, 203, ("y_" * string(5)), Normal(((_s_.slope * get_n(xs, 5)) + _s_.intercept), 1.0), observed = get_n(ys, 5))
    _ = sample_record_state(ctx, _s_, 234, ("y_" * string(6)), Normal(((_s_.slope * get_n(xs, 6)) + _s_.intercept), 1.0), observed = get_n(ys, 6))
    _ = sample_record_state(ctx, _s_, 265, ("y_" * string(7)), Normal(((_s_.slope * get_n(xs, 7)) + _s_.intercept), 1.0), observed = get_n(ys, 7))
    _ = sample_record_state(ctx, _s_, 296, ("y_" * string(8)), Normal(((_s_.slope * get_n(xs, 8)) + _s_.intercept), 1.0), observed = get_n(ys, 8))
    _ = sample_record_state(ctx, _s_, 327, ("y_" * string(9)), Normal(((_s_.slope * get_n(xs, 9)) + _s_.intercept), 1.0), observed = get_n(ys, 9))
    _ = sample_record_state(ctx, _s_, 358, ("y_" * string(10)), Normal(((_s_.slope * get_n(xs, 10)) + _s_.intercept), 1.0), observed = get_n(ys, 10))

end

function lr_intercept_65(ctx::AbstractFactorResampleContext, xs::Vector{Float64}, ys::Vector{Float64}, _s_::State)
    _s_.intercept = resample(ctx, _s_, 65, "intercept", Normal(0.0, 3.0))
    score(ctx, _s_, 79, ("y_" * string(1)), Normal(((_s_.slope * get_n(xs, 1)) + _s_.intercept), 1.0), observed = get_n(ys, 1))
    score(ctx, _s_, 110, ("y_" * string(2)), Normal(((_s_.slope * get_n(xs, 2)) + _s_.intercept), 1.0), observed = get_n(ys, 2))
    score(ctx, _s_, 141, ("y_" * string(3)), Normal(((_s_.slope * get_n(xs, 3)) + _s_.intercept), 1.0), observed = get_n(ys, 3))
    score(ctx, _s_, 172, ("y_" * string(4)), Normal(((_s_.slope * get_n(xs, 4)) + _s_.intercept), 1.0), observed = get_n(ys, 4))
    score(ctx, _s_, 203, ("y_" * string(5)), Normal(((_s_.slope * get_n(xs, 5)) + _s_.intercept), 1.0), observed = get_n(ys, 5))
    score(ctx, _s_, 234, ("y_" * string(6)), Normal(((_s_.slope * get_n(xs, 6)) + _s_.intercept), 1.0), observed = get_n(ys, 6))
    score(ctx, _s_, 265, ("y_" * string(7)), Normal(((_s_.slope * get_n(xs, 7)) + _s_.intercept), 1.0), observed = get_n(ys, 7))
    score(ctx, _s_, 296, ("y_" * string(8)), Normal(((_s_.slope * get_n(xs, 8)) + _s_.intercept), 1.0), observed = get_n(ys, 8))
    score(ctx, _s_, 327, ("y_" * string(9)), Normal(((_s_.slope * get_n(xs, 9)) + _s_.intercept), 1.0), observed = get_n(ys, 9))
    score(ctx, _s_, 358, ("y_" * string(10)), Normal(((_s_.slope * get_n(xs, 10)) + _s_.intercept), 1.0), observed = get_n(ys, 10))
end

function lr_slope_52(ctx::AbstractFactorResampleContext, xs::Vector{Float64}, ys::Vector{Float64}, _s_::State)
    _s_.slope = resample(ctx, _s_, 52, "slope", Normal(0.0, 3.0))
    _s_.intercept = read(ctx, _s_, 65, "intercept")
    score(ctx, _s_, 79, ("y_" * string(1)), Normal(((_s_.slope * get_n(xs, 1)) + _s_.intercept), 1.0), observed = get_n(ys, 1))
    score(ctx, _s_, 110, ("y_" * string(2)), Normal(((_s_.slope * get_n(xs, 2)) + _s_.intercept), 1.0), observed = get_n(ys, 2))
    score(ctx, _s_, 141, ("y_" * string(3)), Normal(((_s_.slope * get_n(xs, 3)) + _s_.intercept), 1.0), observed = get_n(ys, 3))
    score(ctx, _s_, 172, ("y_" * string(4)), Normal(((_s_.slope * get_n(xs, 4)) + _s_.intercept), 1.0), observed = get_n(ys, 4))
    score(ctx, _s_, 203, ("y_" * string(5)), Normal(((_s_.slope * get_n(xs, 5)) + _s_.intercept), 1.0), observed = get_n(ys, 5))
    score(ctx, _s_, 234, ("y_" * string(6)), Normal(((_s_.slope * get_n(xs, 6)) + _s_.intercept), 1.0), observed = get_n(ys, 6))
    score(ctx, _s_, 265, ("y_" * string(7)), Normal(((_s_.slope * get_n(xs, 7)) + _s_.intercept), 1.0), observed = get_n(ys, 7))
    score(ctx, _s_, 296, ("y_" * string(8)), Normal(((_s_.slope * get_n(xs, 8)) + _s_.intercept), 1.0), observed = get_n(ys, 8))
    score(ctx, _s_, 327, ("y_" * string(9)), Normal(((_s_.slope * get_n(xs, 9)) + _s_.intercept), 1.0), observed = get_n(ys, 9))
    score(ctx, _s_, 358, ("y_" * string(10)), Normal(((_s_.slope * get_n(xs, 10)) + _s_.intercept), 1.0), observed = get_n(ys, 10))
end

function lr_factor(ctx::AbstractFactorResampleContext, xs::Vector{Float64}, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 65
        return lr_intercept_65(ctx, xs, ys, _s_)
    end
    if _s_.node_id == 52
        return lr_slope_52(ctx, xs, ys, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return lr(ctx, xs, ys)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return lr(ctx, xs, ys, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return lr_factor(ctx, xs, ys, _s_, _addr_)
end
