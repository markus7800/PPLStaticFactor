# this file is auto-generated

include("../aircraft.jl")

mutable struct State <: AbstractState
    node_id:: Int
    blip::Float64
    blip_1::Float64
    blip_2::Float64
    blip_3::Float64
    i::Int
    j::Int
    num_aircraft::Int
    num_blips::Int
    position::Float64
    total_num_blibs::Int
    function State()
        return new(
            0,
            zero(Float64),
            zero(Float64),
            zero(Float64),
            zero(Float64),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Float64),
            zero(Int),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.blip = _s_.blip
    dst.blip_1 = _s_.blip_1
    dst.blip_2 = _s_.blip_2
    dst.blip_3 = _s_.blip_3
    dst.i = _s_.i
    dst.j = _s_.j
    dst.num_aircraft = _s_.num_aircraft
    dst.num_blips = _s_.num_blips
    dst.position = _s_.position
    dst.total_num_blibs = _s_.total_num_blibs
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function aircraft(ctx::AbstractSampleRecordStateContext, _s_::State)
    _s_.num_aircraft::Int = sample_record_state(ctx, _s_, 26, "num_aircraft", Poisson(5))
    _s_.num_aircraft = (_s_.num_aircraft + 1)
    _s_.total_num_blibs::Int = 0
    _s_.blip_1::Float64 = 0.0
    _s_.blip_2::Float64 = 0.0
    _s_.blip_3::Float64 = 0.0
    _s_.i::Int = 1
    while (_s_.i <= _s_.num_aircraft)
        _s_.position::Float64 = sample_record_state(ctx, _s_, 75, ("pos_" * string(_s_.i)), Normal(2.0, 5.0))
        _s_.num_blips::Int = sample_record_state(ctx, _s_, 93, ("num_blips_" * string(_s_.i)), Categorical([0.1, 0.4, 0.5]))
        _s_.j::Int = 1
        while (_s_.j <= _s_.num_blips)
            _s_.total_num_blibs = (_s_.total_num_blibs + 1)
            _s_.blip::Float64 = sample_record_state(ctx, _s_, 130, ("blip_" * string(_s_.i) * "_" * string(_s_.j)), Normal(_s_.position, 1.0))
            if (_s_.total_num_blibs == 1)
                _s_.blip_1 = _s_.blip
            end
            if (_s_.total_num_blibs == 2)
                _s_.blip_2 = _s_.blip
            end
            if (_s_.total_num_blibs == 3)
                _s_.blip_3 = _s_.blip
            end
            _s_.j = (_s_.j + 1)
        end
        _s_.i = (_s_.i + 1)
    end
    _ = sample_record_state(ctx, _s_, 192, "observed_num_blips", Normal(_s_.total_num_blibs, 1), observed = 3)
    _ = sample_record_state(ctx, _s_, 206, "observed_blip_2", Normal(_s_.blip_1, 1), observed = 1.0)
    _ = sample_record_state(ctx, _s_, 220, "observed_blip_2", Normal(_s_.blip_2, 1), observed = 2.0)
    _ = sample_record_state(ctx, _s_, 234, "observed_blip_3", Normal(_s_.blip_3, 1), observed = 3.0)
end

