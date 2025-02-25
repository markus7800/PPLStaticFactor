using Gen
include("lmh.jl")

@gen function pedestrian()
    start::Float64 = {:start} ~ uniform_continuous(0.,1.)
    position::Float64 = start
    distance::Float64 = 0
    i::Int = 1
    while position > 0 && distance < 10
        step = {:step => i} ~ uniform_continuous(-1.,1.)
        position = position + step
        distance = distance + abs(step)
        i = i + 1
    end
    {:final_distance} ~ normal(distance, 0.1)
end

model = pedestrian
args = ()
observations = choicemap()
observations[:final_distance] = 1.1

lmh(100_000, model, args, observations)