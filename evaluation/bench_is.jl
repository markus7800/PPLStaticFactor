using Printf

include("ppl.jl")
include("parse_args.jl")


mutable struct ISContext <: SampleContext
    trace::Dict{String,SampleType}
    logprob::Float64
    function ISContext()
        return new(Dict{String,SampleType}(), 0)
    end
end

function sample(ctx::ISContext, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
    if !isnothing(observed)
        value = observed
        ctx.logprob += logpdf(distribution, value)
    else
        value = rand(distribution)
        ctx.trace[address] = value
    end
    return value
end

function importance_sampling(n_particles::Int)
    log_weights = zeros(n_particles)
    for i in 1:n_particles
        ctx = ISContext()
        model(ctx)
        log_weights[i] = ctx.logprob
    end
end

function runbench(N::Int, n_particles::Int, verbose::Bool)
    Random.seed!(0)
    res = @timed for _ in 1:N
        importance_sampling(n_particles)
    end
    time = res.time/N

    verbose && println(@sprintf("Time %.3f ms", time*10^3))
    
    if verbose
        f = open("evaluation/is_results.csv", "a")
        println(f, modelname, ",", n_particles, ",", time*10^3)
    end
end

n_particles = 100

runbench(10, n_particles, false)
runbench(10, n_particles, true)