
#                       is differentiable   is smc compat
# 1 aircraft.jl                 no              no
# 2 bayesian_network.jl         no              no
# 3 captcha.jl                  no              no
# 4 dirichlet_process.jl        no              yes
# 5 geometric.jl                no              no
# 6 gmm_fixed_numclust.jl       no              yes
# 7 gmm_variable_numclust.jl    no              yes
# 8 hmm.jl                      no              yes
# 9 hurricane.jl                no              no
# 10 lda_fixed_numtopic.jl      no              yes
# 11 lda_variable_numtopic.jl   no              yes
# 12 linear_regression.jl       yes             ~yes
# 13 marsaglia.jl               yes             no
# 14 pcfg.jl                    no              no
# 15 pedestrian.jl              yes             no
# 16 urn.jl                     no              no
# 1 hmm.jl                      no              no

# Poisson
# Categorical
# DiscreteUniform
# Bernoulli

# Dirichlet
# MvNormal

# Normal
# InverseGamma
# Uniform
# Beta

import Distributions
import ForwardDiff

abstract type VaritationalDistribution end
function Base.rand(vd:: VaritationalDistribution)
    error("Not implemented!")
end
function logpdf_and_param_grads(vd:: VaritationalDistribution, val)
    error("Not implemented!")
end


abstract type Transform end

function (::Transform)(x)
    error("Not implemented.")
end
function log_abs_det_jacobian(t::Transform, x)
    error("Not implemented.")
end
function Base.inv(t::Transform)::Transform
    error("Not implemented.")
end

struct IdentityTransform <: Transform
end
function (::IdentityTransform)(x::Real)::Real
    return x
end
function log_abs_det_jacobian(t::IdentityTransform, x::Real)::Real
    return 0.
end
function Base.inv(t::IdentityTransform,)::Transform
    return t
end

struct ExpTransform <: Transform
end
struct LogTransform <: Transform
end
function (::ExpTransform)(x::Real)::Real
    return exp(x)
end
function log_abs_det_jacobian(t::ExpTransform, x::Real)::Real
    return x
end
function Base.inv(t::ExpTransform,)::Transform
    return LogTransform()
end
function (::LogTransform)(x::Real)::Real
    return log(x)
end
function log_abs_det_jacobian(t::LogTransform, x::Real)::Real
    return -log(abs(x))
end
function Base.inv(t::LogTransform,)::Transform
    return ExpTransform()
end
struct SigmoidTransform <: Transform
end
struct InverseSigmoidTransform <: Transform
end
function (::SigmoidTransform)(x::Real)::Real
    return 1 / (1 + exp(-x))
end
function log_abs_det_jacobian(t::SigmoidTransform, x::Real)::Real
    return x - 2 * log1p(exp(x))
end
function Base.inv(t::SigmoidTransform,)::Transform
    return InverseSigmoidTransform()
end
function (::InverseSigmoidTransform)(x::Real)::Real
    return log(x / (1-x))
end
function log_abs_det_jacobian(t::InverseSigmoidTransform, x::Real)::Real
    return -log(abs(x-x^2))
end
function Base.inv(t::InverseSigmoidTransform,)::Transform
    return SigmoidTransform()
end

# https://mc-stan.org/docs/reference-manual/transforms.html#simplex-transform.section
sigmoid(x) = 1 / (1 + exp(-x))
logit(p) = log(p / (1-p))
# unconstrained N dim to simplex N+1 dim
struct StickBreakingTransform <: Transform
end
function (::StickBreakingTransform)(y::AbstractVector{<:Real})::AbstractVector{<:Real}
    k = length(y)+1
    x = Vector{eltype(y)}(undef,k)
    s = 0
    for j in eachindex(y)
        z = sigmoid(y[j] + log(1/(k-j)))
        x[j] = (1-s) * z
        s += x[j]
    end
    x[k] = 1 - s
    return x
end
Base.inv(::StickBreakingTransform) = InverseStickBreakingTransform()
function log_abs_det_jacobian_stick(x::AbstractVector{<:Real}, y::AbstractVector{<:Real})::Real
    k = length(x)-1
    y = y .- log.(k .- (0:k-1))
    return sum(log.(x[1:end-1]) .+ log.(sigmoid.(y)) .- y)
end

function log_abs_det_jacobian(t::StickBreakingTransform, y::AbstractVector{<:Real})::Real
    return log_abs_det_jacobian_stick(t(y), y)
