
include("ppl.jl")

modelname = "pedestrian"


@model function pedestrian(ctx::SampleContext)
    start::Float64 = sample(ctx, "start", Uniform(0.,1.))
    position::Float64 = start
    distance::Float64 = 0
    i::Int = 1
    while position > 0 && distance < 10
        step = sample(ctx, "step_" * string(i), Uniform(-1.,1.))
        position = position + step
        distance = distance + abs(step)
        i = i + 1
    end
    sample(ctx, "final_distance", Normal(distance, 0.1), observed=1.1)
end

# begin
#     ctx = GenerateContext()
#     pedestrian(ctx)
#     ctx.trace
# end