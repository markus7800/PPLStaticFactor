# this file is auto-generated

include("../hurricane.jl")

mutable struct State <: AbstractState
    node_id:: Int
    damage_0::Bool
    damage_1::Bool
    first_city_ixs::Bool
    prep_0::Bool
    prep_1::Bool
    function State()
        return new(
            0,
            zero(Bool),
            zero(Bool),
            zero(Bool),
            zero(Bool),
            zero(Bool),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.damage_0 = _s_.damage_0
    dst.damage_1 = _s_.damage_1
    dst.first_city_ixs = _s_.first_city_ixs
    dst.prep_0 = _s_.prep_0
    dst.prep_1 = _s_.prep_1
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function hurricane(ctx::AbstractSampleRecordStateContext, _s_::State)
    _s_.first_city_ixs::Bool = sample_record_state(ctx, _s_, 19, "F", Bernoulli(0.5))
    _s_.prep_0::Bool = 0
    _s_.damage_0::Bool = 0
    _s_.prep_1::Bool = 0
    _s_.damage_1::Bool = 0
    if (_s_.first_city_ixs == 0)
        _s_.prep_0 = sample_record_state(ctx, _s_, 57, "P0", Bernoulli(0.5))
        _s_.damage_0 = sample_record_state(ctx, _s_, 67, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
        _s_.prep_1 = sample_record_state(ctx, _s_, 83, "P1", Bernoulli((_s_.damage_0 == 1) ? 0.75 : 0.5))
        _s_.damage_1 = sample_record_state(ctx, _s_, 99, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
    else
        _s_.prep_1 = sample_record_state(ctx, _s_, 116, "P1", Bernoulli(0.5))
        _s_.damage_1 = sample_record_state(ctx, _s_, 126, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
        _s_.prep_0 = sample_record_state(ctx, _s_, 142, "P0", Bernoulli((_s_.damage_1 == 1) ? 0.75 : 0.5))
        _s_.damage_0 = sample_record_state(ctx, _s_, 158, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
    end
end

function hurricane_D0_158(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.damage_0 = resample(ctx, _s_, 158, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
end

function hurricane_D0_67(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.damage_0 = resample(ctx, _s_, 67, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
    _s_.prep_1 = score(ctx, _s_, 83, "P1", Bernoulli((_s_.damage_0 == 1) ? 0.75 : 0.5))
end

function hurricane_D1_126(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.damage_1 = resample(ctx, _s_, 126, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
    _s_.prep_0 = score(ctx, _s_, 142, "P0", Bernoulli((_s_.damage_1 == 1) ? 0.75 : 0.5))
end

function hurricane_D1_99(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.damage_1 = resample(ctx, _s_, 99, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
end

function hurricane_F_19(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.first_city_ixs = resample(ctx, _s_, 19, "F", Bernoulli(0.5))
    _s_.prep_0 = 0
    _s_.damage_0 = 0
    _s_.prep_1 = 0
    _s_.damage_1 = 0
    if (_s_.first_city_ixs == 0)
        _s_.prep_0 = score(ctx, _s_, 57, "P0", Bernoulli(0.5))
        _s_.damage_0 = score(ctx, _s_, 67, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
        _s_.prep_1 = score(ctx, _s_, 83, "P1", Bernoulli((_s_.damage_0 == 1) ? 0.75 : 0.5))
        _s_.damage_1 = score(ctx, _s_, 99, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
    else
        _s_.prep_1 = score(ctx, _s_, 116, "P1", Bernoulli(0.5))
        _s_.damage_1 = score(ctx, _s_, 126, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
        _s_.prep_0 = score(ctx, _s_, 142, "P0", Bernoulli((_s_.damage_1 == 1) ? 0.75 : 0.5))
        _s_.damage_0 = score(ctx, _s_, 158, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
    end
end

function hurricane_P0_142(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.prep_0 = resample(ctx, _s_, 142, "P0", Bernoulli((_s_.damage_1 == 1) ? 0.75 : 0.5))
    _s_.damage_0 = score(ctx, _s_, 158, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
end

function hurricane_P0_57(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.prep_0 = resample(ctx, _s_, 57, "P0", Bernoulli(0.5))
    _s_.damage_0 = score(ctx, _s_, 67, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
end

function hurricane_P1_116(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.prep_1 = resample(ctx, _s_, 116, "P1", Bernoulli(0.5))
    _s_.damage_1 = score(ctx, _s_, 126, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
end

function hurricane_P1_83(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.prep_1 = resample(ctx, _s_, 83, "P1", Bernoulli((_s_.damage_0 == 1) ? 0.75 : 0.5))
    _s_.damage_1 = score(ctx, _s_, 99, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
end

function hurricane_factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    if _s_.node_id == 158
        return hurricane_D0_158(ctx, _s_)
    end
    if _s_.node_id == 67
        return hurricane_D0_67(ctx, _s_)
    end
    if _s_.node_id == 126
        return hurricane_D1_126(ctx, _s_)
    end
    if _s_.node_id == 99
        return hurricane_D1_99(ctx, _s_)
    end
    if _s_.node_id == 19
        return hurricane_F_19(ctx, _s_)
    end
    if _s_.node_id == 142
        return hurricane_P0_142(ctx, _s_)
    end
    if _s_.node_id == 57
        return hurricane_P0_57(ctx, _s_)
    end
    if _s_.node_id == 116
        return hurricane_P1_116(ctx, _s_)
    end
    if _s_.node_id == 83
        return hurricane_P1_83(ctx, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return hurricane(ctx)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return hurricane(ctx, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return hurricane_factor(ctx, _s_, _addr_)
end
