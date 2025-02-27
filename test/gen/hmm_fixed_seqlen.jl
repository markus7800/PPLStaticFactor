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
    0.57,
    2.14,
    2.53,
    3.05,
    2.17,
    2.4,
    3.01,
    3.55,
    0.65,
    1.12
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