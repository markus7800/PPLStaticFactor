

function get_data_annealed_model(modelname::String)
    if modelname == "dirichlet_process"
        N_DATA = length(xs)
        function dp_t(ctx::SampleContext, t::Int)
            return dp(ctx, xs[1:t])
        end
        return dp_t, N_DATA
    elseif modelname == "gmm_fixed_numclust" || modelname == "gmm_variable_numclust"
        N_DATA = length(gt_ys)
        function gmm_t(ctx::SampleContext, t::Int)
            return gmm(ctx, gt_ys[1:t])
        end
        return gmm_t, N_DATA
    elseif modelname == "hmm"
        N_DATA = length(ys)
        function hmm_t(ctx::SampleContext, t::Int)
            return hmm(ctx, ys[1:t])
        end
        return hmm_t, N_DATA
    elseif modelname == "lda_fixed_numtopic" || modelname == "lda_variable_numtopic"
        N_DATA = length(w)
        function lda_t(ctx::SampleContext, t::Int)
            return lda(ctx, M, t, V, w, doc)
        end
        return lda_t, N_DATA
    else
        error("Unsupported model $modelname")
    end
end

model_t, N_DATA = get_data_annealed_model(modelname)

mutable struct SMCContext <: SampleContext
    trace::Dict{String,SampleType}
    logprob::Float64
    function SMCContext()
        return new(Dict{String,SampleType}(), 0)
    end
end

function sample(ctx::SMCContext, address::String, distribution::Distribution; observed::Union{Nothing,SampleType}=nothing)
    if !isnothing(observed)
        ctx.logprob += logpdf(distribution, observed)
        return observed
    else
        if haskey(ctx.trace, address)
            value = ctx.trace[address]
        else
            value = rand(distribution)
            ctx.trace[address] = value
        end
        return value
    end
end

struct StandardParticle
    ctx::SMCContext
end

function smc_standard(n_particles::Int)
    particles = [StandardParticle(SMCContext()) for _ in 1:n_particles]
    logweight = zeros(n_particles)

    for t in 1:N_DATA
        for (i, particle) in enumerate(particles)
            particle.ctx.logprob = 0
            model_t(particle.ctx, t)
            logweight[i] = particle.ctx.logprob
        end
    end
    return logweight
end

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
    return [particle.ctx.logprob for particle in particles]
end