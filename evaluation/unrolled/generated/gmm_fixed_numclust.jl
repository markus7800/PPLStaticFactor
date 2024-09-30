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

function gmm(ctx::AbstractGenerateRecordStateContext, ys::Vector{Float64}, _s_::State)
    _s_.δ::Float64 = 5.0
    _s_.ξ::Float64 = 0.0
    _s_.κ::Float64 = 0.01
    _s_.α::Float64 = 2.0
    _s_.β::Float64 = 10.0
    _s_.w::Vector{Float64} = sample_record_state(ctx, _s_, 49, "w", Dirichlet(fill(_s_.δ, 4)))
    _s_.means::Vector{Float64} = Float64[]
    _s_.vars::Vector{Float64} = Float64[]
    _s_.mu::Float64 = 0.0
    _s_.var::Float64 = 0.0
    _s_.mu = sample_record_state(ctx, _s_, 93, ("mu_" * string(1)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_record_state(ctx, _s_, 114, ("var_" * string(1)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_record_state(ctx, _s_, 142, ("mu_" * string(2)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_record_state(ctx, _s_, 163, ("var_" * string(2)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_record_state(ctx, _s_, 191, ("mu_" * string(3)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_record_state(ctx, _s_, 212, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_record_state(ctx, _s_, 240, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_record_state(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)

    _s_.z::Int = 0
    _s_.z = sample_record_state(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_record_state(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_record_state(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_record_state(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_record_state(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_record_state(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_record_state(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_record_state(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_record_state(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_record_state(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    _ = sample_record_state(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))

end

function gmm_mu__142(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = sample_resample(ctx, _s_, 142, ("mu_" * string(2)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 163, ("var_" * string(2)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 191, ("mu_" * string(3)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 212, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 240, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = sample_read(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_read(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_read(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_read(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_read(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_read(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_read(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_read(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_read(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_read(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_mu__191(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = sample_resample(ctx, _s_, 191, ("mu_" * string(3)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 212, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 240, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = sample_read(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_read(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_read(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_read(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_read(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_read(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_read(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_read(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_read(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_read(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_mu__240(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = sample_resample(ctx, _s_, 240, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = sample_read(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_read(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_read(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_read(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_read(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_read(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_read(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_read(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_read(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_read(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_mu__93(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.mu = sample_resample(ctx, _s_, 93, ("mu_" * string(1)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 114, ("var_" * string(1)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 142, ("mu_" * string(2)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 163, ("var_" * string(2)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 191, ("mu_" * string(3)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 212, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 240, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = sample_read(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_read(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_read(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_read(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_read(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_read(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_read(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_read(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_read(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_read(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_var__114(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.var = sample_resample(ctx, _s_, 114, ("var_" * string(1)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 142, ("mu_" * string(2)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 163, ("var_" * string(2)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 191, ("mu_" * string(3)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 212, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 240, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = sample_read(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_read(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_read(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_read(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_read(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_read(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_read(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_read(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_read(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_read(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_var__163(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.var = sample_resample(ctx, _s_, 163, ("var_" * string(2)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 191, ("mu_" * string(3)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 212, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 240, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = sample_read(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_read(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_read(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_read(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_read(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_read(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_read(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_read(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_read(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_read(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_var__212(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.var = sample_resample(ctx, _s_, 212, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 240, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = sample_read(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_read(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_read(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_read(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_read(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_read(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_read(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_read(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_read(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_read(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_var__261(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.var = sample_resample(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = sample_read(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_read(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_read(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_read(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_read(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_read(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_read(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_read(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_read(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_read(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_w_49(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.w = sample_resample(ctx, _s_, 49, "w", Dirichlet(fill(_s_.δ, 4)))
    _s_.means = Float64[]
    _s_.vars = Float64[]
    _s_.mu = 0.0
    _s_.var = 0.0
    _s_.mu = sample_read(ctx, _s_, 93, ("mu_" * string(1)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 114, ("var_" * string(1)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 142, ("mu_" * string(2)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 163, ("var_" * string(2)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 191, ("mu_" * string(3)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 212, ("var_" * string(3)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.mu = sample_read(ctx, _s_, 240, ("mu_" * string(4)), Normal(_s_.ξ, (1 / sqrt(_s_.κ))))
    _s_.var = sample_read(ctx, _s_, 261, ("var_" * string(4)), InverseGamma(_s_.α, _s_.β))
    _s_.means = vcat(_s_.means, _s_.mu)
    _s_.vars = vcat(_s_.vars, _s_.var)
    _s_.z = 0
    _s_.z = sample_dependency(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_read(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
    _s_.z = sample_dependency(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_read(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
    _s_.z = sample_dependency(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_read(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
    _s_.z = sample_dependency(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_read(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
    _s_.z = sample_dependency(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_read(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
    _s_.z = sample_dependency(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_read(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
    _s_.z = sample_dependency(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_read(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
    _s_.z = sample_dependency(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_read(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
    _s_.z = sample_dependency(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_read(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
    _s_.z = sample_dependency(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
end

function gmm_z__295(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 295, ("z_" * string(1)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 318, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 1))
end

function gmm_z__341(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 341, ("z_" * string(2)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 364, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 2))
end

function gmm_z__387(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 387, ("z_" * string(3)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 410, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 3))
end

function gmm_z__433(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 456, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 4))
end

function gmm_z__479(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 479, ("z_" * string(5)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 502, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 5))
end

function gmm_z__525(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 525, ("z_" * string(6)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 548, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 6))
end

function gmm_z__571(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 571, ("z_" * string(7)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 594, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 7))
end

function gmm_z__617(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 617, ("z_" * string(8)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 640, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 8))
end

function gmm_z__663(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 663, ("z_" * string(9)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 686, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 9))
end

function gmm_z__709(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.z = sample_resample(ctx, _s_, 709, ("z_" * string(10)), Categorical(_s_.w))
    _s_.z = min(_s_.z, length(_s_.means))
    sample_dependency(ctx, _s_, 732, "y_", Normal(get_n(_s_.means, _s_.z), get_n(_s_.vars, _s_.z)), observed = get_n(ys, 10))
end

function gmm_factor(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 142
        return gmm_mu__142(ctx, ys, _s_)
    end
    if _s_.node_id == 191
        return gmm_mu__191(ctx, ys, _s_)
    end
    if _s_.node_id == 240
        return gmm_mu__240(ctx, ys, _s_)
    end
    if _s_.node_id == 93
        return gmm_mu__93(ctx, ys, _s_)
    end
    if _s_.node_id == 114
        return gmm_var__114(ctx, ys, _s_)
    end
    if _s_.node_id == 163
        return gmm_var__163(ctx, ys, _s_)
    end
    if _s_.node_id == 212
        return gmm_var__212(ctx, ys, _s_)
    end
    if _s_.node_id == 261
        return gmm_var__261(ctx, ys, _s_)
    end
    if _s_.node_id == 49
        return gmm_w_49(ctx, ys, _s_)
    end
    if _s_.node_id == 295
        return gmm_z__295(ctx, ys, _s_)
    end
    if _s_.node_id == 341
        return gmm_z__341(ctx, ys, _s_)
    end
    if _s_.node_id == 387
        return gmm_z__387(ctx, ys, _s_)
    end
    if _s_.node_id == 433
        return gmm_z__433(ctx, ys, _s_)
    end
    if _s_.node_id == 479
        return gmm_z__479(ctx, ys, _s_)
    end
    if _s_.node_id == 525
        return gmm_z__525(ctx, ys, _s_)
    end
    if _s_.node_id == 571
        return gmm_z__571(ctx, ys, _s_)
    end
    if _s_.node_id == 617
        return gmm_z__617(ctx, ys, _s_)
    end
    if _s_.node_id == 663
        return gmm_z__663(ctx, ys, _s_)
    end
    if _s_.node_id == 709
        return gmm_z__709(ctx, ys, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return gmm(ctx, ys)
end

function model(ctx::AbstractGenerateRecordStateContext, _s_::State)
    return gmm(ctx, ys, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return gmm_factor(ctx, ys, _s_, _addr_)
end
