# source: https://github.com/fzaiser/nonparametric-hmc/
# Carol Mak, Fabian Zaiser, Luke Ong. Nonparametric Hamiltonian Monte Carlo. ICML 2021

include("../ppl.jl")

modelname = "dirichlet_process"
proposers = Dict{String, Distribution}()

@model function dp(ctx::SampleContext, xs::Vector{Float64})
    alpha::Float64 = 5.0
    stick::Float64 = 1.0
    beta::Float64 = 0.0
    cumprod::Float64 = 1.0

    weights::Vector{Float64} = Float64[]
    thetas::Vector{Float64} = Float64[]
    i::Int = 0
    while stick > 0.01
        i = i + 1
        cumprod = cumprod * (1. - beta)
        beta = sample(ctx, "beta_" * string(i), Beta(1,alpha)) 
        theta::Float64 = sample(ctx, "theta_" * string(i), Normal(0.,1.))
        stick = stick - beta * cumprod

        weights = vcat(weights, beta * cumprod)
        thetas = vcat(thetas, theta)
    end

    j::Int = 1
    while j <= length(xs)
        z::Int = sample(ctx, "z_" * string(j), Categorical(weights / sum(weights)))
        z = min(z, length(thetas))
        sample(ctx, "x_" * string(j), Normal(get_n(thetas, z), 0.1); observed=get_n(xs,j))
        j = j + 1
    end
end

means = [0.76, 0.30, 0.89, 0.34, 0.16, 0.69, 0.28, 0.39, 0.55]
zs = [7, 8, 5, 7, 4, 6, 3, 3, 6, 1, 3, 1, 3, 1, 4, 3, 4, 4, 8, 8, 5, 7, 8, 4, 5, 9, 5, 3, 2, 1, 7, 6, 2, 4, 5, 8, 2, 8, 3, 3, 1, 7, 1, 7, 4, 9, 2, 3, 8, 3]
xs = [0.42, 0.29, -0.01, 0.37, 0.23, 0.54, 0.95, 0.9, 0.48, 0.82, 0.88, 0.61, 0.83, 0.56, 0.42, 0.83, 0.36, 0.41, 0.51, 0.39, 0.06, 0.23, 0.4, 0.33, 0.23, 0.49, 0.13, 1.06, 0.22, 0.65, 0.25, 0.6, 0.25, 0.28, 0.23, 0.45, 0.34, 0.29, 0.88, 0.83, 0.81, 0.27, 0.72, 0.27, 0.43, 0.51, 0.35, 0.91, 0.31, 0.83]
