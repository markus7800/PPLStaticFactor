
function hmm_initial_state(ctx::ManualResampleContext, ys::Vector{Float64}, addr::String)
    seqlen::Int = length(ys)
    transition_probs::Matrix{Float64} = [0.1 0.2 0.7; 0.1 0.8 0.1; 0.3 0.3 0.4]

    old_value::Int = manual_read(ctx, addr)
    new_value::Int = manual_resample(ctx, addr, Categorical([0.33, 0.33, 0.34]))

    manual_add_logpdf(ctx, "state_1", Categorical(get_row(transition_probs, new_value)))
    manual_sub_logpdf(ctx, "state_1", Categorical(get_row(transition_probs, old_value)))
end

function hmm_state(ctx::ManualResampleContext, ys::Vector{Float64}, addr::String)
    seqlen::Int = length(ys)
    transition_probs::Matrix{Float64} = [0.1 0.2 0.7; 0.1 0.8 0.1; 0.3 0.3 0.4]

    i = parse(Int, addr[7:end])
    current::Int = i == 1 ? manual_read(ctx, "initial_state") : manual_read(ctx, "state_" * string(i-1))
    
    old_value::Int = manual_read(ctx, addr)
    new_value::Int = manual_resample(ctx, addr, Categorical(get_row(transition_probs, current)))

    manual_add_logpdf(ctx, "obs_" * string(i), Normal(new_value, 1), observed = get_n(ys, i))
    manual_sub_logpdf(ctx, "obs_" * string(i), Normal(old_value, 1), observed = get_n(ys, i))

    if i < seqlen
        manual_add_logpdf(ctx, "state_" * string(i+1), Categorical(get_row(transition_probs, new_value)))
        manual_sub_logpdf(ctx, "state_" * string(i+1), Categorical(get_row(transition_probs, old_value)))
    end
end

function hmm_manual_factor(ctx::ManualResampleContext, ys::Vector{Float64})
    if ctx.resample_addr == "initial_state"
        hmm_initial_state(ctx, ys, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "state")
        hmm_state(ctx, ys, ctx.resample_addr)
    else
        error("Unknown address $(ctx.resample_addr)")
    end
    return ctx.logprob
end

function manual_factor(ctx::ManualResampleContext)
    return hmm_manual_factor(ctx, ys)
end