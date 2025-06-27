using Gen
import Random
using Printf

abstract type LMHSelector end
function get_length(::LMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    error("Not implemented!")
end
function get_resample_address(::LMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    error("Not implemented!")
end


function get_addresses(choices::Gen.ChoiceMap)
    addresses = Set()
    for (key, value) in get_values_shallow(choices)
        push!(addresses, key)
    end
    for (prefix, submap) in get_submaps_shallow(choices)
        # this is super slow for map combinator because we have submap for each iter
        addresses = addresses ∪ Set(prefix => address for address in get_addresses(submap))
    end
    return addresses
end

function get_length(choices::Gen.ChoiceMap)
    count = 0
    for (key, value) in get_values_shallow(choices)
        count += 1
    end
    for (prefix, submap) in get_submaps_shallow(choices)
        count += get_length(submap)
    end
    return count
end

struct DefaultLMHSelector <: LMHSelector
end
function get_length(::DefaultLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return get_length(trace) - get_length(observations)
end
function get_resample_address(::DefaultLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    return rand(setdiff(get_addresses(trace), get_addresses(observations)))
end

function lmh(N::Int, n_iter::Int, selector::LMHSelector, model, args, observations; check::Bool=false)
    Random.seed!(0)

    n_accepted = 0
    for _ in 1:N
        trace, lp = generate(model, args, observations)
        # println(trace)

        for i in 1:n_iter
            choices = get_choices(trace)
            L = get_length(selector, choices, args, observations)
            resample_address = get_resample_address(selector, choices, args, observations)
            # println("$i. resample_address: ", resample_address)
            if check && !has_value(choices, resample_address)
                display(choices)
                error("Resample address $resample_address not in choices")
            end
            if check && (get_length(choices) - get_length(observations)) != L
                error("Length computed by selector $L disagrees with real trace length $(get_length(choices) - get_length(observations)) ")
            end

            new_trace, accept = mh(trace, select(resample_address), observations=observations, check=check)
            accept = accept && (rand() < L / get_length(selector, get_choices(new_trace), args, observations))

            if accept
                trace = new_trace
                n_accepted += 1
            end
        end  
    end
    return n_accepted / (n_iter*N)
end

include("../../evaluation/N_iters.jl")