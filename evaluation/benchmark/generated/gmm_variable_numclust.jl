# this file is auto-generated

include("../gmm_variable_numclust.jl")

mutable struct State <: AbstractState
    node_id:: Int
    i::Int
    k::Int
    means::Vector{Float64}
    mu::Float64
    num_clusters::Int
    var::Float64
    vars::Vector{Float64}
    w::Vector{Float64}
    z::Int
    α::Float64
    β::Float64
    δ::Float64
    κ::Float64
    ξ::Float64
    function State()
        return new(
            0,
            zero(Int),
            zero(Int),
            zero(Vector{Float64}),
            zero(Float64),
            zero(Int),
            zero(Float64),
            zero(Vector{Float64}),
            zero(Vector{Float64}),
            zero(Int),
            zero(Float64),
            zero(Float64),
            zero(Float64),
            zero(Float64),
            zero(Float64),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.i = _s_.i
    dst.k = _s_.k
    dst.means = _s_.means
    dst.mu = _s_.mu
    dst.num_clusters = _s_.num_clusters
    dst.var = _s_.var
    dst.vars = _s_.vars
    dst.w = _s_.w
    dst.z = _s_.z
    dst.α = _s_.α
    dst.β = _s_.β
    dst.δ = _s_.δ
    dst.κ = _s_.κ
    dst.ξ = _s_.ξ
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function distance(other::State, _s_::State)
    d = 0.
    d = max(d, other.i isa Vector ? maximum(abs, other.i .- _s_.i) : abs(other.i - _s_.i))
    d = max(d, other.k isa Vector ? maximum(abs, other.k .- _s_.k) : abs(other.k - _s_.k))
    d = max(d, other.means isa Vector ? maximum(abs, other.means .- _s_.means) : abs(other.means - _s_.means))
    d = max(d, other.mu isa Vector ? maximum(abs, other.mu .- _s_.mu) : abs(other.mu - _s_.mu))
    d = max(d, other.num_clusters isa Vector ? maximum(abs, other.num_clusters .- _s_.num_clusters) : abs(other.num_clusters - _s_.num_clusters))
    d = max(d, other.var isa Vector ? maximum(abs, other.var .- _s_.var) : abs(other.var - _s_.var))
    d = max(d, other.vars isa Vector ? maximum(abs, other.vars .- _s_.vars) : abs(other.vars - _s_.vars))
    d = max(d, other.w isa Vector ? maximum(abs, other.w .- _s_.w) : abs(other.w - _s_.w))
    d = max(d, other.z isa Vector ? maximum(abs, other.z .- _s_.z) : abs(other.z - _s_.z))
    d = max(d, other.α isa Vector ? maximum(abs, other.α .- _s_.α) : abs(other.α - _s_.α))
    d = max(d, other.β isa Vector ? maximum(abs, other.β .- _s_.β) : abs(other.β - _s_.β))
    d = max(d, other.δ isa Vector ? maximum(abs, other.δ .- _s_.δ) : abs(other.δ - _s_.δ))
    d = max(d, other.κ isa Vector ? maximum(abs, other.κ .- _s_.κ) : abs(other.κ - _s_.κ))
    d = max(d, other.ξ isa Vector ? maximum(abs, other.ξ .- _s_.ξ) : abs(other.ξ - _s_.ξ))
    return d
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function gmm(ctx::AbstractSampleRecordStateContext, ys::Vector{Float64}, _s_::State)
    _s_.δ::Float64 = 5.0
    _s_.ξ::Float64 = 0.0
    _s_.κ::Float64 = 0.01
    _s_.α::Float64 = 2.0
    _s_.β::Float64 = 10.0
    _s_.num_clusters::Int = sample_record_state(ctx, _s_, 49, "num_clusters", Poisson(3.0))
    _s_.num_clusters = (_s_.num_clusters + 1)
    _s_.w::Vector{Float64} = sample_record_state(ctx, _s_, 67, "w", Dirichlet(fill(_s_.δ, _s_.num_clusters)))
    _s_.k::Int = 1
    _s_.means::Vector{Float64} = Float64[]
    _s_.vars::Vector{Float64} = Float64[]
    while (_s_.k <= _s_.num_clusters)
        _s_.mu::Float64 = sample_record_state(ctx, _s_, 111, ("mu_" * string(_s_.k)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
        _s_.var::Float64 = sample_record_state(ctx, _s_, 134, ("var_" * string(_s_.k)), InverseGamma(_s_.α, _s_.β))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i::Int = 1
    while (_s_.i <= length(ys))
        _s_.z::Int = sample_record_state(ctx, _s_, 183, ("z_" * string(_s_.i)), Categorical(_s_.w))
        _s_.z = min(_s_.z, length(_s_.means))
        _ = sample_record_state(ctx, _s_, 208, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_mu__111(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = resample(ctx, _s_, 111, ("mu_" * string(_s_.k)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = read(ctx, _s_, 134, ("var_" * string(_s_.k)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.k = (_s_.k + 1)
    while (_s_.k <= _s_.num_clusters)
        _s_.mu = read(ctx, _s_, 111, ("mu_" * string(_s_.k)))
        _s_.var = read(ctx, _s_, 134, ("var_" * string(_s_.k)))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i = 1
    while (_s_.i <= length(ys))
        _s_.z = read(ctx, _s_, 183, ("z_" * string(_s_.i)))
        _s_.z = min(_s_.z, length(_s_.means))
        score(ctx, _s_, 208, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_num_clusters_49(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.num_clusters = resample(ctx, _s_, 49, "num_clusters", Poisson(3.0))
    _s_.num_clusters = (_s_.num_clusters + 1)
    _s_.w = score(ctx, _s_, 67, "w", Dirichlet(fill(_s_.δ, _s_.num_clusters)))
    _s_.k = 1
    _s_.means = Float64[]
    _s_.vars = Float64[]
    while (_s_.k <= _s_.num_clusters)
        _s_.mu = score(ctx, _s_, 111, ("mu_" * string(_s_.k)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
        _s_.var = score(ctx, _s_, 134, ("var_" * string(_s_.k)), InverseGamma(_s_.α, _s_.β))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i = 1
    while (_s_.i <= length(ys))
        _s_.z = score(ctx, _s_, 183, ("z_" * string(_s_.i)), Categorical(_s_.w))
        _s_.z = min(_s_.z, length(_s_.means))
        score(ctx, _s_, 208, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_var__134(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.var = resample(ctx, _s_, 134, ("var_" * string(_s_.k)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.k = (_s_.k + 1)
    while (_s_.k <= _s_.num_clusters)
        _s_.mu = read(ctx, _s_, 111, ("mu_" * string(_s_.k)))
        _s_.var = read(ctx, _s_, 134, ("var_" * string(_s_.k)))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i = 1
    while (_s_.i <= length(ys))
        _s_.z = read(ctx, _s_, 183, ("z_" * string(_s_.i)))
        _s_.z = min(_s_.z, length(_s_.means))
        score(ctx, _s_, 208, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_w_67(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.w = resample(ctx, _s_, 67, "w", Dirichlet(fill(_s_.δ, _s_.num_clusters)))
    _s_.k = 1
    _s_.means = Float64[]
    _s_.vars = Float64[]
    while (_s_.k <= _s_.num_clusters)
        _s_.mu = read(ctx, _s_, 111, ("mu_" * string(_s_.k)))
        _s_.var = read(ctx, _s_, 134, ("var_" * string(_s_.k)))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i = 1
    while (_s_.i <= length(ys))
        _s_.z = score(ctx, _s_, 183, ("z_" * string(_s_.i)), Categorical(_s_.w))
        _s_.z = min(_s_.z, length(_s_.means))
        read(ctx, _s_, 208, ("y_" * string(_s_.i)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_z__183(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 183, ("z_" * string(_s_.i)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 208, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
end

function gmm_factor(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 111
        return gmm_mu__111(ctx, ys, _s_)
    end
    if _s_.node_id == 49
        return gmm_num_clusters_49(ctx, ys, _s_)
    end
    if _s_.node_id == 134
        return gmm_var__134(ctx, ys, _s_)
    end
    if _s_.node_id == 67
        return gmm_w_67(ctx, ys, _s_)
    end
    if _s_.node_id == 183
        return gmm_z__183(ctx, ys, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return gmm(ctx, ys)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return gmm(ctx, ys, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return gmm_factor(ctx, ys, _s_, _addr_)
end
