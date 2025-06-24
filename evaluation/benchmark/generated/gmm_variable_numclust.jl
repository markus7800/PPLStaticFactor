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

function gmm(ctx::AbstractSampleRecordStateContext, ys::Vector{Float64}, _s_::State)
    _s_.δ::Float64 = 5.0
    _s_.ξ::Float64 = 0.0
    _s_.κ::Float64 = 0.01
    _s_.α::Float64 = 2.0
    _s_.β::Float64 = 10.0
    _s_.num_clusters::Int = sample_record_state(ctx, _s_, 52, "num_clusters", Poisson(3.0))
    _s_.num_clusters = (_s_.num_clusters + 1)
    _s_.w::Vector{Float64} = sample_record_state(ctx, _s_, 70, "w", Dirichlet(fill(_s_.δ, _s_.num_clusters)))
    _s_.k::Int = 1
    _s_.means::Vector{Float64} = Float64[]
    _s_.vars::Vector{Float64} = Float64[]
    while (_s_.k <= _s_.num_clusters)
        _s_.mu::Float64 = sample_record_state(ctx, _s_, 114, ("mu_" * string(_s_.k)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
        _s_.var::Float64 = sample_record_state(ctx, _s_, 137, ("var_" * string(_s_.k)), InverseGamma(_s_.α, _s_.β))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i::Int = 1
    while (_s_.i <= length(ys))
        _s_.z::Int = sample_record_state(ctx, _s_, 186, ("z_" * string(_s_.i)), Categorical(_s_.w))
        _s_.z = min(_s_.z, length(_s_.means))
        _ = sample_record_state(ctx, _s_, 211, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_mu__114(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = revisit(ctx, _s_, 114, ("mu_" * string(_s_.k)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = read(ctx, _s_, 137, ("var_" * string(_s_.k)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.k = (_s_.k + 1)
    while (_s_.k <= _s_.num_clusters)
        _s_.mu = read(ctx, _s_, 114, ("mu_" * string(_s_.k)))
        _s_.var = read(ctx, _s_, 137, ("var_" * string(_s_.k)))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i = 1
    while (_s_.i <= length(ys))
        _s_.z = read(ctx, _s_, 186, ("z_" * string(_s_.i)))
        _s_.z = min(_s_.z, length(_s_.means))
        score(ctx, _s_, 211, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_num_clusters_52(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.num_clusters = revisit(ctx, _s_, 52, "num_clusters", Poisson(3.0))
    _s_.num_clusters = (_s_.num_clusters + 1)
    _s_.w = score(ctx, _s_, 70, "w", Dirichlet(fill(_s_.δ, _s_.num_clusters)))
    _s_.k = 1
    _s_.means = Float64[]
    _s_.vars = Float64[]
    while (_s_.k <= _s_.num_clusters)
        _s_.mu = score(ctx, _s_, 114, ("mu_" * string(_s_.k)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
        _s_.var = score(ctx, _s_, 137, ("var_" * string(_s_.k)), InverseGamma(_s_.α, _s_.β))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i = 1
    while (_s_.i <= length(ys))
        _s_.z = score(ctx, _s_, 186, ("z_" * string(_s_.i)), Categorical(_s_.w))
        _s_.z = min(_s_.z, length(_s_.means))
        score(ctx, _s_, 211, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_var__137(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.var = revisit(ctx, _s_, 137, ("var_" * string(_s_.k)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.k = (_s_.k + 1)
    while (_s_.k <= _s_.num_clusters)
        _s_.mu = read(ctx, _s_, 114, ("mu_" * string(_s_.k)))
        _s_.var = read(ctx, _s_, 137, ("var_" * string(_s_.k)))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i = 1
    while (_s_.i <= length(ys))
        _s_.z = read(ctx, _s_, 186, ("z_" * string(_s_.i)))
        _s_.z = min(_s_.z, length(_s_.means))
        score(ctx, _s_, 211, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_w_70(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.w = revisit(ctx, _s_, 70, "w", Dirichlet(fill(_s_.δ, _s_.num_clusters)))
    _s_.k = 1
    _s_.means = Float64[]
    _s_.vars = Float64[]
    while (_s_.k <= _s_.num_clusters)
        _s_.mu = read(ctx, _s_, 114, ("mu_" * string(_s_.k)))
        _s_.var = read(ctx, _s_, 137, ("var_" * string(_s_.k)))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i = 1
    while (_s_.i <= length(ys))
        _s_.z = score(ctx, _s_, 186, ("z_" * string(_s_.i)), Categorical(_s_.w))
        _s_.z = min(_s_.z, length(_s_.means))
        read(ctx, _s_, 211, ("y_" * string(_s_.i)), observed = get_n(ys, _s_.i))
        _s_.i = (_s_.i + 1)
    end
end

function gmm_z__186(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.z = revisit(ctx, _s_, 186, ("z_" * string(_s_.i)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 211, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
end

function gmm_factor(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 114
        return gmm_mu__114(ctx, ys, _s_)
    end
    if _s_.node_id == 52
        return gmm_num_clusters_52(ctx, ys, _s_)
    end
    if _s_.node_id == 137
        return gmm_var__137(ctx, ys, _s_)
    end
    if _s_.node_id == 70
        return gmm_w_70(ctx, ys, _s_)
    end
    if _s_.node_id == 186
        return gmm_z__186(ctx, ys, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function gmm___start__(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    _s_.δ = 5.0
    _s_.ξ = 0.0
    _s_.κ = 0.01
    _s_.α = 2.0
    _s_.β = 10.0
    _s_.num_clusters = score(ctx, _s_, 52, "num_clusters", Poisson(3.0))
    _s_.num_clusters = (_s_.num_clusters + 1)
    _s_.w = score(ctx, _s_, 70, "w", Dirichlet(fill(_s_.δ, _s_.num_clusters)))
    _s_.k = 1
    _s_.means = Float64[]
    _s_.vars = Float64[]
    while (_s_.k <= _s_.num_clusters)
        _s_.mu = score(ctx, _s_, 114, ("mu_" * string(_s_.k)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
        _s_.var = score(ctx, _s_, 137, ("var_" * string(_s_.k)), InverseGamma(_s_.α, _s_.β))
        _s_.means = vcat(_s_.means, _s_.mu)
        _s_.vars = vcat(_s_.vars, _s_.var)
        _s_.k = (_s_.k + 1)
    end
    _s_.i = 1
    while (_s_.i <= length(ys))
        _s_.z = score(ctx, _s_, 186, ("z_" * string(_s_.i)), Categorical(_s_.w))
        _s_.z = min(_s_.z, length(_s_.means))
        score(ctx, _s_, 211, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        return
    end
    _s_.node_id = -1
    return
end

function gmm_y__211(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    resume(ctx, _s_, 211, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
    _s_.i = (_s_.i + 1)
    while (_s_.i <= length(ys))
        _s_.z = score(ctx, _s_, 186, ("z_" * string(_s_.i)), Categorical(_s_.w))
        _s_.z = min(_s_.z, length(_s_.means))
        score(ctx, _s_, 211, ("y_" * string(_s_.i)), Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, _s_.i))
        return
    end
    _s_.node_id = -1
    return
end

function gmm_resume(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 0
        return gmm___start__(ctx, ys, _s_)
    end
    if _s_.node_id == 211
        return gmm_y__211(ctx, ys, _s_)
    end
    _s_.node_id = -1 # marks termination
end

function model(ctx::SampleContext)
    return gmm(ctx, ys)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return gmm(ctx, ys, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return gmm_factor(ctx, ys, _s_, _addr_)
end

function resume_from_state(ctx::AbstractFactorResumeContext, _s_::State, _addr_::String)
    return gmm_resume(ctx, ys, _s_, _addr_)
end

