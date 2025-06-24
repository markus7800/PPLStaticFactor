# inspired by: https://probprog.github.io/anglican/examples/viewer/?worksheet=marsaglia
# commit = 46d70db1d6eb90207d46d0095fea2810c9ed543b
# https://en.wikipedia.org/wiki/Marsaglia_polar_method#Julia

modelname = "marsaglia"
proposers = Dict{String, Distribution}()

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