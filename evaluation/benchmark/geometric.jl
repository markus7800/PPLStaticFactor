# info: https://en.wikipedia.org/wiki/Geometric_distribution

modelname = "geometric"
proposers = Dict{String, Distribution}()

@model function geometric(ctx::SampleContext)
    i::Int = -1
    b::Bool = true
    while b 
        i = i + 1
        b = sample(ctx, "b_" * string(i), Bernoulli(0.5))
    end
    sample(ctx, "x", Normal(i,1.), observed=5.)
    return i
end
