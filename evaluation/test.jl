include("vi_standard.jl")
import StatsPlots


Random.seed!(0)
bbvi(1, 2, 0.001, model)


@model function normal(ctx)
    sample(ctx, "x", Normal(1.,0.1))
end

@model function inversegamma(ctx)
    sample(ctx, "x", InverseGamma(2.,3.))
end

@model function beta(ctx)
    sample(ctx, "x", Beta(2.,3.))
end

@model function uniform(ctx)
    sample(ctx, "x", Uniform(2.,3.))
end

@model function bernoulli(ctx)
    sample(ctx, "x", Bernoulli(0.7))
end


@model function categorical(ctx)
    sample(ctx, "x", Categorical([0.1,0.2,0.3,0.4]))
end

@model function poisson(ctx)
    sample(ctx, "x", Poisson(3.))
end

@model function discrete_uniform(ctx)
    sample(ctx, "x", DiscreteUniform(4,7))
end

@model function dirichlet(ctx)
    sample(ctx, "x", Dirichlet([0.1,0.2,0.3,0.4]))
end


@model function mvnormal(ctx)
    sample(ctx, "x", MvNormal([-1.,1], [0.1,2.]))
end

@model function mvnormal2(ctx)
    sample(ctx, "x", MvNormal([-1.,1], [1. 1.; 1. 2.]))
end



Random.seed!(0)
vd_store = bbvi(100_000, 10, 0.01, mvnormal2)
vd_store["x"]
x = rand(vd_store["x"], 1_000_000)


StatsPlots.histogram(x, normalize=:pdf, linewidth=0)
StatsPlots.histogram(x, normalize=:probability, linewidth=0)


StatsPlots.plot!(t -> pdf(Normal(1.,0.1), t), xlims=(minimum(x), maximum(x)))
StatsPlots.plot!(t -> pdf(InverseGamma(2.,3.), t), xlims=(minimum(x), maximum(x)))
StatsPlots.plot!(t -> pdf(Beta(2.,3.), t), xlims=(minimum(x), maximum(x)))
StatsPlots.plot!(t -> pdf(Uniform(2.,3.), t), xlims=(minimum(x), maximum(x)))

[pdf(Poisson(3.), x) for x in 0:20]

mean(x,dims=2)
std(x,dims=2)
cov(transpose(x))