
function gmm_mu(ctx::AbstractManualVisitContext, ys::Vector{Float64}, addr::String)
    ξ::Float64 = 0.0
    κ::Float64 = 0.01

    old_value::Float64 = manual_read(ctx, addr)
    new_value::Float64 = manual_visit(ctx, addr, Normal(ξ, (1 / sqrt(κ))))

    cluster_ix::Int = parse(Int, addr[4:end])

    mu1::Vector{Float64} = [manual_read(ctx, "mu_"*string(z)) for z in 1:4]
    mu2::Vector{Float64} = [manual_read(ctx, "mu_"*string(z)) for z in 1:4]
    mu1[cluster_ix] = new_value
    mu2[cluster_ix] = old_value

    for i in 1:length(ys)
        z::Int = manual_read(ctx, "z_" * string(i))
        var::Float64 = manual_read(ctx, "var_"*string(z))
        manual_add_logpdf(ctx, "y_" * string(i), Normal(mu1[z], var), observed=get_n(ys, i))
        manual_sub_logpdf(ctx, "y_" * string(i), Normal(mu2[z], var), observed=get_n(ys, i))
    end
end

function gmm_var(ctx::AbstractManualVisitContext, ys::Vector{Float64}, addr::String)
    α::Float64 = 2.0
    β::Float64 = 10.0
    
    old_value::Float64 = manual_read(ctx, addr)
    new_value::Float64 = manual_visit(ctx, addr, InverseGamma(α, β))

    cluster_ix::Int = parse(Int, addr[5:end])
    var1::Vector{Float64} = [manual_read(ctx, "var_"*string(z)) for z in 1:4]
    var2::Vector{Float64} = [manual_read(ctx, "var_"*string(z)) for z in 1:4]
    var1[cluster_ix] = new_value
    var2[cluster_ix] = old_value

    for i in 1:length(ys)
        z::Int = manual_read(ctx, "z_" * string(i))
        mu::Float64 = manual_read(ctx, "mu_"*string(z))
        manual_add_logpdf(ctx, "y_" * string(i), Normal(mu, var1[z]), observed=get_n(ys, i))
        manual_sub_logpdf(ctx, "y_" * string(i), Normal(mu, var2[z]), observed=get_n(ys, i))
    end
end
function gmm_w(ctx::AbstractManualVisitContext, ys::Vector{Float64}, addr::String)
    δ::Float64 = 5.0
    num_clusters::Int = 4

    old_value::Vector{Float64} = manual_read(ctx, addr)
    new_value::Vector{Float64} = manual_visit(ctx, addr, Dirichlet(fill(δ, num_clusters)))

    for i in 1:length(ys)
        manual_add_logpdf(ctx, "z_" * string(i), Categorical(new_value))
        manual_sub_logpdf(ctx, "z_" * string(i), Categorical(old_value))
    end
end

function gmm_z(ctx::AbstractManualVisitContext, ys::Vector{Float64}, addr::String)
    w::Vector{Float64} = manual_read(ctx, "w")

    i::Int = parse(Int, addr[3:end])

    old_value::Int = manual_read(ctx, addr)
    new_value::Int = manual_visit(ctx, addr, Categorical(w))

    mu::Float64 = manual_read(ctx, "mu_"*string(new_value))
    var::Float64 = manual_read(ctx, "var_"*string(new_value))
    manual_add_logpdf(ctx, "y_" * string(i), Normal(mu, var), observed=get_n(ys, i))

    mu = manual_read(ctx, "mu_"*string(old_value))
    var = manual_read(ctx, "var_"*string(old_value))
    manual_sub_logpdf(ctx, "y_" * string(i), Normal(mu, var), observed=get_n(ys, i))
end

function gmm_manual_factor(ctx::AbstractManualResampleContext, ys::Vector{Float64})
    if ctx.resample_addr == "w"
        gmm_w(ctx, ys, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "mu")
        gmm_mu(ctx, ys, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "var")
        gmm_var(ctx, ys, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "z")
        gmm_z(ctx, ys, ctx.resample_addr)
    else
        error("Unknown address $(ctx.resample_addr)")
    end
end

function finite_factor(ctx::AbstractManualVisitContext)
    gmm_manual_factor(ctx, ys)
end