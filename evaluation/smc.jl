

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
    elseif modelname == "hmm_unrolled"
        N_DATA = length(ys)
        function hmm_t_2(ctx::SampleContext, t::Int)
            transition_probs::Matrix{Float64} = [
                0.1 0.2 0.7;
                0.1 0.8 0.1;
                0.3 0.3 0.4;
            ]
            current::Int = sample(ctx, "initial_state", Categorical([0.33, 0.33, 0.34]))
            for i in 1:t # change here
                current = sample(ctx, "state_" * string(i), Categorical(get_row(transition_probs, current)))
                sample(ctx, "obs_" * string(i), Normal(current, 1), observed=get_n(ys,i))
            end
        end
        return hmm_t_2, N_DATA
    elseif modelname == "lda_fixed_numtopic" || modelname == "lda_variable_numtopic"
        N_DATA = length(w)
        function lda_t(ctx::SampleContext, t::Int)
            return lda(ctx, M, t, V, w, doc)
        end
        return lda_t, N_DATA
    else
        return nothing, 0
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
function Base.copy!(dst::StandardParticle, src::StandardParticle)
    dst.ctx.logprob = src.ctx.logprob
    Base.copy!(dst.ctx.trace, src.ctx.trace) # shallow copy is enough
end

function smc_standard(n_particles::Int, resampling::Bool, check::Bool)
    particles = [StandardParticle(SMCContext()) for _ in 1:n_particles]
    newparticles = [StandardParticle(SMCContext()) for _ in 1:n_particles]
    logprob = zeros(n_particles)
    logweight = zeros(n_particles)

    for t in 1:N_DATA+1 # +1 to force one last resampling
        if t <= N_DATA
            for (i, particle) in enumerate(particles)
                particle.ctx.logprob = 0
                model_t(particle.ctx, t)
                logweight[i] = particle.ctx.logprob - logprob[i]
                logprob[i] = particle.ctx.logprob
            end
        end

        if resampling
            if check
                logweight = round.(logweight, sigdigits=4)
            end
            Ws = exp.(logweight .- logsumexp(logweight))
            ixs = rand(Categorical(Ws), n_particles)
            for (i, ix) in enumerate(ixs)
                Base.copy!(newparticles[i], particles[ix])
            end
            particles, newparticles = newparticles, particles
            logprob = logprob[ixs]
            logweight .= 0
        end
        # println(Ws)
        # println(ixs)
        # println(logprob)
    end
    return logprob
end

mutable struct SMCResumeContext <: AbstractFactorResumeContext
    trace::Dict{String,SampleType}
    logprob::Float64
    last_address::String
    function SMCResumeContext()
        return new(Dict{String,SampleType}(), 0., "")
    end
end

function read_trace(ctx::SMCResumeContext, s::State, node_id::Int, address::String; observed=nothing)
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
function Base.copy!(dst::Particle, src::Particle)
    Base.copy!(dst.ctx.trace, src.ctx.trace) # shallow copy is ok
    dst.ctx.logprob = src.ctx.logprob
    dst.ctx.last_address = src.ctx.last_address
    Base.copy!(dst.state, src.state)
end

function logsumexp(x)
    m = maximum(x)
    if m == -Inf
        return -Inf
    end
    return log(sum(exp, x .- m)) + m
end

function smc_factorised(n_particles::Int, resampling::Bool, check::Bool)
    particles = [Particle(SMCResumeContext(),State()) for _ in 1:n_particles]
    newparticles = [Particle(SMCResumeContext(),State()) for _ in 1:n_particles]

    logprob = zeros(n_particles)
    logweight = zeros(n_particles)
    while true
        all_terminated = true
        for (i, particle) in enumerate(particles)
            particle.state.node_id == -1 && continue
            
            particle.ctx.logprob = 0.
            resume_from_state(particle.ctx, particle.state, particle.ctx.last_address)
            if particle.state.node_id != -1
                logweight[i] = particle.ctx.logprob
                logprob[i] += particle.ctx.logprob
            end
            all_terminated = false
        end
        if all_terminated
            break
        end

        if resampling
            if check
                logweight = round.(logweight, sigdigits=4)
            end
            Ws = exp.(logweight .- logsumexp(logweight))
            ixs = rand(Categorical(Ws), n_particles)
            for (i, ix) in enumerate(ixs)
                Base.copy!(newparticles[i], particles[ix])
            end
            particles, newparticles = newparticles, particles
            logprob = logprob[ixs]
            logweight .= 0
        end
        # println(Ws)
        # println(ixs)
        # println(logprob)
    end
    return logprob
end