# this file is auto-generated

include("../gmm_fixed_numclust.jl")

mutable struct State <: AbstractState
    node_id:: Int
    means::Vector{Float64}
    mu::Float64
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
            zero(Vector{Float64}),
            zero(Float64),
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
    dst.means = _s_.means
    dst.mu = _s_.mu
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
    _s_.w::Vector{Float64} = sample_record_state(ctx, _s_, 56, "w", Dirichlet(fill(_s_.δ, 4)))
    _s_.means::Vector{Float64} = Float64[]
    _s_.vars::Vector{Float64} = Float64[]
    _s_.mu::Float64 = 0.0
    _s_.var::Float64 = 0.0
    _s_.mu = sample_record_state(ctx, _s_, 100, ("mu_" * string(1)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_record_state(ctx, _s_, 121, ("var_" * string(1)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_record_state(ctx, _s_, 149, ("mu_" * string(2)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_record_state(ctx, _s_, 170, ("var_" * string(2)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_record_state(ctx, _s_, 198, ("mu_" * string(3)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_record_state(ctx, _s_, 219, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_record_state(ctx, _s_, 247, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_record_state(ctx, _s_, 268, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)

    _s_.z::Int = 0
    _s_.z = sample_record_state(ctx, _s_, 302, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_record_state(ctx, _s_, 348, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_record_state(ctx, _s_, 394, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_record_state(ctx, _s_, 440, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_record_state(ctx, _s_, 486, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_record_state(ctx, _s_, 532, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_record_state(ctx, _s_, 578, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_record_state(ctx, _s_, 624, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_record_state(ctx, _s_, 670, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_record_state(ctx, _s_, 716, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))

end

function gmm_mu__100(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = resample(ctx, _s_, 100, ("mu_" * string(1)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = read(ctx, _s_, 121, ("var_" * string(1)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 149, ("mu_" * string(2)))
    _s_.var = read(ctx, _s_, 170, ("var_" * string(2)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 198, ("mu_" * string(3)))
    _s_.var = read(ctx, _s_, 219, ("var_" * string(3)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 247, ("mu_" * string(4)))
    _s_.var = read(ctx, _s_, 268, ("var_" * string(4)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = read(ctx, _s_, 302, ("z_" * string(1)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = read(ctx, _s_, 348, ("z_" * string(2)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = read(ctx, _s_, 394, ("z_" * string(3)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = read(ctx, _s_, 440, ("z_" * string(4)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = read(ctx, _s_, 486, ("z_" * string(5)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = read(ctx, _s_, 532, ("z_" * string(6)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = read(ctx, _s_, 578, ("z_" * string(7)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = read(ctx, _s_, 624, ("z_" * string(8)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = read(ctx, _s_, 670, ("z_" * string(9)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = read(ctx, _s_, 716, ("z_" * string(10)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_mu__149(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = resample(ctx, _s_, 149, ("mu_" * string(2)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = read(ctx, _s_, 170, ("var_" * string(2)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 198, ("mu_" * string(3)))
    _s_.var = read(ctx, _s_, 219, ("var_" * string(3)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 247, ("mu_" * string(4)))
    _s_.var = read(ctx, _s_, 268, ("var_" * string(4)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = read(ctx, _s_, 302, ("z_" * string(1)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = read(ctx, _s_, 348, ("z_" * string(2)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = read(ctx, _s_, 394, ("z_" * string(3)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = read(ctx, _s_, 440, ("z_" * string(4)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = read(ctx, _s_, 486, ("z_" * string(5)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = read(ctx, _s_, 532, ("z_" * string(6)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = read(ctx, _s_, 578, ("z_" * string(7)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = read(ctx, _s_, 624, ("z_" * string(8)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = read(ctx, _s_, 670, ("z_" * string(9)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = read(ctx, _s_, 716, ("z_" * string(10)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_mu__198(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = resample(ctx, _s_, 198, ("mu_" * string(3)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = read(ctx, _s_, 219, ("var_" * string(3)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 247, ("mu_" * string(4)))
    _s_.var = read(ctx, _s_, 268, ("var_" * string(4)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = read(ctx, _s_, 302, ("z_" * string(1)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = read(ctx, _s_, 348, ("z_" * string(2)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = read(ctx, _s_, 394, ("z_" * string(3)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = read(ctx, _s_, 440, ("z_" * string(4)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = read(ctx, _s_, 486, ("z_" * string(5)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = read(ctx, _s_, 532, ("z_" * string(6)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = read(ctx, _s_, 578, ("z_" * string(7)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = read(ctx, _s_, 624, ("z_" * string(8)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = read(ctx, _s_, 670, ("z_" * string(9)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = read(ctx, _s_, 716, ("z_" * string(10)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_mu__247(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = resample(ctx, _s_, 247, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = read(ctx, _s_, 268, ("var_" * string(4)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = read(ctx, _s_, 302, ("z_" * string(1)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = read(ctx, _s_, 348, ("z_" * string(2)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = read(ctx, _s_, 394, ("z_" * string(3)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = read(ctx, _s_, 440, ("z_" * string(4)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = read(ctx, _s_, 486, ("z_" * string(5)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = read(ctx, _s_, 532, ("z_" * string(6)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = read(ctx, _s_, 578, ("z_" * string(7)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = read(ctx, _s_, 624, ("z_" * string(8)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = read(ctx, _s_, 670, ("z_" * string(9)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = read(ctx, _s_, 716, ("z_" * string(10)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_var__121(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.var = resample(ctx, _s_, 121, ("var_" * string(1)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 149, ("mu_" * string(2)))
    _s_.var = read(ctx, _s_, 170, ("var_" * string(2)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 198, ("mu_" * string(3)))
    _s_.var = read(ctx, _s_, 219, ("var_" * string(3)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 247, ("mu_" * string(4)))
    _s_.var = read(ctx, _s_, 268, ("var_" * string(4)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = read(ctx, _s_, 302, ("z_" * string(1)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = read(ctx, _s_, 348, ("z_" * string(2)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = read(ctx, _s_, 394, ("z_" * string(3)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = read(ctx, _s_, 440, ("z_" * string(4)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = read(ctx, _s_, 486, ("z_" * string(5)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = read(ctx, _s_, 532, ("z_" * string(6)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = read(ctx, _s_, 578, ("z_" * string(7)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = read(ctx, _s_, 624, ("z_" * string(8)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = read(ctx, _s_, 670, ("z_" * string(9)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = read(ctx, _s_, 716, ("z_" * string(10)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_var__170(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.var = resample(ctx, _s_, 170, ("var_" * string(2)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 198, ("mu_" * string(3)))
    _s_.var = read(ctx, _s_, 219, ("var_" * string(3)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 247, ("mu_" * string(4)))
    _s_.var = read(ctx, _s_, 268, ("var_" * string(4)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = read(ctx, _s_, 302, ("z_" * string(1)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = read(ctx, _s_, 348, ("z_" * string(2)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = read(ctx, _s_, 394, ("z_" * string(3)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = read(ctx, _s_, 440, ("z_" * string(4)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = read(ctx, _s_, 486, ("z_" * string(5)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = read(ctx, _s_, 532, ("z_" * string(6)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = read(ctx, _s_, 578, ("z_" * string(7)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = read(ctx, _s_, 624, ("z_" * string(8)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = read(ctx, _s_, 670, ("z_" * string(9)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = read(ctx, _s_, 716, ("z_" * string(10)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_var__219(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.var = resample(ctx, _s_, 219, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 247, ("mu_" * string(4)))
    _s_.var = read(ctx, _s_, 268, ("var_" * string(4)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = read(ctx, _s_, 302, ("z_" * string(1)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = read(ctx, _s_, 348, ("z_" * string(2)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = read(ctx, _s_, 394, ("z_" * string(3)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = read(ctx, _s_, 440, ("z_" * string(4)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = read(ctx, _s_, 486, ("z_" * string(5)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = read(ctx, _s_, 532, ("z_" * string(6)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = read(ctx, _s_, 578, ("z_" * string(7)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = read(ctx, _s_, 624, ("z_" * string(8)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = read(ctx, _s_, 670, ("z_" * string(9)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = read(ctx, _s_, 716, ("z_" * string(10)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_var__268(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.var = resample(ctx, _s_, 268, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = read(ctx, _s_, 302, ("z_" * string(1)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = read(ctx, _s_, 348, ("z_" * string(2)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = read(ctx, _s_, 394, ("z_" * string(3)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = read(ctx, _s_, 440, ("z_" * string(4)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = read(ctx, _s_, 486, ("z_" * string(5)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = read(ctx, _s_, 532, ("z_" * string(6)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = read(ctx, _s_, 578, ("z_" * string(7)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = read(ctx, _s_, 624, ("z_" * string(8)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = read(ctx, _s_, 670, ("z_" * string(9)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = read(ctx, _s_, 716, ("z_" * string(10)))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_w_56(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.w = resample(ctx, _s_, 56, "w", Dirichlet(fill(_s_.δ, 4)))
    _s_.means = Float64[]
    _s_.vars = Float64[]
    _s_.mu = 0.0
    _s_.var = 0.0
    _s_.mu = read(ctx, _s_, 100, ("mu_" * string(1)))
    _s_.var = read(ctx, _s_, 121, ("var_" * string(1)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 149, ("mu_" * string(2)))
    _s_.var = read(ctx, _s_, 170, ("var_" * string(2)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 198, ("mu_" * string(3)))
    _s_.var = read(ctx, _s_, 219, ("var_" * string(3)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = read(ctx, _s_, 247, ("mu_" * string(4)))
    _s_.var = read(ctx, _s_, 268, ("var_" * string(4)))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = score(ctx, _s_, 302, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    read(ctx, _s_, 325, "y_", observed = get_n(ys, 1))
    _s_.z = score(ctx, _s_, 348, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    read(ctx, _s_, 371, "y_", observed = get_n(ys, 2))
    _s_.z = score(ctx, _s_, 394, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    read(ctx, _s_, 417, "y_", observed = get_n(ys, 3))
    _s_.z = score(ctx, _s_, 440, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    read(ctx, _s_, 463, "y_", observed = get_n(ys, 4))
    _s_.z = score(ctx, _s_, 486, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    read(ctx, _s_, 509, "y_", observed = get_n(ys, 5))
    _s_.z = score(ctx, _s_, 532, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    read(ctx, _s_, 555, "y_", observed = get_n(ys, 6))
    _s_.z = score(ctx, _s_, 578, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    read(ctx, _s_, 601, "y_", observed = get_n(ys, 7))
    _s_.z = score(ctx, _s_, 624, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    read(ctx, _s_, 647, "y_", observed = get_n(ys, 8))
    _s_.z = score(ctx, _s_, 670, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    read(ctx, _s_, 693, "y_", observed = get_n(ys, 9))
    _s_.z = score(ctx, _s_, 716, ("z_" * string(10)), Categorical(_s_.w))
end

function gmm_z__302(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 302, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 325, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
end

function gmm_z__348(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 348, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 371, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
end

function gmm_z__394(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 394, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 417, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
end

function gmm_z__440(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 440, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 463, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
end

function gmm_z__486(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 486, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 509, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
end

function gmm_z__532(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 532, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 555, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
end

function gmm_z__578(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 578, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 601, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
end

function gmm_z__624(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 624, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 647, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
end

function gmm_z__670(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 670, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 693, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
end

function gmm_z__716(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = resample(ctx, _s_, 716, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    score(ctx, _s_, 739, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_factor(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 100
        return gmm_mu__100(ctx, ys, _s_)
    end
    if _s_.node_id == 149
        return gmm_mu__149(ctx, ys, _s_)
    end
    if _s_.node_id == 198
        return gmm_mu__198(ctx, ys, _s_)
    end
    if _s_.node_id == 247
        return gmm_mu__247(ctx, ys, _s_)
    end
    if _s_.node_id == 121
        return gmm_var__121(ctx, ys, _s_)
    end
    if _s_.node_id == 170
        return gmm_var__170(ctx, ys, _s_)
    end
    if _s_.node_id == 219
        return gmm_var__219(ctx, ys, _s_)
    end
    if _s_.node_id == 268
        return gmm_var__268(ctx, ys, _s_)
    end
    if _s_.node_id == 56
        return gmm_w_56(ctx, ys, _s_)
    end
    if _s_.node_id == 302
        return gmm_z__302(ctx, ys, _s_)
    end
    if _s_.node_id == 348
        return gmm_z__348(ctx, ys, _s_)
    end
    if _s_.node_id == 394
        return gmm_z__394(ctx, ys, _s_)
    end
    if _s_.node_id == 440
        return gmm_z__440(ctx, ys, _s_)
    end
    if _s_.node_id == 486
        return gmm_z__486(ctx, ys, _s_)
    end
    if _s_.node_id == 532
        return gmm_z__532(ctx, ys, _s_)
    end
    if _s_.node_id == 578
        return gmm_z__578(ctx, ys, _s_)
    end
    if _s_.node_id == 624
        return gmm_z__624(ctx, ys, _s_)
    end
    if _s_.node_id == 670
        return gmm_z__670(ctx, ys, _s_)
    end
    if _s_.node_id == 716
        return gmm_z__716(ctx, ys, _s_)
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
