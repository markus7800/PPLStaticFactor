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
    _s_.first_city_ixs::Bool = sample_record_state(ctx, _s_, 22, "F", Bernoulli(0.5))
    _s_.prep_0::Bool = 0
    _s_.damage_0::Bool = 0
    _s_.prep_1::Bool = 0
    _s_.damage_1::Bool = 0
    if (_s_.first_city_ixs == 0)
        _s_.prep_0 = sample_record_state(ctx, _s_, 60, "P0", Bernoulli(0.5))
        _s_.damage_0 = sample_record_state(ctx, _s_, 70, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
        _s_.prep_1 = sample_record_state(ctx, _s_, 86, "P1", Bernoulli((_s_.damage_0 == 1) ? 0.75 : 0.5))
        _s_.damage_1 = sample_record_state(ctx, _s_, 102, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
    else
        _s_.prep_1 = sample_record_state(ctx, _s_, 119, "P1", Bernoulli(0.5))
        _s_.damage_1 = sample_record_state(ctx, _s_, 129, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
        _s_.prep_0 = sample_record_state(ctx, _s_, 145, "P0", Bernoulli((_s_.damage_1 == 1) ? 0.75 : 0.5))
        _s_.damage_0 = sample_record_state(ctx, _s_, 161, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
    end
end

function hurricane_D0_161(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.damage_0 = revisit(ctx, _s_, 161, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
end

function hurricane_D0_70(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.damage_0 = revisit(ctx, _s_, 70, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
    _s_.prep_1 = score(ctx, _s_, 86, "P1", Bernoulli((_s_.damage_0 == 1) ? 0.75 : 0.5))
end

function hurricane_D1_102(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.damage_1 = revisit(ctx, _s_, 102, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
end

function hurricane_D1_129(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.damage_1 = revisit(ctx, _s_, 129, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
    _s_.prep_0 = score(ctx, _s_, 145, "P0", Bernoulli((_s_.damage_1 == 1) ? 0.75 : 0.5))
end

function hurricane_F_22(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.first_city_ixs = revisit(ctx, _s_, 22, "F", Bernoulli(0.5))
    _s_.prep_0 = 0
    _s_.damage_0 = 0
    _s_.prep_1 = 0
    _s_.damage_1 = 0
    if (_s_.first_city_ixs == 0)
        _s_.prep_0 = score(ctx, _s_, 60, "P0", Bernoulli(0.5))
        _s_.damage_0 = score(ctx, _s_, 70, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
        _s_.prep_1 = score(ctx, _s_, 86, "P1", Bernoulli((_s_.damage_0 == 1) ? 0.75 : 0.5))
        _s_.damage_1 = score(ctx, _s_, 102, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
    else
        _s_.prep_1 = score(ctx, _s_, 119, "P1", Bernoulli(0.5))
        _s_.damage_1 = score(ctx, _s_, 129, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
        _s_.prep_0 = score(ctx, _s_, 145, "P0", Bernoulli((_s_.damage_1 == 1) ? 0.75 : 0.5))
        _s_.damage_0 = score(ctx, _s_, 161, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
    end
end

function hurricane_P0_145(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.prep_0 = revisit(ctx, _s_, 145, "P0", Bernoulli((_s_.damage_1 == 1) ? 0.75 : 0.5))
    _s_.damage_0 = score(ctx, _s_, 161, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
end

function hurricane_P0_60(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.prep_0 = revisit(ctx, _s_, 60, "P0", Bernoulli(0.5))
    _s_.damage_0 = score(ctx, _s_, 70, "D0", Bernoulli((_s_.prep_0 == 1) ? 0.2 : 0.8))
end

function hurricane_P1_119(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.prep_1 = revisit(ctx, _s_, 119, "P1", Bernoulli(0.5))
    _s_.damage_1 = score(ctx, _s_, 129, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
end

function hurricane_P1_86(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.prep_1 = revisit(ctx, _s_, 86, "P1", Bernoulli((_s_.damage_0 == 1) ? 0.75 : 0.5))
    _s_.damage_1 = score(ctx, _s_, 102, "D1", Bernoulli((_s_.prep_1 == 1) ? 0.2 : 0.8))
end

function hurricane_factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    if _s_.node_id == 161
        return hurricane_D0_161(ctx, _s_)
    end
    if _s_.node_id == 70
        return hurricane_D0_70(ctx, _s_)
    end
    if _s_.node_id == 102
        return hurricane_D1_102(ctx, _s_)
    end
    if _s_.node_id == 129
        return hurricane_D1_129(ctx, _s_)
    end
    if _s_.node_id == 22
        return hurricane_F_22(ctx, _s_)
    end
    if _s_.node_id == 145
        return hurricane_P0_145(ctx, _s_)
    end
    if _s_.node_id == 60
        return hurricane_P0_60(ctx, _s_)
    end
    if _s_.node_id == 119
        return hurricane_P1_119(ctx, _s_)
    end
    if _s_.node_id == 86
        return hurricane_P1_86(ctx, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return hurricane(ctx)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return hurricane(ctx, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return hurricane_factor(ctx, _s_, _addr_)
end
