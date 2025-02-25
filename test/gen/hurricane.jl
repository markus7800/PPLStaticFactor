using Gen
include("lmh.jl")


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

model = hurricane
args = ()
observations = choicemap();

lmh(1_000_000, model, args, observations)