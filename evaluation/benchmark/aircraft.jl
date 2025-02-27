# source: https://probprog.github.io/anglican/examples/viewer/?worksheet=aircraft
# commit = 46d70db1d6eb90207d46d0095fea2810c9ed543b

include("../ppl.jl")

modelname = "aircraft"
proposers = Dict{String, Distribution}()

@model function aircraft(ctx::SampleContext)
    num_aircraft::Int = sample(ctx, "num_aircraft", Poisson(5))
    num_aircraft = num_aircraft + 1

    total_num_blibs::Int = 0
    blip_1::Float64 = 0.
    blip_2::Float64 = 0.
    blip_3::Float64 = 0.

    i::Int = 1
    while i <= num_aircraft
        position::Float64 = sample(ctx, "pos_" * string(i), Normal(2., 5.))
        num_blips::Int = sample(ctx, "num_blips_" * string(i), Categorical([0.1,0.4,0.5]))
        j::Int = 1
        while j <= num_blips
            total_num_blibs = total_num_blibs + 1
            blip::Float64 = sample(ctx, "blip_" * string(i) * "_" * string(j), Normal(position, 1.))
            if total_num_blibs == 1
                blip_1 = blip
            end
            if total_num_blibs == 2
                blip_2 = blip
            end
            if total_num_blibs == 3
                blip_3 = blip
            end
            j = j + 1
        end
        i = i + 1
    end

    sample(ctx, "observed_num_blips", Normal(total_num_blibs, 1), observed=3)
    sample(ctx, "observed_blip_2", Normal(blip_1, 1), observed= 1.)
    sample(ctx, "observed_blip_2", Normal(blip_2, 1); observed= 2.)
    sample(ctx, "observed_blip_3", Normal(blip_3, 1), observed= 3.)
end
