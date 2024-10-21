

function lda_phi_custom(ctx::ManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, addr::String)

    old_value::Vector{Float64} = manual_read(ctx, addr)
    new_value::Vector{Float64} = manual_resample(ctx, addr, Dirichlet(fill(1/V,V)))

    i = parse(Int, addr[5:end])

    for n in 1:N
        z::Int = manual_read(ctx, "z_" * string(n))
        # custom optimisation:
        if z != i
            continue
        end
        manual_add_logpdf(ctx, "w_" * string(n), Categorical(new_value), observed=w[n])
        manual_sub_logpdf(ctx, "w_" * string(n), Categorical(old_value), observed=w[n])
    end
end


function lda_theta_custom(ctx::ManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, addr::String)
    K::Int = 2 # num topics

    old_value::Vector{Float64} = manual_read(ctx, addr)
    new_value::Vector{Float64} = manual_resample(ctx, addr, Dirichlet(fill(1/K, K)))

    i = parse(Int, addr[7:end])

    for n in 1:N
        # custom optimisation:
        if doc[n] != i
            continue
        end
        manual_add_logpdf(ctx, "z_" * string(n), Categorical(new_value))
        manual_sub_logpdf(ctx, "z_" * string(n), Categorical(old_value))
    end
end

function lda_z_custom(ctx::ManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, addr::String)
    n = parse(Int, addr[3:end])
    theta::Vector{Float64} = manual_read(ctx, "theta_" * string(doc[n]))
    old_value::Int = manual_read(ctx, addr)
    new_value::Int = manual_resample(ctx, addr, Categorical(theta))

    phi::Vector{Float64} = manual_read(ctx, "phi_" * string(new_value))
    manual_add_logpdf(ctx, "w_" * string(n), Categorical(phi), observed=w[n])
    phi = manual_read(ctx, "phi_" * string(old_value))
    manual_sub_logpdf(ctx, "w_" * string(n), Categorical(phi), observed=w[n])
end

function lda_manual_factor_custom(ctx::ManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int})
    if startswith(ctx.resample_addr, "phi")
        lda_phi_custom(ctx, M, N, V, w, doc, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "theta")
        lda_theta_custom(ctx, M, N, V, w, doc, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "z")
        lda_z_custom(ctx, M, N, V, w, doc, ctx.resample_addr)
    else
        error("Unknown address $(ctx.resample_addr)")
    end
    return ctx.logprob
end

function custom_factor(ctx::ManualResampleContext)
    return lda_manual_factor_custom(ctx, M, N, V, w, doc)
end