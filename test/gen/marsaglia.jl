using Gen
include("lmh.jl")

@gen function marsaglia()
    s::Float64 = Inf
    x::Float64 = 0.
    y::Float64 = 0.
    i::Int = 1
    while s > 1
        x = {:x => i} ~ uniform_continuous(-1.,1.)
        y = {:y => i} ~ uniform_continuous(-1.,1.)
        s = x^2 + y^2
        i = i + 1
    end
    z::Float64 = x * sqrt(-2 * log(s) / s)
    return z
end


model = marsaglia
args = ()
observations = choicemap();

lmh(500_000, model, args, observations)