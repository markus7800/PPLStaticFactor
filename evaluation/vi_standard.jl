
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

# include("ppl.jl")
include("benchmark/generated/gmm_variable_numclust.jl")

import Distributions
import ForwardDiff

abstract type Transform end

function (::Transform)(x)
    error("Not implemented.")
end
function log_abs_det_jacobian(t::Transform, x, y)
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
function log_abs_det_jacobian(t::IdentityTransform, x::Real, y::Real)::Real
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
function log_abs_det_jacobian(t::ExpTransform, x::Real, y::Real)::Real
    return x
end
function Base.inv(t::ExpTransform,)::Transform
    return LogTransform()
end
function (::LogTransform)(x::Real)::Real
    return log(x)
end
function log_abs_det_jacobian(t::LogTransform, x::Real, y::Real)::Real
    return -log(abs(x))
end
function Base.inv(t::LogTransform,)::Transform
    return ExpTransform()
end
struct SigmoidTransform <: Transform
    a::Float64
    b::Float64
end
struct InverseSigmoidTransform <: Transform
    a::Float64
    b::Float64
end
function (t::SigmoidTransform)(x::Real)::Real
    return t.a + (t.b - t.a) / (1 + exp(-x))
end
function log_abs_det_jacobian(t::SigmoidTransform, x::Real, y::Real)::Real
    return log(t.b - t.a) - x - 2 * log1p(exp(-x))
end
function Base.inv(t::SigmoidTransform,)::Transform
    return InverseSigmoidTransform(t.a, t.b)
end
function (t::InverseSigmoidTransform)(x::Real)::Real
    x = (x - t.a) / (t.b - t.a)
    return log(x / (1-x))
end
function log_abs_det_jacobian(t::InverseSigmoidTransform, x::Real, y::Real)::Real
    # return -log(abs(x-x^2))
    return log(t.b - t.a) - log(x - t.a) - log(t.b - x)
end
function Base.inv(t::InverseSigmoidTransform,)::Transform
    return SigmoidTransform(t.a, t.b)
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
function log_abs_det_jacobian(t::StickBreakingTransform, y::AbstractVector{<:Real}, x::AbstractVector{<:Real},)::Real
    return log_abs_det_jacobian_stick(x, y)
end

# simplex N dim to unconstrained N-1 dim 
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
function log_abs_det_jacobian(t::InverseStickBreakingTransform, x::AbstractVector{<:Real}, y::AbstractVector{<:Real},)::Real
    return -log_abs_det_jacobian_stick(x, y)
end

# import LinearAlgebra

# t = SigmoidTransform(2., 4.)
# inv_t = inv(t)
# x = rand()
# y = t(x)
# inv_t(y) ≈ x

# log(LinearAlgebra.det(ForwardDiff.derivative(t, x)))
# log(LinearAlgebra.det(ForwardDiff.derivative(inv_t, y)))

# log_abs_det_jacobian(t, x, y)
# log_abs_det_jacobian(inv_t, y, x)


# t = StickBreakingTransform()
# inv_t = inv(t)
# y = zeros(5)
# y = randn(5)

# x = t(y)
# inv_t(x) ≈ y

# log(LinearAlgebra.det(ForwardDiff.jacobian(t, y)[1:end-1,:]))
# log(LinearAlgebra.det(ForwardDiff.jacobian(inv_t, x)[:, 1:end-1]))

# log_abs_det_jacobian(t, y, x)
# log_abs_det_jacobian(inv_t, x, y)

abstract type VaritationalDistribution end
function Base.rand(vd:: VaritationalDistribution, n::Int)
    error("Not implemented!")
end
function rand_and_logpdf(vd:: VaritationalDistribution)
    error("Not implemented!")
end
function logpdf_param_grads(vd:: VaritationalDistribution, val)::Vector{Float64}
    error("Not implemented!")
end


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

function Base.rand(vd:: DiscreteVD, n::Int)
    w = StickBreakingTransform()(vd.theta)
    d = Distributions.Categorical(w)
    return [vd.support[x] for x in rand(d, n)]
end

function rand_and_logpdf(vd:: DiscreteVD)
    w = StickBreakingTransform()(vd.theta)
    d = Distributions.Categorical(w)
    x = rand(d)
    return vd.support[x], Distributions.logpdf(d, x)
end

