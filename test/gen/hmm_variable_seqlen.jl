using Gen
include("lmh.jl")

get_row(x::AbstractMatrix, i) = x[i, :]

@gen function hmm(ys)
    TERMINAL_STATE::Int = 4
    transition_probs::Matrix{Float64} = [
        0.1 0.2 0.6 0.1;
        0.05 0.8 0.1 0.05;
        0.3 0.3 0.3 0.1
    ]

    current::Int = {:initial_state} ~ categorical([0.33, 0.33, 0.34])
    i::Int = 1
    while current != TERMINAL_STATE
        current = {:state => i} ~ categorical(get_row(transition_probs, current))
        if i <= length(ys)
            {:obs => i} ~ normal(current == TERMINAL_STATE ? 100.0 : current, 1.)
        end
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
    1.12,
    100.,
]


model = hmm
args = (ys,)
observations = choicemap();
for i in eachindex(ys)
    observations[:obs => i] = ys[i]
end

lmh(100_000, model, args, observations)