using Gen
include("lmh.jl")

modelname = "aircraft"

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

struct AircraftLMHSelector <: LMHSelector end
function get_resample_address(selector::AircraftLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)

    U = rand()
    n = 1
    if U < n/N
        return :num_aircraft
    end

    num_aircraft = trace[:num_aircraft] + 1
    for i in 1:num_aircraft
        n += 1
        if U < n/N
            return :pos => i
        end
        n += 1
        if U < n/N
            return :num_blips => i
        end
        num_blips = trace[:num_blips => i]
        for j in 1:num_blips
            n += 1
            if U < n/N
                return :blib => i => j
            end
        end
    end

end
function get_length(::AircraftLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    N = 0
    num_aircraft = trace[:num_aircraft] + 1
    N += 1 + 2*num_aircraft

    for i in 1:num_aircraft
        num_blips = trace[:num_blips => i]
        N += num_blips
    end

    return N
end

N = name_to_N[modelname]

model = aircraft
args = ()
observations = choicemap();

observations[:observed_num_blips] = 3
observations[:observed_blip_1] = 1.
observations[:observed_blip_2] = 2.
observations[:observed_blip_3] = 3.

selector = AircraftLMHSelector()

acceptance_rate = lmh(10, N ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N ÷ 10, selector, model, args, observations)
println(@sprintf("Gen time: %.3f μs", res.time / N * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))



@gen function gen_blip(position::Float64)::Float64
    blip::Float64 = {:blib} ~ normal(position, 1.)
    return blip
end
const gen_blips = Map(gen_blip)

@gen (static) function gen_aircraft(i::Int)::AbstractVector{Float64}
    position::Float64 = {:pos} ~ normal(2., 5.)
    num_blips::Int = {:num_blips} ~ categorical([0.1,0.4,0.5])
    blips ~ gen_blips(fill(position, num_blips))
    return blips
end
const gen_aircrafts = Map(gen_aircraft)

function get_observed_blips(aircrafts::AbstractVector)
    total_num_blibs::Int = 0
    blip_1::Float64 = 0.
    blip_2::Float64 = 0.
    blip_3::Float64 = 0.
    for aircraft in aircrafts
        for blip in aircraft
            total_num_blibs += 1
            if total_num_blibs == 1
                blip_1 = blip
            end
            if total_num_blibs == 2
                blip_2 = blip
            end
            if total_num_blibs == 3
                blip_3 = blip
            end
        end
    end
    return total_num_blibs, blip_1, blip_2, blip_3
end

@gen (static) function aircraft_combinator()
    num_aircraft ~ poisson(5)
    num_aircraft = num_aircraft + 1

    aircrafts ~ gen_aircrafts(1:num_aircraft)

    total_num_blibs, blip_1, blip_2, blip_3 = get_observed_blips(aircrafts)

    {:observed_num_blips} ~ normal(total_num_blibs, 1)
    {:observed_blip_1} ~ normal(blip_1, 1)
    {:observed_blip_2} ~ normal(blip_2, 1)
    {:observed_blip_3} ~ normal(blip_3, 1)
end

# tr, _ = generate(aircraft_combinator, args, observations);
# display(get_choices(tr))

struct AircraftCombinatorLMHSelector <: LMHSelector end
function get_resample_address(selector::AircraftCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)

    U = rand()
    n = 1
    if U < n/N
        return :num_aircraft
    end

    num_aircraft = trace[:num_aircraft] + 1
    for i in 1:num_aircraft
        n += 1
        if U < n/N
            return :aircrafts => i => :pos
        end
        n += 1
        if U < n/N
            return :aircrafts => i => :num_blips
        end
        num_blips = trace[:aircrafts => i => :num_blips]
        for j in 1:num_blips
            n += 1
            if U < n/N
                return :aircrafts => i => :blips => j => :blib
            end
        end
    end

end
function get_length(::AircraftCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    N = 0
    num_aircraft = trace[:num_aircraft] + 1
    N += 1 + 2*num_aircraft

    for i in 1:num_aircraft
        num_blips = trace[:aircrafts => i => :num_blips]
        N += num_blips
    end

    return N
end

model = aircraft_combinator
selector = AircraftCombinatorLMHSelector()

acceptance_rate = lmh(10, N ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N ÷ 10, selector, model, args, observations)
println(@sprintf("Gen combinator time: %.3f μs", res.time / N * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))