function logpdf_param_grads(vd:: DiscreteVD, val)::Vector{Float64}
    ix = vd.support_to_ix[val]
    function _logpdf(theta::AbstractVector{<:Real})
        w = StickBreakingTransform()(theta)
        d = Distributions.Categorical(w)
        return Distributions.logpdf(d, ix)
    end
    return ForwardDiff.gradient(_logpdf, vd.theta)
end


# vd = DiscreteVD(collect(2:4))
# vd = DiscreteVD(collect(0:1))
# rand_and_logpdf(vd)
# StickBreakingTransform()(vd.theta)
# for i in vd.support
#     println(logpdf_param_grads(vd, i))
# end

struct ContinuousVD <: VaritationalDistribution
    theta::Vector{Float64}
    univariate::Bool
    transform::Transform
    elemwise_transform::Bool
    function ContinuousVD(ndim::Int, univariate::Bool, transform::Transform, elemwise_transform::Bool)
        return new(zeros(2*ndim), univariate, transform, elemwise_transform)
    end
end

function Base.rand(vd:: ContinuousVD, n::Int)
    k = length(vd.theta) ÷ 2
    theta_mu = vd.theta[1:k]
    theta_omega = vd.theta[k+1:end]
    if vd.univariate
        ys = Vector{Float64}(undef, n)
        for i in 1:n
            x = (exp.(theta_omega) .* randn(k) .+ theta_mu)[1]
            ys[i] = vd.transform(x)
        end
    else
        x = (exp.(theta_omega) .* randn(k) .+ theta_mu)
        y = vd.elemwise_transform ? vd.transform.(x) : vd.transform(x)

        ys = Array{Float64}(undef, length(y), n)
        for i in 1:n
            xs = (exp.(theta_omega) .* randn(k) .+ theta_mu)
            ys[:, i] = vd.elemwise_transform ? vd.transform.(xs) : vd.transform(xs)
        end
    end
    return ys
end

function rand_and_logpdf(vd::ContinuousVD)
    T_inv = inv(vd.transform)
    n = length(vd.theta) ÷ 2
    theta_mu = vd.theta[1:n]
    theta_omega = vd.theta[n+1:end]
    xs = exp.(theta_omega) .* randn(n) .+ theta_mu
    ys = vd.elemwise_transform ? vd.transform.(xs) : vd.transform(xs)
    ys = vd.univariate ? ys[1] : ys
    if vd.elemwise_transform
        lp = sum(Distributions.logpdf(Distributions.Normal(m, exp(o)), x) + log_abs_det_jacobian(T_inv, y, x) for (m, o, x, y) in zip(theta_mu, theta_omega, xs, ys))
    else
        lp = sum(Distributions.logpdf(Distributions.Normal(m, exp(o)), x) for (m, o, x) in zip(theta_mu, theta_omega, xs)) + log_abs_det_jacobian(T_inv, ys, xs)
    end
    return ys, lp
end

function logpdf_param_grads(vd::ContinuousVD, val)::Vector{Float64}
    T_inv = inv(vd.transform)
    val = vd.univariate ? [val] : val
    xs = vd.elemwise_transform ? T_inv.(val) : T_inv(val)
    function _logpdf(theta::AbstractVector{<:Real})
        n = length(theta) ÷ 2
        theta_mu = theta[1:n]
        theta_omega = theta[n+1:end]
        if vd.elemwise_transform
            return sum(Distributions.logpdf(Distributions.Normal(m, exp(o)), x) + log_abs_det_jacobian(T_inv, y, x) for (m, o, x, y) in zip(theta_mu, theta_omega, xs, val))
        else
            return sum(Distributions.logpdf(Distributions.Normal(m, exp(o)), x) for (m, o, x) in zip(theta_mu, theta_omega, xs)) + log_abs_det_jacobian(T_inv, val, xs)
        end
    end
    return ForwardDiff.gradient(_logpdf, vd.theta)
end

# vd = ContinuousVD(2, true, SigmoidTransform(), true)
# vd = ContinuousVD(2, true, ExpTransform(), true)
# vd = ContinuousVD(2, true, IdentityTransform(), ture)
# x, lp = rand_and_logpdf(vd)
# logpdf_param_grads(vd, x)

function init_vd(d::Distributions.Normal)::VaritationalDistribution
    return ContinuousVD(1, true, IdentityTransform(), true)
end
function init_vd(d::Distributions.InverseGamma)::VaritationalDistribution
    return ContinuousVD(1, true, ExpTransform(), true)
