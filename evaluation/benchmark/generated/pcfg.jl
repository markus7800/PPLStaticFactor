# this file is auto-generated

include("../pcfg.jl")

mutable struct State <: AbstractState
    node_id:: Int
    TERMINAL_SYMBOL::Int
    current::Int
    i::Int
    production_probs::Matrix{Float64}
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
    dst.TERMINAL_SYMBOL = _s_.TERMINAL_SYMBOL
    dst.current = _s_.current
    dst.i = _s_.i
    dst.production_probs = _s_.production_probs
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function pcfg(ctx::AbstractSampleRecordStateContext, _s_::State)
    _s_.TERMINAL_SYMBOL::Int = 4
    _s_.production_probs::Matrix{Float64} = [0.1 0.2 0.6 0.1; 0.05 0.8 0.1 0.05; 0.3 0.3 0.3 0.1]
    _s_.current::Int = sample_record_state(ctx, _s_, 49, "initial_symbol", Categorical([0.33, 0.33, 0.34]))
    _s_.i::Int = 1
    while (_s_.current != _s_.TERMINAL_SYMBOL)
        _s_.current = sample_record_state(ctx, _s_, 75, ("symbol_" * string(_s_.i)), Categorical(get_row(_s_.production_probs, _s_.current)))
        _s_.i = (_s_.i + 1)
    end
end

function pcfg_initial_symbol_49(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.current = revisit(ctx, _s_, 49, "initial_symbol", Categorical([0.33, 0.33, 0.34]))
    _s_.i = 1
    while (_s_.current != _s_.TERMINAL_SYMBOL)
        _s_.current = score(ctx, _s_, 75, ("symbol_" * string(_s_.i)), Categorical(get_row(_s_.production_probs, _s_.current)))
        _s_.i = (_s_.i + 1)
    end
end

function pcfg_symbol__75(ctx::AbstractFactorRevisitContext, _s_::State)
    _s_.current = revisit(ctx, _s_, 75, ("symbol_" * string(_s_.i)), Categorical(get_row(_s_.production_probs, _s_.current)))
    _s_.i = (_s_.i + 1)
    while (_s_.current != _s_.TERMINAL_SYMBOL)
        _s_.current = score(ctx, _s_, 75, ("symbol_" * string(_s_.i)), Categorical(get_row(_s_.production_probs, _s_.current)))
        _s_.i = (_s_.i + 1)
    end
end

function pcfg_factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    if _s_.node_id == 49
        return pcfg_initial_symbol_49(ctx, _s_)
    end
    if _s_.node_id == 75
        return pcfg_symbol__75(ctx, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return pcfg(ctx)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return pcfg(ctx, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return pcfg_factor(ctx, _s_, _addr_)
end

function resume(ctx::AbstractFactorResumeContext, _s_::State, _addr_::String)
    return pcfg_resume(ctx, _s_, _addr_)
end

