
include("ppl.jl")

modelname = "geometric"

@model function geometric(ctx::SampleContext)
    i::Int = -1
    b::Bool = true
    while b 
        i = i + 1
        b = sample(ctx, "b_" * string(i), Bernoulli(0.5))
    end
    return i
end

# begin
#     ctx = GenerateContext()
#     geometric(ctx)
#     ctx.trace
# end

# using Plots

# begin
#     N = 10^6
#     result = zeros(Int, N)
#     lp = zeros(N)
#     for i in 1:N
#         ctx = GenerateContext()
#         result[i] = geometric(ctx)
#         lp[i] = ctx.logprob
#     end
#     W = exp.(lp) / sum(exp, lp)
#     histogram(result, weights=W)
#     xs = 0:maximum(result)
#     bar!(xs, pdf(Geometric(0.5), xs), alpha=0.3)
# end