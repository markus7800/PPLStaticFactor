using Gen
include("lmh.jl")

modelname = "hmm_fixed_seqlen"

get_row(x::AbstractMatrix, i) = x[i, :]

@gen function hmm(ys)

    seqlen::Int = length(ys)

    transition_probs::Matrix{Float64} = [
        0.1 0.2 0.7;
        0.1 0.8 0.1;
        0.3 0.3 0.4;
    ]

    current::Int = {:initial_state} ~ categorical([0.33, 0.33, 0.34])
    i::Int = 1 
    while i <= seqlen
        current = {:state => i} ~ categorical(get_row(transition_probs, current))
        {:obs => i} ~ normal(current, 1)
        i = i + 1
    end
end

ys = [
    3.36, 2.87, 1.54, 1.13, 2.05, 2.55, 3.08, 1.23, 2.37, 2.5,
    1.42, 1.46, 0.65, 1.15, 0.31, 2.89, 0.96, 2.23, 1.55, 1.52,
    2.72, 4.16, 2.4, 2.41, 1.05, 3.05, 2.04, 3.47, 1.08, 0.63,
    3.87, 0.08, 2.06, 2.21, 2.24, 1.77, 0.67, 2.45, 4.05, 2.95,
    1.65, 3.01, 3.74, 1.54, 2.47, 1.54, 3.7, 4.29, 0.93, 1.95, 
]

model = hmm
args = (ys,)
observations = choicemap();
for i in eachindex(ys)
    observations[:obs => i] = ys[i]
end

N = name_to_N[modelname]
acceptance_rate = lmh(10, N ÷ 10, model, args, observations)
res = @timed lmh(10, N ÷ 10, model, args, observations)
println(@sprintf("Gen time %.3f μs", res.time / N * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))