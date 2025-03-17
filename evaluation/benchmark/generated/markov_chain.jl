# this file is auto-generated

include("../markov_chain.jl")

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

function markov_chain(ctx::AbstractSampleRecordStateContext, _s_::State)
    _s_.TERMINAL_STATE::Int = 4
    _s_.transition_probs::Matrix{Float64} = [0.1 0.2 0.6 0.1; 0.05 0.8 0.1 0.05; 0.3 0.3 0.3 0.1]
    _s_.current::Int = sample_record_state(ctx, _s_, 53, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.i::Int = 1
    while (_s_.current != _s_.TERMINAL_STATE)
        _s_.current = sample_record_state(ctx, _s_, 79, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
        _s_.i = (_s_.i + 1)
    end
end

function markov_chain_initial_state_53(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.current = resample(ctx, _s_, 53, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.i = 1
    while (_s_.current != _s_.TERMINAL_STATE)
        _s_.current = score(ctx, _s_, 79, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
        _s_.i = (_s_.i + 1)
    end
end

function markov_chain_state__79(ctx::AbstractFactorResampleContext, _s_::State)
    _s_.current = resample(ctx, _s_, 79, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _s_.i = (_s_.i + 1)
    while (_s_.current != _s_.TERMINAL_STATE)
        _s_.current = score(ctx, _s_, 79, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
        _s_.i = (_s_.i + 1)
    end
end

function markov_chain_factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    if _s_.node_id == 53
        return markov_chain_initial_state_53(ctx, _s_)
    end
    if _s_.node_id == 79
        return markov_chain_state__79(ctx, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return markov_chain(ctx)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return markov_chain(ctx, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return markov_chain_factor(ctx, _s_, _addr_)
end
