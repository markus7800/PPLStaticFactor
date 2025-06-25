# this file is auto-generated

include("../dirichlet_process.jl")

mutable struct State <: AbstractState
    node_id:: Int
    alpha::Float64
    beta::Float64
    cumprod::Float64
    i::Int
    j::Int
    stick::Float64
    theta::Float64
    thetas::Vector{Float64}
    weights::Vector{Float64}
    z::Int
    function State()
        return new(
            0,
            zero(Float64),
            zero(Float64),
            zero(Float64),
            zero(Int),
            zero(Int),
            zero(Float64),
            zero(Float64),
            zero(Vector{Float64}),
            zero(Vector{Float64}),
            zero(Int),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.alpha = _s_.alpha
    dst.beta = _s_.beta
    dst.cumprod = _s_.cumprod
    dst.i = _s_.i
    dst.j = _s_.j
    dst.stick = _s_.stick
    dst.theta = _s_.theta
    dst.thetas = _s_.thetas
    dst.weights = _s_.weights
    dst.z = _s_.z
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function dp(ctx::AbstractSampleRecordStateContext, xs::Vector{Float64}, _s_::State)
    _s_.alpha::Float64 = 5.0
    _s_.stick::Float64 = 1.0
    _s_.beta::Float64 = 0.0
    _s_.cumprod::Float64 = 1.0
    _s_.weights::Vector{Float64} = Float64[]
    _s_.thetas::Vector{Float64} = Float64[]
    _s_.i::Int = 0
    while (_s_.stick > 0.01)
        _s_.i = (_s_.i + 1)
        _s_.cumprod = (_s_.cumprod * (1.0 - _s_.beta))
        _s_.beta = sample_record_state(ctx, _s_, 89, ("beta_" * string(_s_.i)), Beta(1, _s_.alpha))
        _s_.theta::Float64 = sample_record_state(ctx, _s_, 105, ("theta_" * string(_s_.i)), Normal(0.0, 1.0))
        _s_.stick = (_s_.stick - (_s_.beta * _s_.cumprod))
        _s_.weights = vcat(_s_.weights, (_s_.beta * _s_.cumprod))
        _s_.thetas = vcat(_s_.thetas, _s_.theta)
    end
    _s_.j::Int = 1
    while (_s_.j <= length(xs))
        _s_.z::Int = sample_record_state(ctx, _s_, 160, ("z_" * string(_s_.j)), Categorical((_s_.weights / sum(_s_.weights))))
        _s_.z = min(_s_.z, length(_s_.thetas))
        _ = sample_record_state(ctx, _s_, 190, ("x_" * string(_s_.j)), Normal(get_n(_s_.thetas, _s_.z), 0.1), observed = get_n(xs, _s_.j))
        _s_.j = (_s_.j + 1)
    end
end

function dp_beta__89(ctx::AbstractFactorRevisitContext, xs::Vector{Float64}, _s_::State)
    _s_.beta = revisit(ctx, _s_, 89, ("beta_" * string(_s_.i)), Beta(1, _s_.alpha))
    _s_.theta = score(ctx, _s_, 105, ("theta_" * string(_s_.i)), Normal(0.0, 1.0))
    _s_.stick = (_s_.stick - (_s_.beta * _s_.cumprod))
    _s_.weights = vcat(_s_.weights, (_s_.beta * _s_.cumprod))
    _s_.thetas = vcat(_s_.thetas, _s_.theta)
    while (_s_.stick > 0.01)
        _s_.i = (_s_.i + 1)
        _s_.cumprod = (_s_.cumprod * (1.0 - _s_.beta))
        _s_.beta = score(ctx, _s_, 89, ("beta_" * string(_s_.i)), Beta(1, _s_.alpha))
        _s_.theta = score(ctx, _s_, 105, ("theta_" * string(_s_.i)), Normal(0.0, 1.0))
        _s_.stick = (_s_.stick - (_s_.beta * _s_.cumprod))
        _s_.weights = vcat(_s_.weights, (_s_.beta * _s_.cumprod))
        _s_.thetas = vcat(_s_.thetas, _s_.theta)
    end
    _s_.j = 1
    while (_s_.j <= length(xs))
        _s_.z = score(ctx, _s_, 160, ("z_" * string(_s_.j)), Categorical((_s_.weights / sum(_s_.weights))))
        _s_.z = min(_s_.z, length(_s_.thetas))
        score(ctx, _s_, 190, ("x_" * string(_s_.j)), Normal(get_n(_s_.thetas, _s_.z), 0.1), observed = get_n(xs, _s_.j))
        _s_.j = (_s_.j + 1)
    end
end

function dp_theta__105(ctx::AbstractFactorRevisitContext, xs::Vector{Float64}, _s_::State)
    _s_.theta = revisit(ctx, _s_, 105, ("theta_" * string(_s_.i)), Normal(0.0, 1.0))
    _s_.stick = (_s_.stick - (_s_.beta * _s_.cumprod))
    _s_.weights = vcat(_s_.weights, (_s_.beta * _s_.cumprod))
    _s_.thetas = vcat(_s_.thetas, _s_.theta)
    while (_s_.stick > 0.01)
        _s_.i = (_s_.i + 1)
        _s_.cumprod = (_s_.cumprod * (1.0 - _s_.beta))
        _s_.beta = read_trace(ctx, _s_, 89, ("beta_" * string(_s_.i)))
        _s_.theta = read_trace(ctx, _s_, 105, ("theta_" * string(_s_.i)))
        _s_.stick = (_s_.stick - (_s_.beta * _s_.cumprod))
        _s_.weights = vcat(_s_.weights, (_s_.beta * _s_.cumprod))
        _s_.thetas = vcat(_s_.thetas, _s_.theta)
    end
    _s_.j = 1
    while (_s_.j <= length(xs))
        _s_.z = read_trace(ctx, _s_, 160, ("z_" * string(_s_.j)))
        _s_.z = min(_s_.z, length(_s_.thetas))
        score(ctx, _s_, 190, ("x_" * string(_s_.j)), Normal(get_n(_s_.thetas, _s_.z), 0.1), observed = get_n(xs, _s_.j))
        _s_.j = (_s_.j + 1)
    end
end

function dp_z__160(ctx::AbstractFactorRevisitContext, xs::Vector{Float64}, _s_::State)
    _s_.z = revisit(ctx, _s_, 160, ("z_" * string(_s_.j)), Categorical((_s_.weights / sum(_s_.weights))))
    _s_.z = min(_s_.z, length(_s_.thetas))
    score(ctx, _s_, 190, ("x_" * string(_s_.j)), Normal(get_n(_s_.thetas, _s_.z), 0.1), observed = get_n(xs, _s_.j))
end

function dp_factor(ctx::AbstractFactorRevisitContext, xs::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 89
        return dp_beta__89(ctx, xs, _s_)
    end
    if _s_.node_id == 105
        return dp_theta__105(ctx, xs, _s_)
    end
    if _s_.node_id == 160
        return dp_z__160(ctx, xs, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function dp___start__(ctx::AbstractFactorResumeContext, xs::Vector{Float64}, _s_::State)
    _s_.alpha = 5.0
    _s_.stick = 1.0
    _s_.beta = 0.0
    _s_.cumprod = 1.0
    _s_.weights = Float64[]
    _s_.thetas = Float64[]
    _s_.i = 0
    while (_s_.stick > 0.01)
        _s_.i = (_s_.i + 1)
        _s_.cumprod = (_s_.cumprod * (1.0 - _s_.beta))
        _s_.beta = score(ctx, _s_, 89, ("beta_" * string(_s_.i)), Beta(1, _s_.alpha))
        _s_.theta = score(ctx, _s_, 105, ("theta_" * string(_s_.i)), Normal(0.0, 1.0))
        _s_.stick = (_s_.stick - (_s_.beta * _s_.cumprod))
        _s_.weights = vcat(_s_.weights, (_s_.beta * _s_.cumprod))
        _s_.thetas = vcat(_s_.thetas, _s_.theta)
    end
    _s_.j = 1
    while (_s_.j <= length(xs))
        _s_.z = score(ctx, _s_, 160, ("z_" * string(_s_.j)), Categorical((_s_.weights / sum(_s_.weights))))
        _s_.z = min(_s_.z, length(_s_.thetas))
        score(ctx, _s_, 190, ("x_" * string(_s_.j)), Normal(get_n(_s_.thetas, _s_.z), 0.1), observed = get_n(xs, _s_.j))
        return
    end
    _s_.node_id = -1
    return
end

function dp_x__190(ctx::AbstractFactorResumeContext, xs::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 190, ("x_" * string(_s_.j)), observed = get_n(xs, _s_.j))
    _s_.j = (_s_.j + 1)
    while (_s_.j <= length(xs))
        _s_.z = score(ctx, _s_, 160, ("z_" * string(_s_.j)), Categorical((_s_.weights / sum(_s_.weights))))
        _s_.z = min(_s_.z, length(_s_.thetas))
        score(ctx, _s_, 190, ("x_" * string(_s_.j)), Normal(get_n(_s_.thetas, _s_.z), 0.1), observed = get_n(xs, _s_.j))
        return
    end
    _s_.node_id = -1
    return
end

function dp_resume(ctx::AbstractFactorResumeContext, xs::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 0
        return dp___start__(ctx, xs, _s_)
    end
    if _s_.node_id == 190
        return dp_x__190(ctx, xs, _s_)
    end
    _s_.node_id = -1 # marks termination
end

function model(ctx::SampleContext)
    return dp(ctx, xs)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return dp(ctx, xs, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return dp_factor(ctx, xs, _s_, _addr_)
end

function resume_from_state(ctx::AbstractFactorResumeContext, _s_::State, _addr_::String)
    return dp_resume(ctx, xs, _s_, _addr_)
end

