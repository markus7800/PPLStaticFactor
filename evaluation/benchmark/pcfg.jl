# info: https://en.wikipedia.org/wiki/Probabilistic_context-free_grammar

include("../ppl.jl")

modelname = "pcfg"
proposers = Dict{String, Distribution}()

@model function pcfg(ctx::SampleContext)
    TERMINAL_SYMBOL::Int = 4
    production_probs::Matrix{Float64} = [
        0.1 0.2 0.6 0.1;
        0.05 0.8 0.1 0.05;
        0.3 0.3 0.3 0.1
    ]

    current::Int = sample(ctx, "initial_symbol", Categorical([0.33, 0.33, 0.34]))
    i::Int = 1
    while current != TERMINAL_SYMBOL
        current = sample(ctx, "symbol_" * string(i), Categorical(get_row(production_probs, current)))
        i = i + 1
    end
end