end
function init_vd(d::Distributions.Beta)::VaritationalDistribution
    return ContinuousVD(1, true, SigmoidTransform(0., 1.), true)
end
function init_vd(d::Distributions.Uniform)::VaritationalDistribution
    return ContinuousVD(1, true, SigmoidTransform(d.a, d.b), true)
end

# vd = init_vd(Distributions.Uniform(0,1))
# rand(vd)

function init_vd(d::Distributions.Dirichlet)::VaritationalDistribution
    return ContinuousVD(length(d.alpha)-1, false, StickBreakingTransform(), false)
end

# d = Distributions.Dirichlet(5*ones(5))
# rand(d)
# vd = init_vd(d)
# rand_and_logpdf(vd)

function init_vd(d::Distributions.MvNormal)::VaritationalDistribution
    return ContinuousVD(length(d.μ), false, IdentityTransform(), true)
end

function init_vd(d::Distributions.Poisson)::VaritationalDistribution
    return DiscreteVD(collect(0:10)) # hard coded
end
function init_vd(d::Distributions.Categorical)::VaritationalDistribution
    return DiscreteVD(collect(1:length(d.p)))
end
function init_vd(d::Distributions.DiscreteUniform)::VaritationalDistribution
    return DiscreteVD(collect(d.a : d.b))
end
function init_vd(d::Distributions.Bernoulli)::VaritationalDistribution
    return DiscreteVD([0,1])
end

mutable struct GuideContext <: SampleContext
    vd_store::Dict{String,VaritationalDistribution}
    trace::Dict{String,SampleType}
    elbo::Float64
    function GuideContext(vd_store::Dict{String,VaritationalDistribution})
        return new(vd_store,Dict{String,SampleType}(), 0.)
    end
end

function sample(ctx::GuideContext, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
    if !isnothing(observed)
        value = observed
        ctx.elbo += logpdf(distribution, value)
        return value
    end
    if !haskey(ctx.vd_store, address)
        ctx.vd_store[address] = init_vd(distribution)
    end
    vd = ctx.vd_store[address]
    value, log_q = rand_and_logpdf(vd)
    ctx.elbo += logpdf(distribution, value) - log_q
    ctx.trace[address] = value
    return value
end

function bbvi(n_iter::Int, L::Int, learning_rate::Float64, model::Function)
    vd_store = Dict{String, VaritationalDistribution}()

    eps = 1e-8
    acc = Dict{String, Vector{Float64}}()
    pre = 1.1
    post = 0.9

    avg_grads_var = Dict{String, Vector{Float64}}()
    for i in 1:n_iter
        grads_mean = Dict{String, Vector{Float64}}()
        grads_var = Dict{String, Vector{Float64}}()
        for l in 1:L
            ctx = GuideContext(vd_store)
            model(ctx)

            for (address, value) in ctx.trace
                vd = vd_store[address]
                grads = logpdf_param_grads(vd, value)
                if !haskey(grads_mean, address)
                    grads_mean[address] = zeros(length(grads))
                    grads_var[address] = zeros(length(grads))
                end
                grads_mean[address] = grads_mean[address] + (ctx.elbo .* grads) / L
                # https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#Welford's_online_algorithm
                # compute grad mean and variance
                # new_value = ctx.elbo .* grads
                # old_mean = grads_mean[address]
                # delta1 = new_value .- old_mean
                # new_mean = old_mean .+ delta1 / l
                # delta2 = new_value .- new_mean
                # grads_mean[address] = new_mean
                # grads_var[address] = grads_var[address] .+ delta1 .* delta2
            end 
        end

        # println(grads_mean)

        for (address, v) in grads_var
            grads_var[address] = v / (L - 1)

            grads = grads_mean[address]


            if !haskey(avg_grads_var, address)
                avg_grads_var[address] = zeros(length(grads))
            end
            avg_grads_var[address] = avg_grads_var[address] + v / ((L - 1) * n_iter)
        

            # adagrad update
            acc_addr = get(acc, address, fill(eps,size(grads)))
            acc_addr = post .* acc_addr .+ pre .* grads.^2
            acc[address] = acc_addr
            rho = learning_rate ./ (sqrt.(acc_addr) .+ eps)

            vd_store[address].theta .+= (rho .* grads)
        end

    end

    # println("avg_grads_var")
    # println(avg_grads_var)

    return vd_store
end
