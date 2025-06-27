using Gen
include("lmh.jl")

modelname = "hurricane"

@gen function hurricane()
    first_city_ixs::Bool = {:F} ~ bernoulli(0.5)
    prep_0::Bool = 0
    damage_0::Bool = 0
    prep_1::Bool = 0
    damage_1::Bool = 0
    if first_city_ixs == 0
        prep_0 = {:P0} ~ bernoulli(0.5)
        damage_0 = {:D0} ~ bernoulli(prep_0 == 1 ? 0.20 : 0.80)
        prep_1 = {:P1} ~ bernoulli(damage_0 == 1 ? 0.75 : 0.50)
        damage_1 = {:D1} ~ bernoulli(prep_1 == 1 ? 0.20 : 0.80)
    else
        prep_1 = {:P1} ~ bernoulli(0.5)
        damage_1 = {:D1} ~ bernoulli(prep_1 == 1 ? 0.20 : 0.80)
        prep_0 = {:P0} ~ bernoulli(damage_1 == 1 ? 0.75 : 0.50)
        damage_0 = {:D0} ~ bernoulli(prep_0 == 1 ? 0.20 : 0.80)
    end
end

struct HurricaneLMHSelector <: LMHSelector end
function get_length(::HurricaneLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return 5
end
function get_resample_address(selector::HurricaneLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    return rand([:F, :P0, :D0, :P1, :D1])
end

N_iter = name_to_N[modelname]

model = hurricane
args = ()
observations = choicemap();
selector = HurricaneLMHSelector()

acceptance_rate = lmh(N_seeds, N_iter, selector, model, args, observations, check=true)
res = @timed lmh(N_seeds, N_iter, selector, model, args, observations)
base_time = res.time / (N_iter * N_seeds)
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


# === Implementation with Combinators  ===

@gen function P0_first()
    prep_0 = {:P0} ~ bernoulli(0.5)
    damage_0 = {:D0} ~ bernoulli(prep_0 == 1 ? 0.20 : 0.80)
    prep_1 = {:P1} ~ bernoulli(damage_0 == 1 ? 0.75 : 0.50)
    damage_1 = {:D1} ~ bernoulli(prep_1 == 1 ? 0.20 : 0.80)
end

@gen function P1_first()
    prep_1 = {:P1} ~ bernoulli(0.5)
    damage_1 = {:D1} ~ bernoulli(prep_1 == 1 ? 0.20 : 0.80)
    prep_0 = {:P0} ~ bernoulli(damage_1 == 1 ? 0.75 : 0.50)
    damage_0 = {:D0} ~ bernoulli(prep_0 == 1 ? 0.20 : 0.80)
end

const P0_or_P1 = Switch(P0_first, P1_first)

@gen (static) function hurricane_combinator()
    first_city_ixs::Bool = {:F} ~ bernoulli(0.5)
    city ~ P0_or_P1(first_city_ixs + 1)
end


# tr, _ = generate(hurricane_combinator, args, observations);
# display(get_choices(tr))


struct HurricaneCombinatorLMHSelector <: LMHSelector end
function get_length(::HurricaneCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    return 5
end
function get_resample_address(selector::HurricaneCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    return rand([:F, :city => :P0, :city => :D0, :city => :P1, :city => :D1])
end

model = hurricane_combinator
selector = HurricaneCombinatorLMHSelector()

acceptance_rate = lmh(N_seeds, N_iter, selector, model, args, observations, check=true)
res = @timed lmh(N_seeds, N_iter, selector, model, args, observations)
combinator_time = res.time / (N_iter * N_seeds)
println(@sprintf("Gen combinator time: %.3f μs", combinator_time * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


f = open("compare/gen/lmh_results.csv", "a")
println(f, modelname, ",", N_iter*N_seeds, ",", acceptance_rate, ",", base_time*10^6, ",", combinator_time*10^6, ",", combinator_time / base_time)