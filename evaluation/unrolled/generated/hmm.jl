# this file is auto-generated

include("../hmm.jl")

mutable struct State <: AbstractState
    node_id:: Int
    current::Int
    transition_probs::Matrix{Float64}
    function State()
        return new(
            0,
            zero(Int),
            zero(Matrix{Float64}),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.current = _s_.current
    dst.transition_probs = _s_.transition_probs
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function hmm(ctx::AbstractSampleRecordStateContext, ys::Vector{Float64}, _s_::State)
    _s_.transition_probs::Matrix{Float64} = [0.1 0.2 0.7; 0.1 0.8 0.1; 0.3 0.3 0.4]
    _s_.current::Int = sample_record_state(ctx, _s_, 46, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = sample_record_state(ctx, _s_, 62, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 80, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    _s_.current = sample_record_state(ctx, _s_, 102, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 120, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    _s_.current = sample_record_state(ctx, _s_, 142, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 160, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    _s_.current = sample_record_state(ctx, _s_, 182, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 200, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    _s_.current = sample_record_state(ctx, _s_, 222, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 240, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    _s_.current = sample_record_state(ctx, _s_, 262, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 280, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    _s_.current = sample_record_state(ctx, _s_, 302, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 320, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    _s_.current = sample_record_state(ctx, _s_, 342, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 360, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    _s_.current = sample_record_state(ctx, _s_, 382, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 400, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    _s_.current = sample_record_state(ctx, _s_, 422, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 440, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))
    _s_.current = sample_record_state(ctx, _s_, 462, ("state_" * string(11)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 480, ("obs_" * string(11)), Normal(_s_.current, 1), observed = get_n(ys, 11))
    _s_.current = sample_record_state(ctx, _s_, 502, ("state_" * string(12)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 520, ("obs_" * string(12)), Normal(_s_.current, 1), observed = get_n(ys, 12))
    _s_.current = sample_record_state(ctx, _s_, 542, ("state_" * string(13)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 560, ("obs_" * string(13)), Normal(_s_.current, 1), observed = get_n(ys, 13))
    _s_.current = sample_record_state(ctx, _s_, 582, ("state_" * string(14)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 600, ("obs_" * string(14)), Normal(_s_.current, 1), observed = get_n(ys, 14))
    _s_.current = sample_record_state(ctx, _s_, 622, ("state_" * string(15)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 640, ("obs_" * string(15)), Normal(_s_.current, 1), observed = get_n(ys, 15))
    _s_.current = sample_record_state(ctx, _s_, 662, ("state_" * string(16)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 680, ("obs_" * string(16)), Normal(_s_.current, 1), observed = get_n(ys, 16))
    _s_.current = sample_record_state(ctx, _s_, 702, ("state_" * string(17)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 720, ("obs_" * string(17)), Normal(_s_.current, 1), observed = get_n(ys, 17))
    _s_.current = sample_record_state(ctx, _s_, 742, ("state_" * string(18)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 760, ("obs_" * string(18)), Normal(_s_.current, 1), observed = get_n(ys, 18))
    _s_.current = sample_record_state(ctx, _s_, 782, ("state_" * string(19)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 800, ("obs_" * string(19)), Normal(_s_.current, 1), observed = get_n(ys, 19))
    _s_.current = sample_record_state(ctx, _s_, 822, ("state_" * string(20)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 840, ("obs_" * string(20)), Normal(_s_.current, 1), observed = get_n(ys, 20))
    _s_.current = sample_record_state(ctx, _s_, 862, ("state_" * string(21)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 880, ("obs_" * string(21)), Normal(_s_.current, 1), observed = get_n(ys, 21))
    _s_.current = sample_record_state(ctx, _s_, 902, ("state_" * string(22)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 920, ("obs_" * string(22)), Normal(_s_.current, 1), observed = get_n(ys, 22))
    _s_.current = sample_record_state(ctx, _s_, 942, ("state_" * string(23)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 960, ("obs_" * string(23)), Normal(_s_.current, 1), observed = get_n(ys, 23))
    _s_.current = sample_record_state(ctx, _s_, 982, ("state_" * string(24)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1000, ("obs_" * string(24)), Normal(_s_.current, 1), observed = get_n(ys, 24))
    _s_.current = sample_record_state(ctx, _s_, 1022, ("state_" * string(25)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1040, ("obs_" * string(25)), Normal(_s_.current, 1), observed = get_n(ys, 25))
    _s_.current = sample_record_state(ctx, _s_, 1062, ("state_" * string(26)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1080, ("obs_" * string(26)), Normal(_s_.current, 1), observed = get_n(ys, 26))
    _s_.current = sample_record_state(ctx, _s_, 1102, ("state_" * string(27)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1120, ("obs_" * string(27)), Normal(_s_.current, 1), observed = get_n(ys, 27))
    _s_.current = sample_record_state(ctx, _s_, 1142, ("state_" * string(28)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1160, ("obs_" * string(28)), Normal(_s_.current, 1), observed = get_n(ys, 28))
    _s_.current = sample_record_state(ctx, _s_, 1182, ("state_" * string(29)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1200, ("obs_" * string(29)), Normal(_s_.current, 1), observed = get_n(ys, 29))
    _s_.current = sample_record_state(ctx, _s_, 1222, ("state_" * string(30)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1240, ("obs_" * string(30)), Normal(_s_.current, 1), observed = get_n(ys, 30))
    _s_.current = sample_record_state(ctx, _s_, 1262, ("state_" * string(31)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1280, ("obs_" * string(31)), Normal(_s_.current, 1), observed = get_n(ys, 31))
    _s_.current = sample_record_state(ctx, _s_, 1302, ("state_" * string(32)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1320, ("obs_" * string(32)), Normal(_s_.current, 1), observed = get_n(ys, 32))
    _s_.current = sample_record_state(ctx, _s_, 1342, ("state_" * string(33)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1360, ("obs_" * string(33)), Normal(_s_.current, 1), observed = get_n(ys, 33))
    _s_.current = sample_record_state(ctx, _s_, 1382, ("state_" * string(34)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1400, ("obs_" * string(34)), Normal(_s_.current, 1), observed = get_n(ys, 34))
    _s_.current = sample_record_state(ctx, _s_, 1422, ("state_" * string(35)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1440, ("obs_" * string(35)), Normal(_s_.current, 1), observed = get_n(ys, 35))
    _s_.current = sample_record_state(ctx, _s_, 1462, ("state_" * string(36)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1480, ("obs_" * string(36)), Normal(_s_.current, 1), observed = get_n(ys, 36))
    _s_.current = sample_record_state(ctx, _s_, 1502, ("state_" * string(37)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1520, ("obs_" * string(37)), Normal(_s_.current, 1), observed = get_n(ys, 37))
    _s_.current = sample_record_state(ctx, _s_, 1542, ("state_" * string(38)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1560, ("obs_" * string(38)), Normal(_s_.current, 1), observed = get_n(ys, 38))
    _s_.current = sample_record_state(ctx, _s_, 1582, ("state_" * string(39)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1600, ("obs_" * string(39)), Normal(_s_.current, 1), observed = get_n(ys, 39))
    _s_.current = sample_record_state(ctx, _s_, 1622, ("state_" * string(40)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1640, ("obs_" * string(40)), Normal(_s_.current, 1), observed = get_n(ys, 40))
    _s_.current = sample_record_state(ctx, _s_, 1662, ("state_" * string(41)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1680, ("obs_" * string(41)), Normal(_s_.current, 1), observed = get_n(ys, 41))
    _s_.current = sample_record_state(ctx, _s_, 1702, ("state_" * string(42)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1720, ("obs_" * string(42)), Normal(_s_.current, 1), observed = get_n(ys, 42))
    _s_.current = sample_record_state(ctx, _s_, 1742, ("state_" * string(43)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1760, ("obs_" * string(43)), Normal(_s_.current, 1), observed = get_n(ys, 43))
    _s_.current = sample_record_state(ctx, _s_, 1782, ("state_" * string(44)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1800, ("obs_" * string(44)), Normal(_s_.current, 1), observed = get_n(ys, 44))
    _s_.current = sample_record_state(ctx, _s_, 1822, ("state_" * string(45)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1840, ("obs_" * string(45)), Normal(_s_.current, 1), observed = get_n(ys, 45))
    _s_.current = sample_record_state(ctx, _s_, 1862, ("state_" * string(46)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1880, ("obs_" * string(46)), Normal(_s_.current, 1), observed = get_n(ys, 46))
    _s_.current = sample_record_state(ctx, _s_, 1902, ("state_" * string(47)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1920, ("obs_" * string(47)), Normal(_s_.current, 1), observed = get_n(ys, 47))
    _s_.current = sample_record_state(ctx, _s_, 1942, ("state_" * string(48)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1960, ("obs_" * string(48)), Normal(_s_.current, 1), observed = get_n(ys, 48))
    _s_.current = sample_record_state(ctx, _s_, 1982, ("state_" * string(49)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 2000, ("obs_" * string(49)), Normal(_s_.current, 1), observed = get_n(ys, 49))
    _s_.current = sample_record_state(ctx, _s_, 2022, ("state_" * string(50)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 2040, ("obs_" * string(50)), Normal(_s_.current, 1), observed = get_n(ys, 50))

end

function hmm_initial_state_46(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 46, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = score(ctx, _s_, 62, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__102(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 102, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 120, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    _s_.current = score(ctx, _s_, 142, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1022(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1022, ("state_" * string(25)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1040, ("obs_" * string(25)), Normal(_s_.current, 1), observed = get_n(ys, 25))
    _s_.current = score(ctx, _s_, 1062, ("state_" * string(26)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1062(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1062, ("state_" * string(26)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1080, ("obs_" * string(26)), Normal(_s_.current, 1), observed = get_n(ys, 26))
    _s_.current = score(ctx, _s_, 1102, ("state_" * string(27)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1102(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1102, ("state_" * string(27)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1120, ("obs_" * string(27)), Normal(_s_.current, 1), observed = get_n(ys, 27))
    _s_.current = score(ctx, _s_, 1142, ("state_" * string(28)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1142(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1142, ("state_" * string(28)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1160, ("obs_" * string(28)), Normal(_s_.current, 1), observed = get_n(ys, 28))
    _s_.current = score(ctx, _s_, 1182, ("state_" * string(29)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1182(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1182, ("state_" * string(29)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1200, ("obs_" * string(29)), Normal(_s_.current, 1), observed = get_n(ys, 29))
    _s_.current = score(ctx, _s_, 1222, ("state_" * string(30)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1222(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1222, ("state_" * string(30)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1240, ("obs_" * string(30)), Normal(_s_.current, 1), observed = get_n(ys, 30))
    _s_.current = score(ctx, _s_, 1262, ("state_" * string(31)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1262(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1262, ("state_" * string(31)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1280, ("obs_" * string(31)), Normal(_s_.current, 1), observed = get_n(ys, 31))
    _s_.current = score(ctx, _s_, 1302, ("state_" * string(32)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1302(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1302, ("state_" * string(32)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1320, ("obs_" * string(32)), Normal(_s_.current, 1), observed = get_n(ys, 32))
    _s_.current = score(ctx, _s_, 1342, ("state_" * string(33)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1342(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1342, ("state_" * string(33)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1360, ("obs_" * string(33)), Normal(_s_.current, 1), observed = get_n(ys, 33))
    _s_.current = score(ctx, _s_, 1382, ("state_" * string(34)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1382(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1382, ("state_" * string(34)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1400, ("obs_" * string(34)), Normal(_s_.current, 1), observed = get_n(ys, 34))
    _s_.current = score(ctx, _s_, 1422, ("state_" * string(35)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__142(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 142, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 160, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    _s_.current = score(ctx, _s_, 182, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1422(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1422, ("state_" * string(35)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1440, ("obs_" * string(35)), Normal(_s_.current, 1), observed = get_n(ys, 35))
    _s_.current = score(ctx, _s_, 1462, ("state_" * string(36)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1462(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1462, ("state_" * string(36)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1480, ("obs_" * string(36)), Normal(_s_.current, 1), observed = get_n(ys, 36))
    _s_.current = score(ctx, _s_, 1502, ("state_" * string(37)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1502(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1502, ("state_" * string(37)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1520, ("obs_" * string(37)), Normal(_s_.current, 1), observed = get_n(ys, 37))
    _s_.current = score(ctx, _s_, 1542, ("state_" * string(38)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1542(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1542, ("state_" * string(38)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1560, ("obs_" * string(38)), Normal(_s_.current, 1), observed = get_n(ys, 38))
    _s_.current = score(ctx, _s_, 1582, ("state_" * string(39)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1582(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1582, ("state_" * string(39)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1600, ("obs_" * string(39)), Normal(_s_.current, 1), observed = get_n(ys, 39))
    _s_.current = score(ctx, _s_, 1622, ("state_" * string(40)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1622(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1622, ("state_" * string(40)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1640, ("obs_" * string(40)), Normal(_s_.current, 1), observed = get_n(ys, 40))
    _s_.current = score(ctx, _s_, 1662, ("state_" * string(41)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1662(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1662, ("state_" * string(41)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1680, ("obs_" * string(41)), Normal(_s_.current, 1), observed = get_n(ys, 41))
    _s_.current = score(ctx, _s_, 1702, ("state_" * string(42)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1702(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1702, ("state_" * string(42)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1720, ("obs_" * string(42)), Normal(_s_.current, 1), observed = get_n(ys, 42))
    _s_.current = score(ctx, _s_, 1742, ("state_" * string(43)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1742(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1742, ("state_" * string(43)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1760, ("obs_" * string(43)), Normal(_s_.current, 1), observed = get_n(ys, 43))
    _s_.current = score(ctx, _s_, 1782, ("state_" * string(44)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1782(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1782, ("state_" * string(44)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1800, ("obs_" * string(44)), Normal(_s_.current, 1), observed = get_n(ys, 44))
    _s_.current = score(ctx, _s_, 1822, ("state_" * string(45)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__182(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 182, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 200, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    _s_.current = score(ctx, _s_, 222, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1822(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1822, ("state_" * string(45)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1840, ("obs_" * string(45)), Normal(_s_.current, 1), observed = get_n(ys, 45))
    _s_.current = score(ctx, _s_, 1862, ("state_" * string(46)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1862(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1862, ("state_" * string(46)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1880, ("obs_" * string(46)), Normal(_s_.current, 1), observed = get_n(ys, 46))
    _s_.current = score(ctx, _s_, 1902, ("state_" * string(47)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1902(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1902, ("state_" * string(47)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1920, ("obs_" * string(47)), Normal(_s_.current, 1), observed = get_n(ys, 47))
    _s_.current = score(ctx, _s_, 1942, ("state_" * string(48)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1942(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1942, ("state_" * string(48)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1960, ("obs_" * string(48)), Normal(_s_.current, 1), observed = get_n(ys, 48))
    _s_.current = score(ctx, _s_, 1982, ("state_" * string(49)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1982(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 1982, ("state_" * string(49)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 2000, ("obs_" * string(49)), Normal(_s_.current, 1), observed = get_n(ys, 49))
    _s_.current = score(ctx, _s_, 2022, ("state_" * string(50)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__2022(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 2022, ("state_" * string(50)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 2040, ("obs_" * string(50)), Normal(_s_.current, 1), observed = get_n(ys, 50))
end

function hmm_state__222(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 222, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 240, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    _s_.current = score(ctx, _s_, 262, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__262(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 262, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 280, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    _s_.current = score(ctx, _s_, 302, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__302(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 302, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 320, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    _s_.current = score(ctx, _s_, 342, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__342(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 342, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 360, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    _s_.current = score(ctx, _s_, 382, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__382(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 382, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 400, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    _s_.current = score(ctx, _s_, 422, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__422(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 422, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 440, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))
    _s_.current = score(ctx, _s_, 462, ("state_" * string(11)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__462(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 462, ("state_" * string(11)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 480, ("obs_" * string(11)), Normal(_s_.current, 1), observed = get_n(ys, 11))
    _s_.current = score(ctx, _s_, 502, ("state_" * string(12)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__502(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 502, ("state_" * string(12)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 520, ("obs_" * string(12)), Normal(_s_.current, 1), observed = get_n(ys, 12))
    _s_.current = score(ctx, _s_, 542, ("state_" * string(13)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__542(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 542, ("state_" * string(13)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 560, ("obs_" * string(13)), Normal(_s_.current, 1), observed = get_n(ys, 13))
    _s_.current = score(ctx, _s_, 582, ("state_" * string(14)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__582(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 582, ("state_" * string(14)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 600, ("obs_" * string(14)), Normal(_s_.current, 1), observed = get_n(ys, 14))
    _s_.current = score(ctx, _s_, 622, ("state_" * string(15)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__62(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 62, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 80, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    _s_.current = score(ctx, _s_, 102, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__622(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 622, ("state_" * string(15)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 640, ("obs_" * string(15)), Normal(_s_.current, 1), observed = get_n(ys, 15))
    _s_.current = score(ctx, _s_, 662, ("state_" * string(16)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__662(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 662, ("state_" * string(16)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 680, ("obs_" * string(16)), Normal(_s_.current, 1), observed = get_n(ys, 16))
    _s_.current = score(ctx, _s_, 702, ("state_" * string(17)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__702(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 702, ("state_" * string(17)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 720, ("obs_" * string(17)), Normal(_s_.current, 1), observed = get_n(ys, 17))
    _s_.current = score(ctx, _s_, 742, ("state_" * string(18)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__742(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 742, ("state_" * string(18)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 760, ("obs_" * string(18)), Normal(_s_.current, 1), observed = get_n(ys, 18))
    _s_.current = score(ctx, _s_, 782, ("state_" * string(19)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__782(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 782, ("state_" * string(19)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 800, ("obs_" * string(19)), Normal(_s_.current, 1), observed = get_n(ys, 19))
    _s_.current = score(ctx, _s_, 822, ("state_" * string(20)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__822(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 822, ("state_" * string(20)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 840, ("obs_" * string(20)), Normal(_s_.current, 1), observed = get_n(ys, 20))
    _s_.current = score(ctx, _s_, 862, ("state_" * string(21)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__862(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 862, ("state_" * string(21)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 880, ("obs_" * string(21)), Normal(_s_.current, 1), observed = get_n(ys, 21))
    _s_.current = score(ctx, _s_, 902, ("state_" * string(22)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__902(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 902, ("state_" * string(22)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 920, ("obs_" * string(22)), Normal(_s_.current, 1), observed = get_n(ys, 22))
    _s_.current = score(ctx, _s_, 942, ("state_" * string(23)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__942(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 942, ("state_" * string(23)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 960, ("obs_" * string(23)), Normal(_s_.current, 1), observed = get_n(ys, 23))
    _s_.current = score(ctx, _s_, 982, ("state_" * string(24)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__982(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = revisit(ctx, _s_, 982, ("state_" * string(24)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1000, ("obs_" * string(24)), Normal(_s_.current, 1), observed = get_n(ys, 24))
    _s_.current = score(ctx, _s_, 1022, ("state_" * string(25)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_factor(ctx::AbstractFactorRevisitContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 46
        return hmm_initial_state_46(ctx, ys, _s_)
    end
    if _s_.node_id == 102
        return hmm_state__102(ctx, ys, _s_)
    end
    if _s_.node_id == 1022
        return hmm_state__1022(ctx, ys, _s_)
    end
    if _s_.node_id == 1062
        return hmm_state__1062(ctx, ys, _s_)
    end
    if _s_.node_id == 1102
        return hmm_state__1102(ctx, ys, _s_)
    end
    if _s_.node_id == 1142
        return hmm_state__1142(ctx, ys, _s_)
    end
    if _s_.node_id == 1182
        return hmm_state__1182(ctx, ys, _s_)
    end
    if _s_.node_id == 1222
        return hmm_state__1222(ctx, ys, _s_)
    end
    if _s_.node_id == 1262
        return hmm_state__1262(ctx, ys, _s_)
    end
    if _s_.node_id == 1302
        return hmm_state__1302(ctx, ys, _s_)
    end
    if _s_.node_id == 1342
        return hmm_state__1342(ctx, ys, _s_)
    end
    if _s_.node_id == 1382
        return hmm_state__1382(ctx, ys, _s_)
    end
    if _s_.node_id == 142
        return hmm_state__142(ctx, ys, _s_)
    end
    if _s_.node_id == 1422
        return hmm_state__1422(ctx, ys, _s_)
    end
    if _s_.node_id == 1462
        return hmm_state__1462(ctx, ys, _s_)
    end
    if _s_.node_id == 1502
        return hmm_state__1502(ctx, ys, _s_)
    end
    if _s_.node_id == 1542
        return hmm_state__1542(ctx, ys, _s_)
    end
    if _s_.node_id == 1582
        return hmm_state__1582(ctx, ys, _s_)
    end
    if _s_.node_id == 1622
        return hmm_state__1622(ctx, ys, _s_)
    end
    if _s_.node_id == 1662
        return hmm_state__1662(ctx, ys, _s_)
    end
    if _s_.node_id == 1702
        return hmm_state__1702(ctx, ys, _s_)
    end
    if _s_.node_id == 1742
        return hmm_state__1742(ctx, ys, _s_)
    end
    if _s_.node_id == 1782
        return hmm_state__1782(ctx, ys, _s_)
    end
    if _s_.node_id == 182
        return hmm_state__182(ctx, ys, _s_)
    end
    if _s_.node_id == 1822
        return hmm_state__1822(ctx, ys, _s_)
    end
    if _s_.node_id == 1862
        return hmm_state__1862(ctx, ys, _s_)
    end
    if _s_.node_id == 1902
        return hmm_state__1902(ctx, ys, _s_)
    end
    if _s_.node_id == 1942
        return hmm_state__1942(ctx, ys, _s_)
    end
    if _s_.node_id == 1982
        return hmm_state__1982(ctx, ys, _s_)
    end
    if _s_.node_id == 2022
        return hmm_state__2022(ctx, ys, _s_)
    end
    if _s_.node_id == 222
        return hmm_state__222(ctx, ys, _s_)
    end
    if _s_.node_id == 262
        return hmm_state__262(ctx, ys, _s_)
    end
    if _s_.node_id == 302
        return hmm_state__302(ctx, ys, _s_)
    end
    if _s_.node_id == 342
        return hmm_state__342(ctx, ys, _s_)
    end
    if _s_.node_id == 382
        return hmm_state__382(ctx, ys, _s_)
    end
    if _s_.node_id == 422
        return hmm_state__422(ctx, ys, _s_)
    end
    if _s_.node_id == 462
        return hmm_state__462(ctx, ys, _s_)
    end
    if _s_.node_id == 502
        return hmm_state__502(ctx, ys, _s_)
    end
    if _s_.node_id == 542
        return hmm_state__542(ctx, ys, _s_)
    end
    if _s_.node_id == 582
        return hmm_state__582(ctx, ys, _s_)
    end
    if _s_.node_id == 62
        return hmm_state__62(ctx, ys, _s_)
    end
    if _s_.node_id == 622
        return hmm_state__622(ctx, ys, _s_)
    end
    if _s_.node_id == 662
        return hmm_state__662(ctx, ys, _s_)
    end
    if _s_.node_id == 702
        return hmm_state__702(ctx, ys, _s_)
    end
    if _s_.node_id == 742
        return hmm_state__742(ctx, ys, _s_)
    end
    if _s_.node_id == 782
        return hmm_state__782(ctx, ys, _s_)
    end
    if _s_.node_id == 822
        return hmm_state__822(ctx, ys, _s_)
    end
    if _s_.node_id == 862
        return hmm_state__862(ctx, ys, _s_)
    end
    if _s_.node_id == 902
        return hmm_state__902(ctx, ys, _s_)
    end
    if _s_.node_id == 942
        return hmm_state__942(ctx, ys, _s_)
    end
    if _s_.node_id == 982
        return hmm_state__982(ctx, ys, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return hmm(ctx, ys)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return hmm(ctx, ys, _s_)
end

function factor(ctx::AbstractFactorRevisitContext, _s_::State, _addr_::String)
    return hmm_factor(ctx, ys, _s_, _addr_)
end

