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

function distance(other::State, _s_::State)
    d = 0.
    d = max(d, other.current isa Vector ? maximum(abs, other.current .- _s_.current) : abs(other.current - _s_.current))
    d = max(d, other.transition_probs isa Vector ? maximum(abs, other.transition_probs .- _s_.transition_probs) : abs(other.transition_probs - _s_.transition_probs))
    return d
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function hmm(ctx::AbstractSampleRecordStateContext, ys::Vector{Float64}, _s_::State)
    _s_.transition_probs::Matrix{Float64} = [0.1 0.2 0.7; 0.1 0.8 0.1; 0.3 0.3 0.4]
    _s_.current::Int = sample_record_state(ctx, _s_, 43, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = sample_record_state(ctx, _s_, 59, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 77, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    _s_.current = sample_record_state(ctx, _s_, 99, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 117, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    _s_.current = sample_record_state(ctx, _s_, 139, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 157, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    _s_.current = sample_record_state(ctx, _s_, 179, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 197, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    _s_.current = sample_record_state(ctx, _s_, 219, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 237, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    _s_.current = sample_record_state(ctx, _s_, 259, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 277, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    _s_.current = sample_record_state(ctx, _s_, 299, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 317, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    _s_.current = sample_record_state(ctx, _s_, 339, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 357, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    _s_.current = sample_record_state(ctx, _s_, 379, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 397, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    _s_.current = sample_record_state(ctx, _s_, 419, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 437, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))

end

function hmm_initial_state_43(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 43, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = score(ctx, _s_, 59, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__139(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 139, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 157, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    _s_.current = score(ctx, _s_, 179, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__179(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 179, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 197, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    _s_.current = score(ctx, _s_, 219, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__219(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 219, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 237, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    _s_.current = score(ctx, _s_, 259, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__259(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 259, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 277, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    _s_.current = score(ctx, _s_, 299, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__299(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 299, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 317, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    _s_.current = score(ctx, _s_, 339, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__339(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 339, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 357, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    _s_.current = score(ctx, _s_, 379, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__379(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 379, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 397, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    _s_.current = score(ctx, _s_, 419, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__419(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 419, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 437, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))
end

function hmm_state__59(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 59, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 77, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    _s_.current = score(ctx, _s_, 99, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__99(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 99, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 117, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    _s_.current = score(ctx, _s_, 139, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_factor(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 43
        return hmm_initial_state_43(ctx, ys, _s_)
    end
    if _s_.node_id == 139
        return hmm_state__139(ctx, ys, _s_)
    end
    if _s_.node_id == 179
        return hmm_state__179(ctx, ys, _s_)
    end
    if _s_.node_id == 219
        return hmm_state__219(ctx, ys, _s_)
    end
    if _s_.node_id == 259
        return hmm_state__259(ctx, ys, _s_)
    end
    if _s_.node_id == 299
        return hmm_state__299(ctx, ys, _s_)
    end
    if _s_.node_id == 339
        return hmm_state__339(ctx, ys, _s_)
    end
    if _s_.node_id == 379
        return hmm_state__379(ctx, ys, _s_)
    end
    if _s_.node_id == 419
        return hmm_state__419(ctx, ys, _s_)
    end
    if _s_.node_id == 59
        return hmm_state__59(ctx, ys, _s_)
    end
    if _s_.node_id == 99
        return hmm_state__99(ctx, ys, _s_)
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
