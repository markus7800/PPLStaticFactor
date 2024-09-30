include("../ppl.jl")

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
