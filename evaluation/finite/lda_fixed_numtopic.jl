
function lda_phi(ctx::AbstractManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, addr::String)

    old_value::Vector{Float64} = manual_read(ctx, addr)
    new_value::Vector{Float64} = manual_resample(ctx, addr, Dirichlet(fill(1/V,V)))

    i = parse(Int, addr[5:end])

    # less read-from-trace operations by reading all phis once
    phi1::Vector{Vector{Float64}} = [manual_read(ctx, "phi_"* string(z))::Vector{Float64} for z in 1:2]
    phi2::Vector{Vector{Float64}} = [manual_read(ctx, "phi_"* string(z))::Vector{Float64}  for z in 1:2]
    phi1[i] = new_value
    phi2[i] = old_value

    for n in 1:N
        z::Int = manual_read(ctx, "z_" * string(n))
        manual_add_logpdf(ctx, "w_" * string(n), Categorical(phi1[z]), observed=w[n])
        manual_sub_logpdf(ctx, "w_" * string(n), Categorical(phi2[z]), observed=w[n])
    end
end


function lda_theta(ctx::AbstractManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, addr::String)
    K::Int = 2 # num topics

    old_value::Vector{Float64} = manual_read(ctx, addr)
    new_value::Vector{Float64} = manual_resample(ctx, addr, Dirichlet(fill(1/K, K)))

    i = parse(Int, addr[7:end])

    # less read-from-trace operations by reading all thetas once
    theta1::Vector{Vector{Float64}} = [manual_read(ctx, "theta_"* string(d))::Vector{Float64} for d in 1:M]
    theta2::Vector{Vector{Float64}} = [manual_read(ctx, "theta_"* string(d))::Vector{Float64} for d in 1:M]
    theta1[i] = new_value
    theta2[i] = old_value

    for n in 1:N
        manual_add_logpdf(ctx, "z_" * string(n), Categorical(theta1[doc[n]]))
        manual_sub_logpdf(ctx, "z_" * string(n), Categorical(theta2[doc[n]]))
    end
end

# function lda_phi(ctx::AbstractManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, addr::String)

#     old_value::Vector{Float64} = manual_read(ctx, addr)
#     new_value::Vector{Float64} = manual_resample(ctx, addr, Dirichlet(fill(1/V,V)))

#     i = parse(Int, addr[5:end])

#     phi1::Vector{Float64} = Float64[]
#     phi2::Vector{Float64} = Float64[]
#     for n in 1:N
#         z::Int = manual_read(ctx, "z_" * string(n))
#         if z != i
#             phi1 =  manual_read(ctx, "phi_"* string(z))
#             phi2 = phi1
#         else
#             phi1 = new_value
#             phi2 = old_value
#         end
#         manual_add_logpdf(ctx, "w_" * string(n), Categorical(phi1), observed=w[n])
#         manual_sub_logpdf(ctx, "w_" * string(n), Categorical(phi2), observed=w[n])
#     end
# end


# function lda_theta(ctx::AbstractManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, addr::String)
#     K::Int = 2 # num topics

#     old_value::Vector{Float64} = manual_read(ctx, addr)
#     new_value::Vector{Float64} = manual_resample(ctx, addr, Dirichlet(fill(1/K, K)))

#     i = parse(Int, addr[7:end])

#     theta1::Vector{Float64} = Float64[]
#     theta2::Vector{Float64} = Float64[]
#     for n in 1:N
#         if doc[n] != i
#             theta1 = manual_read(ctx, "theta_"* string(doc[n]))
#             theta2 = theta1
#         else
#             theta1 = new_value
#             theta2 = old_value
#         end
#         manual_add_logpdf(ctx, "z_" * string(n), Categorical(theta1))
#         manual_sub_logpdf(ctx, "z_" * string(n), Categorical(theta2))
#     end
# end

function lda_z(ctx::AbstractManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, addr::String)
    n = parse(Int, addr[3:end])
    theta::Vector{Float64} = manual_read(ctx, "theta_" * string(doc[n]))
    old_value::Int = manual_read(ctx, addr)
    new_value::Int = manual_resample(ctx, addr, Categorical(theta))

    phi::Vector{Float64} = manual_read(ctx, "phi_" * string(new_value))
    manual_add_logpdf(ctx, "w_" * string(n), Categorical(phi), observed=w[n])
    phi = manual_read(ctx, "phi_" * string(old_value))
    manual_sub_logpdf(ctx, "w_" * string(n), Categorical(phi), observed=w[n])
end

function lda_manual_factor(ctx::AbstractManualResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int})
    if startswith(ctx.resample_addr, "phi")
        lda_phi(ctx, M, N, V, w, doc, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "theta")
        lda_theta(ctx, M, N, V, w, doc, ctx.resample_addr)
    elseif startswith(ctx.resample_addr, "z")
        lda_z(ctx, M, N, V, w, doc, ctx.resample_addr)
    else
        error("Unknown address $(ctx.resample_addr)")
    end
end

function finite_factor(ctx::AbstractManualResampleContext)
    lda_manual_factor(ctx, M, N, V, w, doc)
end