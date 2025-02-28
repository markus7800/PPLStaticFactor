using Gen
import Random
using Printf

function get_addresses(trie::Union{Gen.Trie,Gen.DynamicChoiceMap})
    addresses = Set(keys(trie.leaf_nodes))
    for (prefix, node) in trie.internal_nodes
        addresses = addresses ∪ Set(prefix => address for address in get_addresses(node))
    end
    return addresses
end

function get_length(trie::Union{Gen.Trie,Gen.DynamicChoiceMap})
    count = length(trie.leaf_nodes)
    for (prefix, node) in trie.internal_nodes
        count += get_length(node)
    end
    return count
end


function lmh(N::Int, n_iter::Int, model, args, observations; check::Bool=false)
    Random.seed!(0)
    observation_addresses = get_addresses(observations)

    n_accepted = 0
    for _ in 1:N
        trace, lp = generate(model, args, observations)
        # println(trace)

        for i in 1:n_iter
            resample_address = rand(setdiff(get_addresses(trace.trie), observation_addresses))
            # println(resample_address)
            new_trace, accept = mh(trace, select(resample_address), observations=observations, check=check)
            accept = accept && (rand() < get_length(trace.trie) / get_length(new_trace.trie))

            if accept
                trace = new_trace
                n_accepted += 1
            end
        end  
    end
    return n_accepted / (n_iter*N)
end

name_to_N = Dict{String,Int}(
    "aircraft" => 75_000,
    "captcha" => 1_000,
    "dirichlet_process" => 10_000,
    "geometric" => 500_000,
    "gmm_fixed_numclust" => 25_000,
    "gmm_variable_numclust" => 25_000,
    "hmm_fixed_seqlen" => 100_000,
    "hmm_variable_seqlen" => 100_000,
    "hurricane" => 1_000_000,
    "lda_fixed_numtopic" => 10_000,
    "lda_variable_numtopic" => 10_000,
    "linear_regression" => 100_000,
    "marsaglia" => 500_000,
    "pedestrian" => 100_000,
    "urn" => 100_000,
)