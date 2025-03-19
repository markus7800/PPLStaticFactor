# this file is auto-generated

include("../hmm.jl")

mutable struct State <: AbstractState
    node_id:: Int
    current::Int
    i::Int
    seqlen::Int
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
    dst.current = _s_.current
    dst.i = _s_.i
    dst.seqlen = _s_.seqlen
    dst.transition_probs = _s_.transition_probs
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function hmm(ctx::AbstractSampleRecordStateContext, ys::Vector{Float64}, _s_::State)
    _s_.seqlen::Int = length(ys)
    _s_.transition_probs::Matrix{Float64} = [0.1 0.2 0.7; 0.1 0.8 0.1; 0.3 0.3 0.4]
    _s_.current::Int = sample_record_state(ctx, _s_, 57, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.i::Int = 1
    while (_s_.i <= _s_.seqlen)
        _s_.current = sample_record_state(ctx, _s_, 83, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
        _ = sample_record_state(ctx, _s_, 101, ("obs_" * string(_s_.i)), Normal(_s_.current, 1), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function hmm_initial_state_57(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 57, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.i = 1
    while (_s_.i <= _s_.seqlen)
        _s_.current = score(ctx, _s_, 83, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
        read(ctx, _s_, 101, ("obs_" * string(_s_.i)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function hmm_state__83(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 83, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 101, ("obs_" * string(_s_.i)), Normal(_s_.current, 1), observed = get_n(ys, _s_.i))
    _s_.i = (_s_.i + 1)
    while (_s_.i <= _s_.seqlen)
        _s_.current = score(ctx, _s_, 83, ("state_" * string(_s_.i)), Categorical(get_row(_s_.transition_probs, _s_.current)))
        score(ctx, _s_, 101, ("obs_" * string(_s_.i)), Normal(_s_.current, 1), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function hmm_factor(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 57
        return hmm_initial_state_57(ctx, ys, _s_)
    end
    if _s_.node_id == 83
        return hmm_state__83(ctx, ys, _s_)
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
