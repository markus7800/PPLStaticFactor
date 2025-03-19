using Gen
include("lmh.jl")

modelname = "pcfg"

get_row(x::AbstractMatrix, i) = x[i, :]

@gen function pcfg()
    TERMINAL_SYMBOL::Int = 4
    production_probs::Matrix{Float64} = [
        0.1 0.2 0.6 0.1;
        0.05 0.8 0.1 0.05;
        0.3 0.3 0.3 0.1
    ]

    current::Int = {:initial_symbol} ~ categorical([0.33, 0.33, 0.34])
    i::Int = 1 
    while current != TERMINAL_SYMBOL
        current = {:symbol => i} ~ categorical(get_row(production_probs, current))
        i = i + 1
    end
end

struct PCFGLMHSelector <: LMHSelector end
function get_length(::PCFGLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return get_length(trace)
end

function get_resample_address(selector::PCFGLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)
    U = rand()
    if U < 1/N
        return :initial_symbol
    else
        i = rand(1:N-1)
        return :symbol => i
    end
end
N_iter = name_to_N[modelname]

model = pcfg
args = ()
observations = choicemap();
selector = PCFGLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))

f = open("compare/gen/results.csv", "a")
println(f, modelname, ",", N_iter, ",", acceptance_rate, ",", base_time*10^6, ",", "NA", ",", "NA")