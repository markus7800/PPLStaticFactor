

function lr_intercept(ctx::ManualResampleContext, xs::Vector{Float64}, ys::Vector{Float64})
    old_value::Float64 = manual_read(ctx, "intercept")
    new_value::Float64 = manual_resample(ctx, "intercept", Normal(0.0, 3.0))
    slope::Float64 = manual_read(ctx, "slope")

    for i in 1:length(xs)
        manual_add_logpdf(ctx, "y_" * string(i), Normal(slope * get_n(xs, i) + new_value, 1.0), observed=get_n(ys, i))
        manual_sub_logpdf(ctx, "y_" * string(i), Normal(slope * get_n(xs, i) + old_value, 1.0), observed=get_n(ys, i))
    end
end

function lr_slope(ctx::ManualResampleContext, xs::Vector{Float64}, ys::Vector{Float64})
    old_value::Float64 = manual_read(ctx, "slope")
    new_value::Float64 = manual_resample(ctx, "slope", Normal(0.0, 3.0))
    intercept::Float64 = manual_read(ctx, "intercept")

    for i in 1:length(xs)
        manual_add_logpdf(ctx, "y_" * string(i), Normal(new_value * get_n(xs, i) + intercept, 1.0), observed=get_n(ys, i))
        manual_sub_logpdf(ctx, "y_" * string(i), Normal(old_value * get_n(xs, i) + intercept, 1.0), observed=get_n(ys, i))
    end
end

function lr_manual_factor(ctx::ManualResampleContext, xs::Vector{Float64}, ys::Vector{Float64})
    if ctx.resample_addr == "slope"
        lr_slope(ctx, xs, ys)
    else
        lr_intercept(ctx, xs, ys)
    end
    return ctx.logprob
end

function finite_factor(ctx::ManualResampleContext)
    return lr_manual_factor(ctx, xs, ys)
end