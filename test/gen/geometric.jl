using Gen
include("lmh.jl")

modelname = "geometric"

@gen function geometric(p::Float64)
    i::Int = -1
    b::Bool = true
    while b 
        i = i + 1
        b = {:b => i} ~ bernoulli(p)
    end
    return i
end

model = geometric
args = (0.5,)
observations = choicemap();


N = name_to_N[modelname]
acceptance_rate = lmh(10, N ÷ 10, model, args, observations)
res = @timed lmh(10, N ÷ 10, model, args, observations)
println(@sprintf("Gen time %.3f μs", res.time / N * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))