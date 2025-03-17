using Gen
include("lmh.jl")


@gen function model(xs::Vector{Float64})
    slope ~ normal(0, 2)
    intercept ~ normal(0, 2)
    noise ~ gamma(1, 1)
    prob_outlier ~ uniform(0, 1)

    n = length(xs)
    ys = Vector{Float64}(undef, n)

    for i = 1:n
        if ({:data => i => :is_outlier} ~ bernoulli(prob_outlier))
            (mu, std) = (0., 10.)
        else
            (mu, std) = (xs[i] * slope + intercept, noise)
        end
        ys[i] = {:data => i => :y} ~ normal(mu, std)
    end
    ys
end

function block_resimulation_update(tr)

    # Block 1: Update the line's parameters
    line_params = select(:noise, :slope, :intercept)
    (tr, _) = mh(tr, line_params)

    # Blocks 2-N+1: Update the outlier classifications
    (xs,) = get_args(tr)
    n = length(xs)
    for i=1:n
        (tr, _) = mh(tr, select(:data => i => :is_outlier))
    end

    # Block N+2: Update the prob_outlier parameter
    (tr, _) = mh(tr, select(:prob_outlier))

    # Return the updated trace
    tr
end

function make_constraints(ys::Vector{Float64})
    constraints = choicemap()
    for i=1:length(ys)
        constraints[:data => i => :y] = ys[i]
    end
    constraints
end

function block_resimulation_inference(model, xs, ys)
    observations = make_constraints(ys)
    (tr, _) = generate(model, (xs,), observations)
    for iter=1:500
        tr = block_resimulation_update(tr)
    end
    tr
end

ns = [1, 3, 7, 10, 30, 70, 100]
times = []
@profview for n in ns
    xs = rand(n)
    ys = rand(n)
    start = time_ns()
    # tr = block_resimulation_inference(model, xs, ys)
    lmh(1_000, 5, model, (xs,), make_constraints(ys))
    push!(times, (time_ns() - start) / 1e9)
end
display(times)

@gen function generate_single_point(x::Float64, prob_outlier::Float64, noise::Float64,
    slope::Float64, intercept::Float64)
    is_outlier ~ bernoulli(prob_outlier)
    mu  = is_outlier ? 0. : x * slope + intercept
    std = is_outlier ? 10. : noise
    y ~ normal(mu, std)
    return y
end;
generate_all_points = Map(generate_single_point);

@gen (static) function model_with_map(xs::Vector{Float64})
    slope ~ normal(0, 2)
    intercept ~ normal(0, 2)
    noise ~ gamma(1, 1)
    prob_outlier ~ uniform(0, 1)
    n = length(xs)
    data ~ generate_all_points(xs, fill(prob_outlier, n), fill(noise, n), fill(slope, n), fill(intercept, n))
    return data
end;

with_map_times = []
@profview for n in ns
    xs = rand(n)
    ys = rand(n)
    start = time_ns()
    # tr = block_resimulation_inference(model_with_map, xs, ys)
    lmh(1_000, 5, model_with_map, (xs,), make_constraints(ys))
    push!(with_map_times, (time_ns() - start) / 1e9)
end

display(with_map_times)