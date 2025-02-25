using Gen
include("lmh.jl")

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


lmh(500_000, model, args, observations)