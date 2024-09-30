include("../ppl.jl")

modelname = "hurricane"

@model function hurricane(ctx:: SampleContext)
    first_city_ixs::Bool = sample(ctx, "F", Bernoulli(0.5))
    prep_0::Bool = 0
    damage_0::Bool = 0
    prep_1::Bool = 0
    damage_1::Bool = 0
    if first_city_ixs == 0
        prep_0 = sample(ctx, "P0", Bernoulli(0.5))
        damage_0 = sample(ctx, "D0", Bernoulli(prep_0 == 1 ? 0.20 : 0.80))
        prep_1 = sample(ctx, "P1", Bernoulli(damage_0 == 1 ? 0.75 : 0.50))
        damage_1 = sample(ctx, "D1", Bernoulli(prep_1 == 1 ? 0.20 : 0.80))
    else
        prep_1 = sample(ctx, "P1", Bernoulli(0.5))
        damage_1 = sample(ctx, "D1", Bernoulli(prep_1 == 1 ? 0.20 : 0.80))
        prep_0 = sample(ctx, "P0", Bernoulli(damage_1 == 1 ? 0.75 : 0.50))
        damage_0 = sample(ctx, "D0", Bernoulli(prep_0 == 1 ? 0.20 : 0.80))
    end
end