function aircraft_blip__130(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.blip = resample(ctx, _s_, 130, ("blip_" * string(_s_.i) * "_" * string(_s_.j)), Normal(_s_.position, 1.0))
    if (_s_.total_num_blibs == 1)
        _s_.blip_1 = _s_.blip
    end
    if (_s_.total_num_blibs == 2)
        _s_.blip_2 = _s_.blip
    end
    if (_s_.total_num_blibs == 3)
        _s_.blip_3 = _s_.blip
    end
    _s_.j = (_s_.j + 1)
    while (_s_.j <= _s_.num_blips)
        _s_.total_num_blibs = (_s_.total_num_blibs + 1)
        _s_.blip = read(ctx, _s_, 130, ("blip_" * string(_s_.i) * "_" * string(_s_.j)))
        if (_s_.total_num_blibs == 1)
            _s_.blip_1 = _s_.blip
        end
        if (_s_.total_num_blibs == 2)
            _s_.blip_2 = _s_.blip
        end
        if (_s_.total_num_blibs == 3)
            _s_.blip_3 = _s_.blip
        end
        _s_.j = (_s_.j + 1)
    end
    _s_.i = (_s_.i + 1)
    while (_s_.i <= _s_.num_aircraft)
        _s_.position = read(ctx, _s_, 75, ("pos_" * string(_s_.i)))
        _s_.num_blips = read(ctx, _s_, 93, ("num_blips_" * string(_s_.i)))
        _s_.j = 1
        while (_s_.j <= _s_.num_blips)
            _s_.total_num_blibs = (_s_.total_num_blibs + 1)
            _s_.blip = read(ctx, _s_, 130, ("blip_" * string(_s_.i) * "_" * string(_s_.j)))
            if (_s_.total_num_blibs == 1)
                _s_.blip_1 = _s_.blip
            end
            if (_s_.total_num_blibs == 2)
                _s_.blip_2 = _s_.blip
            end
            if (_s_.total_num_blibs == 3)
                _s_.blip_3 = _s_.blip
            end
            _s_.j = (_s_.j + 1)
        end
        _s_.i = (_s_.i + 1)
    end
    read(ctx, _s_, 192, "observed_num_blips", observed = 3)
    score(ctx, _s_, 206, "observed_blip_2", Normal(_s_.blip_1, 1), observed = 1.0)
    score(ctx, _s_, 220, "observed_blip_2", Normal(_s_.blip_2, 1), observed = 2.0)
    score(ctx, _s_, 234, "observed_blip_3", Normal(_s_.blip_3, 1), observed = 3.0)
end

function aircraft_num_aircraft_26(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.num_aircraft = resample(ctx, _s_, 26, "num_aircraft", Poisson(5))
    _s_.num_aircraft = (_s_.num_aircraft + 1)
    _s_.total_num_blibs = 0
    _s_.blip_1 = 0.0
    _s_.blip_2 = 0.0
    _s_.blip_3 = 0.0
    _s_.i = 1
    while (_s_.i <= _s_.num_aircraft)
        _s_.position = score(ctx, _s_, 75, ("pos_" * string(_s_.i)), Normal(2.0, 5.0))
        _s_.num_blips = score(ctx, _s_, 93, ("num_blips_" * string(_s_.i)), Categorical([0.1, 0.4, 0.5]))
        _s_.j = 1
        while (_s_.j <= _s_.num_blips)
            _s_.total_num_blibs = (_s_.total_num_blibs + 1)
            _s_.blip = score(ctx, _s_, 130, ("blip_" * string(_s_.i) * "_" * string(_s_.j)), Normal(_s_.position, 1.0))
            if (_s_.total_num_blibs == 1)
                _s_.blip_1 = _s_.blip
            end
            if (_s_.total_num_blibs == 2)
                _s_.blip_2 = _s_.blip
            end
            if (_s_.total_num_blibs == 3)
                _s_.blip_3 = _s_.blip
            end
            _s_.j = (_s_.j + 1)
        end
        _s_.i = (_s_.i + 1)
    end
    score(ctx, _s_, 192, "observed_num_blips", Normal(_s_.total_num_blibs, 1), observed = 3)
    score(ctx, _s_, 206, "observed_blip_2", Normal(_s_.blip_1, 1), observed = 1.0)
    score(ctx, _s_, 220, "observed_blip_2", Normal(_s_.blip_2, 1), observed = 2.0)
    score(ctx, _s_, 234, "observed_blip_3", Normal(_s_.blip_3, 1), observed = 3.0)
end

function aircraft_num_blips__93(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.num_blips = resample(ctx, _s_, 93, ("num_blips_" * string(_s_.i)), Categorical([0.1, 0.4, 0.5]))
    _s_.j = 1
    while (_s_.j <= _s_.num_blips)
        _s_.total_num_blibs = (_s_.total_num_blibs + 1)
        _s_.blip = score(ctx, _s_, 130, ("blip_" * string(_s_.i) * "_" * string(_s_.j)), Normal(_s_.position, 1.0))
        if (_s_.total_num_blibs == 1)
            _s_.blip_1 = _s_.blip
        end
        if (_s_.total_num_blibs == 2)
            _s_.blip_2 = _s_.blip
        end
        if (_s_.total_num_blibs == 3)
            _s_.blip_3 = _s_.blip
        end
        _s_.j = (_s_.j + 1)
    end
    _s_.i = (_s_.i + 1)
    while (_s_.i <= _s_.num_aircraft)
        _s_.position = score(ctx, _s_, 75, ("pos_" * string(_s_.i)), Normal(2.0, 5.0))
        _s_.num_blips = score(ctx, _s_, 93, ("num_blips_" * string(_s_.i)), Categorical([0.1, 0.4, 0.5]))
        _s_.j = 1
        while (_s_.j <= _s_.num_blips)
            _s_.total_num_blibs = (_s_.total_num_blibs + 1)
            _s_.blip = score(ctx, _s_, 130, ("blip_" * string(_s_.i) * "_" * string(_s_.j)), Normal(_s_.position, 1.0))
            if (_s_.total_num_blibs == 1)
                _s_.blip_1 = _s_.blip
            end
            if (_s_.total_num_blibs == 2)
                _s_.blip_2 = _s_.blip
            end
            if (_s_.total_num_blibs == 3)
                _s_.blip_3 = _s_.blip
            end
            _s_.j = (_s_.j + 1)
        end
        _s_.i = (_s_.i + 1)
    end
    score(ctx, _s_, 192, "observed_num_blips", Normal(_s_.total_num_blibs, 1), observed = 3)
    score(ctx, _s_, 206, "observed_blip_2", Normal(_s_.blip_1, 1), observed = 1.0)
    score(ctx, _s_, 220, "observed_blip_2", Normal(_s_.blip_2, 1), observed = 2.0)
    score(ctx, _s_, 234, "observed_blip_3", Normal(_s_.blip_3, 1), observed = 3.0)
end

function aircraft_pos__75(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.position = resample(ctx, _s_, 75, ("pos_" * string(_s_.i)), Normal(2.0, 5.0))
    _s_.num_blips = read(ctx, _s_, 93, ("num_blips_" * string(_s_.i)))
    _s_.j = 1
    while (_s_.j <= _s_.num_blips)
        _s_.total_num_blibs = (_s_.total_num_blibs + 1)
        _s_.blip = score(ctx, _s_, 130, ("blip_" * string(_s_.i) * "_" * string(_s_.j)), Normal(_s_.position, 1.0))
        if (_s_.total_num_blibs == 1)
            _s_.blip_1 = _s_.blip
        end
        if (_s_.total_num_blibs == 2)
            _s_.blip_2 = _s_.blip
        end
        if (_s_.total_num_blibs == 3)
            _s_.blip_3 = _s_.blip
        end
        _s_.j = (_s_.j + 1)
    end
end

function aircraft_factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    if _s_.node_id == 130
        return aircraft_blip__130(ctx, _s_)
    end
    if _s_.node_id == 26
        return aircraft_num_aircraft_26(ctx, _s_)
    end
    if _s_.node_id == 93
        return aircraft_num_blips__93(ctx, _s_)
    end
    if _s_.node_id == 75
        return aircraft_pos__75(ctx, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return aircraft(ctx)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return aircraft(ctx, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return aircraft_factor(ctx, _s_, _addr_)
end
