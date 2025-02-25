using Gen
include("lmh.jl")

@gen function aircraft()
    num_aircraft ~ poisson(5)
    num_aircraft = num_aircraft + 1

    total_num_blibs::Int = 0
    blip_1::Float64 = 0.
    blip_2::Float64 = 0.
    blip_3::Float64 = 0.

    i::Int = 1
    while i <= num_aircraft
        position::Float64 = {:pos => i} ~ normal(2., 5.)
        num_blips::Int = {:num_blips => i} ~ categorical([0.1,0.4,0.5])
        j::Int = 1
        while j <= num_blips
            total_num_blibs = total_num_blibs + 1
            blip::Float64 = {:blib => i => j} ~ normal(position, 1.)
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

    {:observed_num_blips} ~ normal(total_num_blibs, 1)
    {:observed_blip_1} ~ normal(blip_1, 1)
    {:observed_blip_2} ~ normal(blip_2, 1)
    {:observed_blip_3} ~ normal(blip_3, 1)
end

model = aircraft
args = ()
observations = choicemap();

observations[:observed_num_blips] = 3
observations[:observed_blip_1] = 1.
observations[:observed_blip_2] = 2.
observations[:observed_blip_3] = 3.

lmh(75_000, model, args, observations)