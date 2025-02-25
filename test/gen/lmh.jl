using Gen
import Random

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


function lmh(n_iter::Int, model, args, observations)
    Random.seed!(0)

    trace, lp = generate(model, args, observations)
    # println(trace)

    n_accepted = 0
    for i in 1:n_iter
        resample_address = rand(setdiff(get_addresses(trace.trie), get_addresses(observations)))
        # println(resample_address)
        new_trace, accept = mh(trace, select(resample_address), observations=observations, check=true)
        accept = accept && (rand() < get_length(trace.trie) / get_length(new_trace.trie))

        if accept
            trace = new_trace
            n_accepted += 1
        end
    end  
    println(n_accepted / n_iter)
end