# this file is auto-generated

include("../urn.jl")

mutable struct State <: AbstractState
    node_id:: Int
    N::Int
    ball::Int
    ball_ix::Int
    balls::Vector{Int}
    i::Int
    k::Int
    n_black::Int
    function State()
        return new(
            0,
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Vector{Int}),
            zero(Int),
            zero(Int),
            zero(Int),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.N = _s_.N
    dst.ball = _s_.ball
    dst.ball_ix = _s_.ball_ix
    dst.balls = _s_.balls
    dst.i = _s_.i
    dst.k = _s_.k
    dst.n_black = _s_.n_black
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function urn(ctx::AbstractSampleRecordStateContext, K::Int, _s_::State)
    _s_.N::Int = sample_record_state(ctx, _s_, 25, "N", Poisson(6))
    _s_.balls::Vector{Int} = Int[]
    _s_.i::Int = 1
    while (_s_.i <= _s_.N)
        _s_.ball::Int = sample_record_state(ctx, _s_, 56, ("ball_" * string(_s_.i)), Bernoulli(0.5))
        _s_.balls = vcat(_s_.balls, _s_.ball)
        _s_.i = (_s_.i + 1)
    end
    _s_.n_black::Int = 0
    if (_s_.N > 0)
        _s_.k::Int = 1
        while (_s_.k <= K)
            _s_.ball_ix::Int = sample_record_state(ctx, _s_, 107, ("drawn_ball_" * string(_s_.k)), DiscreteUniform(1, _s_.N))
            _s_.n_black = (_s_.n_black + get_n(_s_.balls, min(length(_s_.balls), _s_.ball_ix)))
            _s_.k = (_s_.k + 1)
        end
    end
    _ = sample_record_state(ctx, _s_, 145, "n_black", Normal(_s_.n_black, 0.1), observed = 5.0)
end

function urn_N_25(ctx::AbstractFactorRevisitContext, K::Int, _s_::State)
    _s_.N = revisit(ctx, _s_, 25, "N", Poisson(6))
    _s_.balls = Int[]
    _s_.i = 1
    while (_s_.i <= _s_.N)
        _s_.ball = score(ctx, _s_, 56, ("ball_" * string(_s_.i)), Bernoulli(0.5))
        _s_.balls = vcat(_s_.balls, _s_.ball)
        _s_.i = (_s_.i + 1)
    end
    _s_.n_black = 0
    if (_s_.N > 0)
        _s_.k = 1
        while (_s_.k <= K)
            _s_.ball_ix = score(ctx, _s_, 107, ("drawn_ball_" * string(_s_.k)), DiscreteUniform(1, _s_.N))
            _s_.n_black = (_s_.n_black + get_n(_s_.balls, min(length(_s_.balls), _s_.ball_ix)))
            _s_.k = (_s_.k + 1)
        end
    end
    score(ctx, _s_, 145, "n_black", Normal(_s_.n_black, 0.1), observed = 5.0)
end

function urn_ball__56(ctx::AbstractFactorRevisitContext, K::Int, _s_::State)
    _s_.ball = revisit(ctx, _s_, 56, ("ball_" * string(_s_.i)), Bernoulli(0.5))
    _s_.balls = vcat(_s_.balls, _s_.ball)
    _s_.i = (_s_.i + 1)
    while (_s_.i <= _s_.N)
        _s_.ball = read(ctx, _s_, 56, ("ball_" * string(_s_.i)))
        _s_.balls = vcat(_s_.balls, _s_.ball)
        _s_.i = (_s_.i + 1)
    end
    _s_.n_black = 0
    if (_s_.N > 0)
        _s_.k = 1
        while (_s_.k <= K)
            _s_.ball_ix = read(ctx, _s_, 107, ("drawn_ball_" * string(_s_.k)))
            _s_.n_black = (_s_.n_black + get_n(_s_.balls, min(length(_s_.balls), _s_.ball_ix)))
            _s_.k = (_s_.k + 1)
        end
    end
    score(ctx, _s_, 145, "n_black", Normal(_s_.n_black, 0.1), observed = 5.0)
end

function urn_drawn_ball__107(ctx::AbstractFactorRevisitContext, K::Int, _s_::State)
    _s_.ball_ix = revisit(ctx, _s_, 107, ("drawn_ball_" * string(_s_.k)), DiscreteUniform(1, _s_.N))
    _s_.n_black = (_s_.n_black + get_n(_s_.balls, min(length(_s_.balls), _s_.ball_ix)))
    _s_.k = (_s_.k + 1)
    while (_s_.k <= K)
        _s_.ball_ix = read(ctx, _s_, 107, ("drawn_ball_" * string(_s_.k)))
        _s_.n_black = (_s_.n_black + get_n(_s_.balls, min(length(_s_.balls), _s_.ball_ix)))
        _s_.k = (_s_.k + 1)
    end
    score(ctx, _s_, 145, "n_black", Normal(_s_.n_black, 0.1), observed = 5.0)
end

function urn_factor(ctx::AbstractFactorRevisitContext, K::Int, _s_::State, _addr_::String)
    if _s_.node_id == 25
        return urn_N_25(ctx, K, _s_)
    end
    if _s_.node_id == 56
        return urn_ball__56(ctx, K, _s_)
    end
    if _s_.node_id == 107
        return urn_drawn_ball__107(ctx, K, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return urn(ctx, K)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return urn(ctx, K, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return urn_factor(ctx, K, _s_, _addr_)
end

