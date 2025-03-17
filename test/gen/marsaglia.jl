using Gen
include("lmh.jl")

modelname = "marsaglia"

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

N = name_to_N[modelname]
acceptance_rate = lmh(10, N ÷ 10, model, args, observations)
res = @timed lmh(10, N ÷ 10, model, args, observations)
println(@sprintf("Gen time: %.3f μs", res.time / N * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))