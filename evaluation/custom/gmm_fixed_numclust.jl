
function gmm_mu_custom(ctx::AbstractManualRevisitContext, ys::Vector{Float64}, addr::String)
    ξ::Float64 = 0.0
    κ::Float64 = 0.01

    old_value::Float64 = manual_read(ctx, addr)
    new_value::Float64 = manual_revisit(ctx, addr, Normal(ξ, (1 / sqrt(κ))))

    cluster_ix::Int = parse(Int, addr[4:end])

    for i in 1:length(ys)
        z::Int = manual_read(ctx, "z_" * string(i))
        # custom optimisation:
        if cluster_ix != z
            continue
        end
        var::Float64 = manual_read(ctx, "var_"*string(z))

        manual_add_logpdf(ctx, "y_" * string(i), Normal(new_value, var), observed=get_n(ys, i))
        manual_sub_logpdf(ctx, "y_" * string(i), Normal(old_value, var), observed=get_n(ys, i))
    end
end

function gmm_var_custom(ctx::AbstractManualRevisitContext, ys::Vector{Float64}, addr::String)
    α::Float64 = 2.0
    β::Float64 = 10.0
    
    old_value::Float64 = manual_read(ctx, addr)
    new_value::Float64 = manual_revisit(ctx, addr, InverseGamma(α, β))

    cluster_ix::Int = parse(Int, addr[5:end])

    for i in 1:length(ys)
        z::Int = manual_read(ctx, "z_" * string(i))
        # custom optimisation:
        if cluster_ix != z
            continue
        end
        mu::Float64 = manual_read(ctx, "mu_"*string(z))

        manual_add_logpdf(ctx, "y_" * string(i), Normal(mu, new_value), observed=get_n(ys, i))
        manual_sub_logpdf(ctx, "y_" * string(i), Normal(mu, old_value), observed=get_n(ys, i))
    end
end
function gmm_w_custom(ctx::AbstractManualRevisitContext, ys::Vector{Float64}, addr::String)
    δ::Float64 = 5.0
    num_clusters::Int = 4

    old_value::Vector{Float64} = manual_read(ctx, addr)
    new_value::Vector{Float64} = manual_revisit(ctx, addr, Dirichlet(fill(δ, num_clusters)))

    for i in 1:length(ys)
        manual_add_logpdf(ctx, "z_" * string(i), Categorical(new_value))
        manual_sub_logpdf(ctx, "z_" * string(i), Categorical(old_value))
    end
end

function gmm_z_custom(ctx::AbstractManualRevisitContext, ys::Vector{Float64}, addr::String)
    w::Vector{Float64} = manual_read(ctx, "w")

    i::Int = parse(Int, addr[3:end])

    old_value::Int = manual_read(ctx, addr)
    new_value::Int = manual_revisit(ctx, addr, Categorical(w))

    mu::Float64 = manual_read(ctx, "mu_"*string(new_value))
    var::Float64 = manual_read(ctx, "var_"*string(new_value))
    manual_add_logpdf(ctx, "y_" * string(i), Normal(mu, var), observed=get_n(ys, i))

    mu = manual_read(ctx, "mu_"*string(old_value))
    var = manual_read(ctx, "var_"*string(old_value))
    manual_sub_logpdf(ctx, "y_" * string(i), Normal(mu, var), observed=get_n(ys, i))
end

function gmm_manual_factor_custom(ctx::AbstractManualResampleContext, ys::Vector{Float64})
    if ctx.resample_addr == "w"
        gmm_w_custom(ctx, ys, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "mu")
        gmm_mu_custom(ctx, ys, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "var")
        gmm_var_custom(ctx, ys, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "z")
        gmm_z_custom(ctx, ys, ctx.resample_addr)
    else
        error("Unknown address $(ctx.resample_addr)")
    end
end

function custom_factor(ctx::AbstractManualRevisitContext)
    gmm_manual_factor_custom(ctx, ys)
end