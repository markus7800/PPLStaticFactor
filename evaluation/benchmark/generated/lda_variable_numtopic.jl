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

function distance(other::State, _s_::State)
    d = 0.
    d = max(d, other.K isa Vector ? maximum(abs, other.K .- _s_.K) : abs(other.K - _s_.K))
    d = max(d, other.i isa Vector ? maximum(abs, other.i .- _s_.i) : abs(other.i - _s_.i))
    d = max(d, other.n isa Vector ? maximum(abs, other.n .- _s_.n) : abs(other.n - _s_.n))
    d = max(d, other.phi isa Vector ? maximum(abs, other.phi .- _s_.phi) : abs(other.phi - _s_.phi))
    d = max(d, other.phis isa Vector ? maximum(abs, other.phis .- _s_.phis) : abs(other.phis - _s_.phis))
    d = max(d, other.theta isa Vector ? maximum(abs, other.theta .- _s_.theta) : abs(other.theta - _s_.theta))
    d = max(d, other.thetas isa Vector ? maximum(abs, other.thetas .- _s_.thetas) : abs(other.thetas - _s_.thetas))
    return d
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function lda(ctx::AbstractSampleRecordStateContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.K::Int = sample_record_state(ctx, _s_, 38, "K", Poisson(2))
    _s_.K = (_s_.K + 1)
    _s_.thetas::Vector{Vector{Float64}} = Vector{Vector{Float64}}()
    _s_.i::Int = 1
    while (_s_.i <= M)
        _s_.theta::Vector{Float64} = sample_record_state(ctx, _s_, 81, ("theta_" * string(_s_.i)), Dirichlet(fill((1 / _s_.K), _s_.K)))
        _s_.thetas = append(_s_.thetas, _s_.theta)
        _s_.i = (_s_.i + 1)
    end
    _s_.phis::Vector{Vector{Float64}} = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= _s_.K)
        _s_.phi::Vector{Float64} = sample_record_state(ctx, _s_, 141, ("phi_" * string(_s_.i)), Dirichlet(fill((1 / V), V)))
        _s_.phis = append(_s_.phis, _s_.phi)
        _s_.i = (_s_.i + 1)
    end
    _s_.n::Int = 1
    while (_s_.n <= N)
        z = sample_record_state(ctx, _s_, 189, ("z_" * string(_s_.n)), Categorical(_s_.thetas[doc[_s_.n]]))
        z = min(length(_s_.phis), z)
        _ = sample_record_state(ctx, _s_, 216, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
        _s_.n = (_s_.n + 1)
    end
end

function lda_K_38(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.K = resample(ctx, _s_, 38, "K", Poisson(2))
    _s_.K = (_s_.K + 1)
    _s_.thetas = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= M)
        _s_.theta = score(ctx, _s_, 81, ("theta_" * string(_s_.i)), Dirichlet(fill((1 / _s_.K), _s_.K)))
        _s_.thetas = append(_s_.thetas, _s_.theta)
        _s_.i = (_s_.i + 1)
    end
    _s_.phis = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= _s_.K)
        _s_.phi = score(ctx, _s_, 141, ("phi_" * string(_s_.i)), Dirichlet(fill((1 / V), V)))
        _s_.phis = append(_s_.phis, _s_.phi)
        _s_.i = (_s_.i + 1)
    end
    _s_.n = 1
    while (_s_.n <= N)
        z = score(ctx, _s_, 189, ("z_" * string(_s_.n)), Categorical(_s_.thetas[doc[_s_.n]]))
        z = min(length(_s_.phis), z)
        score(ctx, _s_, 216, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
        _s_.n = (_s_.n + 1)
    end
end

function lda_phi__141(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.phi = resample(ctx, _s_, 141, ("phi_" * string(_s_.i)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.i = (_s_.i + 1)
    while (_s_.i <= _s_.K)
        _s_.phi = read(ctx, _s_, 141, ("phi_" * string(_s_.i)))
        _s_.phis = append(_s_.phis, _s_.phi)
        _s_.i = (_s_.i + 1)
    end
    _s_.n = 1
    while (_s_.n <= N)
        z = read(ctx, _s_, 189, ("z_" * string(_s_.n)))
        z = min(length(_s_.phis), z)
        score(ctx, _s_, 216, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
        _s_.n = (_s_.n + 1)
    end
end

function lda_theta__81(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 81, ("theta_" * string(_s_.i)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.i = (_s_.i + 1)
    while (_s_.i <= M)
        _s_.theta = read(ctx, _s_, 81, ("theta_" * string(_s_.i)))
        _s_.thetas = append(_s_.thetas, _s_.theta)
        _s_.i = (_s_.i + 1)
    end
    _s_.phis = Vector{Vector{Float64}}()
    _s_.i = 1
    while (_s_.i <= _s_.K)
        _s_.phi = read(ctx, _s_, 141, ("phi_" * string(_s_.i)))
        _s_.phis = append(_s_.phis, _s_.phi)
        _s_.i = (_s_.i + 1)
    end
    _s_.n = 1
    while (_s_.n <= N)
        z = score(ctx, _s_, 189, ("z_" * string(_s_.n)), Categorical(_s_.thetas[doc[_s_.n]]))
        z = min(length(_s_.phis), z)
        read(ctx, _s_, 216, ("w_" * string(_s_.n)), observed = w[_s_.n])
        _s_.n = (_s_.n + 1)
    end
end

function lda_z__189(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 189, ("z_" * string(_s_.n)), Categorical(_s_.thetas[doc[_s_.n]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 216, ("w_" * string(_s_.n)), Categorical(_s_.phis[z]), observed = w[_s_.n])
end

function lda_factor(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State, _addr_::String)
    if _s_.node_id == 38
        return lda_K_38(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 141
        return lda_phi__141(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 81
        return lda_theta__81(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 189
        return lda_z__189(ctx, M, N, V, w, doc, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return lda(ctx, M, N, V, w, doc)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return lda(ctx, M, N, V, w, doc, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return lda_factor(ctx, M, N, V, w, doc, _s_, _addr_)
end
