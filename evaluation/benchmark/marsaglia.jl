
include("ppl.jl")

modelname = "marsaglia"

@model function marsaglia(ctx::SampleContext)
    s::Float64 = Inf
    x::Float64 = 0.
    y::Float64 = 0.
    i::Int = 1
    while s > 1
        x = sample(ctx, "x_" * string(i), Uniform(-1.,1.))
        y = sample(ctx, "y_" * string(i), Uniform(-1.,1.))
        s = x^2 + y^2
        i = i + 1
    end
    z::Float64 = x * sqrt(-2 * log(s) / s)
    return z
end

# begin
#     ctx = GenerateContext()
#     marsaglia(ctx)
#     ctx.trace
# end

# using Plots

# begin
#     N = 10^6
#     result = zeros(N)
#     lp = zeros(N)
#     for i in 1:N
#         ctx = GenerateContext()
#         result[i] = marsaglia(ctx)
#         lp[i] = ctx.logprob
#     end
#     W = exp.(lp) / sum(exp, lp)
#     histogram(result, weights=W, xlims=(-5,5), normalize=true)
#     plot!(x -> pdf(Normal(0,1),x))
# end