# this file is auto-generated

include("../lda_variable_numtopic.jl")

mutable struct State <: AbstractState
    node_id:: Int
    K::Int
    i::Int
    n::Int
    phi::Vector{Float64}
    phis::Vector{Vector{Float64}}
    theta::Vector{Float64}
    thetas::Vector{Vector{Float64}}
    function State()
        return new(
            0,
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Vector{Float64}),
            zero(Vector{Vector{Float64}}),
            zero(Vector{Float64}),
            zero(Vector{Vector{Float64}}),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.K = _s_.K
    dst.i = _s_.i
    dst.n = _s_.n
    dst.phi = _s_.phi
    dst.phis = _s_.phis
    dst.theta = _s_.theta
    dst.thetas = _s_.thetas
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function lda(ctx::AbstractSampleRecordStateContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.K::Int = sample_record_state(ctx, _s_, 41, "K", Poisson(2))
    _s_.K = (_s_.K + 1)
    _s_.thetas::Vector{Vector{Float64}} = Vector{Vector{Float64}}()
    _s_.i::Int = 1
    while (_s_.i <= M)
        _s_.theta::Vector{Float64} = sample_record_state(ctx, _s_, 84, ("theta_" * string(_s_.i)), Dirichlet(fill((1 / _s_.K), _s_.K)))
        _s_.thetas = append(_s_.thetas, _s_.theta)
        _s_.i = (_s_.i + 1)
    end
    _s_.phis::Vector{Vector{Float64}} = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= _s_.K)
        _s_.phi::Vector{Float64} = sample_record_state(ctx, _s_, 144, ("phi_" * string(_s_.i)), Dirichlet(fill((1 / V), V)))
        _s_.phis = append(_s_.phis, _s_.phi)
        _s_.i = (_s_.i + 1)
    end
    _s_.n::Int = 1
    while (_s_.n <= N)
        z = sample_record_state(ctx, _s_, 192, ("z_" * string(_s_.n)), Categorical(_s_.thetas[doc[_s_.n]]))
        z = min(length(_s_.phis), z)
        _ = sample_record_state(ctx, _s_, 219, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
        _s_.n = (_s_.n + 1)
    end
end

function lda_K_41(ctx::AbstractFactorRevisitContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.K = revisit(ctx, _s_, 41, "K", Poisson(2))
    _s_.K = (_s_.K + 1)
    _s_.thetas = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= M)
        _s_.theta = score(ctx, _s_, 84, ("theta_" * string(_s_.i)), Dirichlet(fill((1 / _s_.K), _s_.K)))
        _s_.thetas = append(_s_.thetas, _s_.theta)
        _s_.i = (_s_.i + 1)
    end
    _s_.phis = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= _s_.K)
        _s_.phi = score(ctx, _s_, 144, ("phi_" * string(_s_.i)), Dirichlet(fill((1 / V), V)))
        _s_.phis = append(_s_.phis, _s_.phi)
        _s_.i = (_s_.i + 1)
    end
    _s_.n = 1
    while (_s_.n <= N)
        z = score(ctx, _s_, 192, ("z_" * string(_s_.n)), Categorical(_s_.thetas[doc[_s_.n]]))
        z = min(length(_s_.phis), z)
        score(ctx, _s_, 219, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
        _s_.n = (_s_.n + 1)
    end
end

function lda_phi__144(ctx::AbstractFactorRevisitContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.phi = revisit(ctx, _s_, 144, ("phi_" * string(_s_.i)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.i = (_s_.i + 1)
    while (_s_.i <= _s_.K)
        _s_.phi = read(ctx, _s_, 144, ("phi_" * string(_s_.i)))
        _s_.phis = append(_s_.phis, _s_.phi)
        _s_.i = (_s_.i + 1)
    end
    _s_.n = 1
    while (_s_.n <= N)
        z = read(ctx, _s_, 192, ("z_" * string(_s_.n)))
        z = min(length(_s_.phis), z)
        score(ctx, _s_, 219, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
        _s_.n = (_s_.n + 1)
    end
end

function lda_theta__84(ctx::AbstractFactorRevisitContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = revisit(ctx, _s_, 84, ("theta_" * string(_s_.i)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.i = (_s_.i + 1)
    while (_s_.i <= M)
        _s_.theta = read(ctx, _s_, 84, ("theta_" * string(_s_.i)))
        _s_.thetas = append(_s_.thetas, _s_.theta)
        _s_.i = (_s_.i + 1)
    end
    _s_.phis = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= _s_.K)
        _s_.phi = read(ctx, _s_, 144, ("phi_" * string(_s_.i)))
        _s_.phis = append(_s_.phis, _s_.phi)
        _s_.i = (_s_.i + 1)
    end
    _s_.n = 1
    while (_s_.n <= N)
        z = score(ctx, _s_, 192, ("z_" * string(_s_.n)), Categorical(_s_.thetas[doc[_s_.n]]))
        z = min(length(_s_.phis), z)
        read(ctx, _s_, 219, ("w_" * string(_s_.n)), observed = w[_s_.n])
        _s_.n = (_s_.n + 1)
    end
end

function lda_z__192(ctx::AbstractFactorRevisitContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = revisit(ctx, _s_, 192, ("z_" * string(_s_.n)), Categorical(_s_.thetas[doc[_s_.n]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 219, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
end

function lda_factor(ctx::AbstractFactorRevisitContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State, _addr_::String)
    if _s_.node_id == 41
        return lda_K_41(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 144
        return lda_phi__144(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 84
        return lda_theta__84(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 192
        return lda_z__192(ctx, M, N, V, w, doc, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function lda___start__(ctx::AbstractFactorResumeContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.K = read(ctx, _s_, 41, "K")
    _s_.K = (_s_.K + 1)
    _s_.thetas = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= M)
        _s_.theta = read(ctx, _s_, 84, ("theta_" * string(_s_.i)))
        _s_.thetas = append(_s_.thetas, _s_.theta)
        _s_.i = (_s_.i + 1)
    end
    _s_.phis = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= _s_.K)
        _s_.phi = read(ctx, _s_, 144, ("phi_" * string(_s_.i)))
        _s_.phis = append(_s_.phis, _s_.phi)
        _s_.i = (_s_.i + 1)
    end
    _s_.n = 1
    while (_s_.n <= N)
        z = read(ctx, _s_, 192, ("z_" * string(_s_.n)))
        z = min(length(_s_.phis), z)
        score(ctx, _s_, 219, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
        return
    end
end

function lda_w__219(ctx::AbstractFactorResumeContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    resume(ctx, _s_, 219, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
    _s_.n = (_s_.n + 1)
    while (_s_.n <= N)
        z = read(ctx, _s_, 192, ("z_" * string(_s_.n)))
        z = min(length(_s_.phis), z)
        score(ctx, _s_, 219, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
        return
    end
end

function lda_resume(ctx::AbstractFactorResumeContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State, _addr_::String)
    if _s_.node_id == 0
        return lda___start__(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 219
        return lda_w__219(ctx, M, N, V, w, doc, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return lda(ctx, M, N, V, w, doc)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return lda(ctx, M, N, V, w, doc, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return lda_factor(ctx, M, N, V, w, doc, _s_, _addr_)
end

function resume(ctx::AbstractFactorResumeContext, _s_::State, _addr_::String)
    return lda_resume(ctx, M, N, V, w, doc, _s_, _addr_)
end

