# this file is auto-generated

include("../hmm_variable_seqlen.jl")

mutable struct State <: AbstractState
    node_id:: Int
    TERMINAL_STATE::Int
    current::Int
    i::Int
    transition_probs::Matrix{Float64}
    function State()
        return new(
            0,
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Matrix{Float64}),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.TERMINAL_STATE = _s_.TERMINAL_STATE
    dst.current = _s_.current
    dst.i = _s_.i
    dst.transition_probs = _s_.transition_probs
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function distance(other::State, _s_::State)
    d = 0.
    d = max(d, other.TERMINAL_STATE isa Vector ? maximum(abs, other.TERMINAL_STATE .- _s_.TERMINAL_STATE) : abs(other.TERMINAL_STATE - _s_.TERMINAL_STATE))
    d = max(d, other.current isa Vector ? maximum(abs, other.current .- _s_.current) : abs(other.current - _s_.current))
    d = max(d, other.i isa Vector ? maximum(abs, other.i .- _s_.i) : abs(other.i - _s_.i))
    d = max(d, other.transition_probs isa Vector ? maximum(abs, other.transition_probs .- _s_.transition_probs) : abs(other.transition_probs - _s_.transition_probs))
    return d
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function hmm(ctx::AbstractSampleRecordStateContext, ys::Vector{Float64}, _s_::State)
    _s_.TERMINAL_STATE::Int = 4
    _s_.transition_probs::Matrix{Float64} = [0.1 0.2 0.6 0.1; 0.05 0.8 0.1 0.05; 0.3 0.3 0.3 0.1]
    _s_.current::Int = sample_record_state(ctx, _s_, 51, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.i::Int = 1
    while (_s_.current != _s_.TERMINAL_STATE)
        _s_.current = sample_record_state(ctx, _s_, 77, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
        if (_s_.i <= length(ys))
            _ = sample_record_state(ctx, _s_, 103, ("obs_" * string(_s_.i)), Normal((_s_.current == _s_.TERMINAL_STATE) ? 100.0 : _s_.current, 1.0), observed = get_n(ys, _s_.i))
        end
        _s_.i = (_s_.i + 1)
    end
end

function hmm_initial_state_51(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 51, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.i = 1
    while (_s_.current != _s_.TERMINAL_STATE)
        _s_.current = score(ctx, _s_, 77, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
        if (_s_.i <= length(ys))
            score(ctx, _s_, 103, ("obs_" * string(_s_.i)), Normal((_s_.current == _s_.TERMINAL_STATE) ? 100.0 : _s_.current, 1.0), observed = get_n(ys, _s_.i))
        end
        _s_.i = (_s_.i + 1)
    end
end

function hmm_state__77(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 77, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    if (_s_.i <= length(ys))
        score(ctx, _s_, 103, ("obs_" * string(_s_.i)), Normal((_s_.current == _s_.TERMINAL_STATE) ? 100.0 : _s_.current, 1.0), observed = get_n(ys, _s_.i))
    end
    _s_.i = (_s_.i + 1)
    while (_s_.current != _s_.TERMINAL_STATE)
        _s_.current = score(ctx, _s_, 77, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
        if (_s_.i <= length(ys))
            score(ctx, _s_, 103, ("obs_" * string(_s_.i)), Normal((_s_.current == _s_.TERMINAL_STATE) ? 100.0 : _s_.current, 1.0), observed = get_n(ys, _s_.i))
        end
        _s_.i = (_s_.i + 1)
    end
end

function hmm_factor(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 51
        return hmm_initial_state_51(ctx, ys, _s_)
    end
    if _s_.node_id == 77
        return hmm_state__77(ctx, ys, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return hmm(ctx, ys)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return hmm(ctx, ys, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return hmm_factor(ctx, ys, _s_, _addr_)
end