end
struct InverseStickBreakingTransform <: Transform
end
function (::InverseStickBreakingTransform)(x::AbstractVector{<:Real})::AbstractVector{<:Real}
    k = length(x)
    y = Vector{Real}(undef,k-1)
    s = 0.
    for j in 1:k-1
        y[j] = logit(x[j] / (1-s)) - log(1/(k-j))
        s += x[j]
    end
    return y
end
Base.inv(::InverseStickBreakingTransform) = StickBreakingTransform()
function log_abs_det_jacobian(t::InverseStickBreakingTransform, x::AbstractVector{<:Real})::Real
    return -log_abs_det_jacobian_stick(x, t(x))
end
t = StickBreakingTransform()
inv_t = inv(t)
y = zeros(5)
y = randn(5)

x = t(y)
inv_t(x) ≈ y

import LinearAlgebra
log(LinearAlgebra.det(ForwardDiff.jacobian(t, y)[1:end-1,:]))
log(LinearAlgebra.det(ForwardDiff.jacobian(inv_t, x)[:, 1:end-1]))

log_abs_det_jacobian(t, y)
log_abs_det_jacobian(inv_t, x)


# function get_w(theta::AbstractVector{<:Real})
#     k = length(theta)+1
#     w = Vector{Real}(undef,k)
#     s = 0 # sum_{i=1}^{j-1} w[i]
#     for j in eachindex(theta)
#         w[j] = (1-s) * theta[j]
#         s += w[j]
#     end
#     w[k] = 1 - s
#     return w
# end

# function get_theta(w::Vector{Float64})
#     k = length(w)
#     theta = Vector{Real}(undef,k-1)
#     s = 0. # sum_{i=1}^{j-1} x[i]
#     for j in 1:k-1
#         theta[j] = w[j] / (1-s)
#         s += w[j]
#     end
#     return theta
# end

struct DiscreteVD <: VaritationalDistribution
    theta::Vector{Float64}
    support::Vector{Int}
    support_to_ix::Dict{Int,Int}
    function DiscreteVD(support::Vector{Int})
        support_to_ix = Dict{Int,Int}()
        for (i, s) in enumerate(support)
            support_to_ix[s] = i
        end
        return new(zeros(length(support)-1), support, support_to_ix)
    end
end

function Base.rand(vd:: DiscreteVD)
    w = StickBreakingTransform()(vd.theta)
    return vd.support[rand(Distributions.Categorical(w))]
end

function logpdf_and_param_grads(vd:: DiscreteVD, val)
    ix = vd.support_to_ix[val]
    function _logpdf(theta::AbstractVector{<:Real})
        w = StickBreakingTransform()(theta)
        d = Distributions.Categorical(w)
        return Distributions.logpdf(d, ix)
    end
    res = ForwardDiff.gradient(_logpdf, vd.theta)
    return _logpdf(vd.theta), res
end


# vd = DiscreteVD(collect(2:4))
vd = DiscreteVD(collect(0:1))
rand(vd)
StickBreakingTransform()(vd.theta)
for i in vd.support
    println(logpdf_and_param_grads(vd, i))
end

struct ContinuousVD <: VaritationalDistribution
    theta::Vector{Float64}
    transform::Transform
end

function Base.rand(vd::ContinuousVD)
    n = length(vd.theta) ÷ 2
    theta_mu = vd.theta[1:n]
    theta_omega = vd.theta[n+1:end]
    x = exp.(theta_omega) .* randn(n) .+ theta_mu
    return vd.transform.(x)
end

function logpdf_and_param_grads(vd::ContinuousVD, val)
    T_inv = inv(vd.transform)
    xs = T_inv.(val)
    function _logpdf(theta::AbstractVector{<:Real})
        n = length(theta) ÷ 2
        theta_mu = theta[1:n]
        theta_omega = theta[n+1:end]
        return sum(Distributions.logpdf(Distributions.Normal(m, exp(o)), x) + log_abs_det_jacobian(T_inv, x) for (m, o, x) in zip(theta_mu, theta_omega, xs))
    end
    res = ForwardDiff.gradient(_logpdf, vd.theta)
    return _logpdf(vd.theta), res
end

vd = ContinuousVD(zeros(4), SigmoidTransform())
vd = ContinuousVD(zeros(4), ExpTransform())
vd = ContinuousVD(zeros(4), IdentityTransform())
x = rand(vd)
logpdf_and_param_grads(vd, x)



function bbvi_meanfield(n_iter::Int, L::Int, model::Function)

    

end