
mutable struct SMCResumeContext <: AbstractFactorResumeContext
    trace::Dict{String,SampleType}
    logprob::Float64
    last_address::String
    function SMCResumeContext()
        return new(Dict{String,SampleType}(), 0., "")
    end
end

function resume(ctx::SMCResumeContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    if isnothing(observed)
        error("Should only resume from observed. $address")
    end
    return observed
end

function score(ctx::SMCResumeContext, s::State, node_id::Int, address::String, distribution::Distribution; observed=nothing)
    s.node_id = node_id
    ctx.last_address = address
    if !isnothing(observed)
        ctx.logprob += logpdf(distribution, observed)
        return observed
    else
        value = rand(distribution)
        ctx.trace[address] = value
        return value
    end
end


struct Particle
    ctx::SMCResumeContext
    state::State
end

function logsumexp(x)
    m = maximum(x)
    if m == -Inf
        return -Inf
    end
    return log(sum(exp, x .- m)) + m
end

function smc_factorised(n_particles::Int)
    particles = [Particle(SMCResumeContext(),State()) for _ in 1:n_particles]
    while true
        all_terminated = true
        for particle in particles
            resume_from_state(particle.ctx, particle.state, particle.ctx.last_address)
            all_terminated = all_terminated && (particle.state.node_id == -1)
        end
        if all_terminated
            break
        end
        # resampling ala WebPPL, compare Lunden 2021
        # Ws = [particle.ctx.logprob for particle in particles]
        # Ws = Ws .- logsumexp(Ws)
        # Categ
    end
    return particles
end

