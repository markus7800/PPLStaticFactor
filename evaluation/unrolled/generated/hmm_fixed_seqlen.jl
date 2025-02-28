# this file is auto-generated

include("../hmm_fixed_seqlen.jl")

mutable struct State <: AbstractState
    node_id:: Int
    current::Int
    transition_probs::Matrix{Float64}
    function State()
        return new(
            0,
            zero(Int),
            zero(Matrix{Float64}),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.current = _s_.current
    dst.transition_probs = _s_.transition_probs
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function hmm(ctx::AbstractSampleRecordStateContext, ys::Vector{Float64}, _s_::State)
    _s_.transition_probs::Matrix{Float64} = [0.1 0.2 0.7; 0.1 0.8 0.1; 0.3 0.3 0.4]
    _s_.current::Int = sample_record_state(ctx, _s_, 50, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = sample_record_state(ctx, _s_, 66, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 84, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    _s_.current = sample_record_state(ctx, _s_, 106, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 124, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    _s_.current = sample_record_state(ctx, _s_, 146, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 164, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    _s_.current = sample_record_state(ctx, _s_, 186, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 204, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    _s_.current = sample_record_state(ctx, _s_, 226, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 244, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    _s_.current = sample_record_state(ctx, _s_, 266, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 284, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    _s_.current = sample_record_state(ctx, _s_, 306, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 324, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    _s_.current = sample_record_state(ctx, _s_, 346, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 364, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    _s_.current = sample_record_state(ctx, _s_, 386, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 404, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    _s_.current = sample_record_state(ctx, _s_, 426, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 444, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))

end

function hmm_initial_state_50(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 50, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = score(ctx, _s_, 66, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__106(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 106, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 124, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    _s_.current = score(ctx, _s_, 146, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__146(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 146, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 164, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    _s_.current = score(ctx, _s_, 186, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__186(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 186, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 204, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    _s_.current = score(ctx, _s_, 226, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__226(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 226, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 244, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    _s_.current = score(ctx, _s_, 266, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__266(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 266, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 284, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    _s_.current = score(ctx, _s_, 306, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__306(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 306, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 324, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    _s_.current = score(ctx, _s_, 346, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__346(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 346, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 364, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    _s_.current = score(ctx, _s_, 386, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__386(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 386, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 404, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    _s_.current = score(ctx, _s_, 426, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__426(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 426, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 444, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))
end

function hmm_state__66(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 66, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 84, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    _s_.current = score(ctx, _s_, 106, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_factor(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 50
        return hmm_initial_state_50(ctx, ys, _s_)
    end
    if _s_.node_id == 106
        return hmm_state__106(ctx, ys, _s_)
    end
    if _s_.node_id == 146
        return hmm_state__146(ctx, ys, _s_)
    end
    if _s_.node_id == 186
        return hmm_state__186(ctx, ys, _s_)
    end
    if _s_.node_id == 226
        return hmm_state__226(ctx, ys, _s_)
    end
    if _s_.node_id == 266
        return hmm_state__266(ctx, ys, _s_)
    end
    if _s_.node_id == 306
        return hmm_state__306(ctx, ys, _s_)
    end
    if _s_.node_id == 346
        return hmm_state__346(ctx, ys, _s_)
    end
    if _s_.node_id == 386
        return hmm_state__386(ctx, ys, _s_)
    end
    if _s_.node_id == 426
        return hmm_state__426(ctx, ys, _s_)
    end
    if _s_.node_id == 66
        return hmm_state__66(ctx, ys, _s_)
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
