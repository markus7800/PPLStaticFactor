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

function hmm_initial_state_46(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 46, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = score(ctx, _s_, 62, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__102(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 102, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 120, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    _s_.current = score(ctx, _s_, 142, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1022(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1022, ("state_" * string(25)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1040, ("obs_" * string(25)), Normal(_s_.current, 1), observed = get_n(ys, 25))
    _s_.current = score(ctx, _s_, 1062, ("state_" * string(26)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1062(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1062, ("state_" * string(26)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1080, ("obs_" * string(26)), Normal(_s_.current, 1), observed = get_n(ys, 26))
    _s_.current = score(ctx, _s_, 1102, ("state_" * string(27)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1102(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1102, ("state_" * string(27)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1120, ("obs_" * string(27)), Normal(_s_.current, 1), observed = get_n(ys, 27))
    _s_.current = score(ctx, _s_, 1142, ("state_" * string(28)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1142(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1142, ("state_" * string(28)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1160, ("obs_" * string(28)), Normal(_s_.current, 1), observed = get_n(ys, 28))
    _s_.current = score(ctx, _s_, 1182, ("state_" * string(29)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1182(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1182, ("state_" * string(29)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1200, ("obs_" * string(29)), Normal(_s_.current, 1), observed = get_n(ys, 29))
    _s_.current = score(ctx, _s_, 1222, ("state_" * string(30)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1222(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1222, ("state_" * string(30)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1240, ("obs_" * string(30)), Normal(_s_.current, 1), observed = get_n(ys, 30))
    _s_.current = score(ctx, _s_, 1262, ("state_" * string(31)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1262(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1262, ("state_" * string(31)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1280, ("obs_" * string(31)), Normal(_s_.current, 1), observed = get_n(ys, 31))
    _s_.current = score(ctx, _s_, 1302, ("state_" * string(32)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1302(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1302, ("state_" * string(32)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1320, ("obs_" * string(32)), Normal(_s_.current, 1), observed = get_n(ys, 32))
    _s_.current = score(ctx, _s_, 1342, ("state_" * string(33)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1342(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1342, ("state_" * string(33)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1360, ("obs_" * string(33)), Normal(_s_.current, 1), observed = get_n(ys, 33))
    _s_.current = score(ctx, _s_, 1382, ("state_" * string(34)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1382(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1382, ("state_" * string(34)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1400, ("obs_" * string(34)), Normal(_s_.current, 1), observed = get_n(ys, 34))
    _s_.current = score(ctx, _s_, 1422, ("state_" * string(35)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__142(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 142, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 160, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    _s_.current = score(ctx, _s_, 182, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1422(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1422, ("state_" * string(35)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1440, ("obs_" * string(35)), Normal(_s_.current, 1), observed = get_n(ys, 35))
    _s_.current = score(ctx, _s_, 1462, ("state_" * string(36)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1462(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1462, ("state_" * string(36)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1480, ("obs_" * string(36)), Normal(_s_.current, 1), observed = get_n(ys, 36))
    _s_.current = score(ctx, _s_, 1502, ("state_" * string(37)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1502(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1502, ("state_" * string(37)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1520, ("obs_" * string(37)), Normal(_s_.current, 1), observed = get_n(ys, 37))
    _s_.current = score(ctx, _s_, 1542, ("state_" * string(38)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1542(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1542, ("state_" * string(38)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1560, ("obs_" * string(38)), Normal(_s_.current, 1), observed = get_n(ys, 38))
    _s_.current = score(ctx, _s_, 1582, ("state_" * string(39)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1582(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1582, ("state_" * string(39)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1600, ("obs_" * string(39)), Normal(_s_.current, 1), observed = get_n(ys, 39))
    _s_.current = score(ctx, _s_, 1622, ("state_" * string(40)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1622(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1622, ("state_" * string(40)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1640, ("obs_" * string(40)), Normal(_s_.current, 1), observed = get_n(ys, 40))
    _s_.current = score(ctx, _s_, 1662, ("state_" * string(41)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1662(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1662, ("state_" * string(41)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1680, ("obs_" * string(41)), Normal(_s_.current, 1), observed = get_n(ys, 41))
    _s_.current = score(ctx, _s_, 1702, ("state_" * string(42)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1702(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1702, ("state_" * string(42)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1720, ("obs_" * string(42)), Normal(_s_.current, 1), observed = get_n(ys, 42))
    _s_.current = score(ctx, _s_, 1742, ("state_" * string(43)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1742(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1742, ("state_" * string(43)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1760, ("obs_" * string(43)), Normal(_s_.current, 1), observed = get_n(ys, 43))
    _s_.current = score(ctx, _s_, 1782, ("state_" * string(44)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1782(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1782, ("state_" * string(44)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1800, ("obs_" * string(44)), Normal(_s_.current, 1), observed = get_n(ys, 44))
    _s_.current = score(ctx, _s_, 1822, ("state_" * string(45)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__182(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 182, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 200, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    _s_.current = score(ctx, _s_, 222, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1822(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1822, ("state_" * string(45)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1840, ("obs_" * string(45)), Normal(_s_.current, 1), observed = get_n(ys, 45))
    _s_.current = score(ctx, _s_, 1862, ("state_" * string(46)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1862(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1862, ("state_" * string(46)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1880, ("obs_" * string(46)), Normal(_s_.current, 1), observed = get_n(ys, 46))
    _s_.current = score(ctx, _s_, 1902, ("state_" * string(47)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1902(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1902, ("state_" * string(47)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1920, ("obs_" * string(47)), Normal(_s_.current, 1), observed = get_n(ys, 47))
    _s_.current = score(ctx, _s_, 1942, ("state_" * string(48)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1942(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1942, ("state_" * string(48)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1960, ("obs_" * string(48)), Normal(_s_.current, 1), observed = get_n(ys, 48))
    _s_.current = score(ctx, _s_, 1982, ("state_" * string(49)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1982(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 1982, ("state_" * string(49)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 2000, ("obs_" * string(49)), Normal(_s_.current, 1), observed = get_n(ys, 49))
    _s_.current = score(ctx, _s_, 2022, ("state_" * string(50)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__2022(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 2022, ("state_" * string(50)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 2040, ("obs_" * string(50)), Normal(_s_.current, 1), observed = get_n(ys, 50))
end

function hmm_state__222(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 222, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 240, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    _s_.current = score(ctx, _s_, 262, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__262(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 262, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 280, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    _s_.current = score(ctx, _s_, 302, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__302(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 302, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 320, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    _s_.current = score(ctx, _s_, 342, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__342(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 342, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 360, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    _s_.current = score(ctx, _s_, 382, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__382(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 382, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 400, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    _s_.current = score(ctx, _s_, 422, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__422(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 422, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 440, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))
    _s_.current = score(ctx, _s_, 462, ("state_" * string(11)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__462(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 462, ("state_" * string(11)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 480, ("obs_" * string(11)), Normal(_s_.current, 1), observed = get_n(ys, 11))
    _s_.current = score(ctx, _s_, 502, ("state_" * string(12)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__502(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 502, ("state_" * string(12)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 520, ("obs_" * string(12)), Normal(_s_.current, 1), observed = get_n(ys, 12))
    _s_.current = score(ctx, _s_, 542, ("state_" * string(13)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__542(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 542, ("state_" * string(13)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 560, ("obs_" * string(13)), Normal(_s_.current, 1), observed = get_n(ys, 13))
    _s_.current = score(ctx, _s_, 582, ("state_" * string(14)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__582(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 582, ("state_" * string(14)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 600, ("obs_" * string(14)), Normal(_s_.current, 1), observed = get_n(ys, 14))
    _s_.current = score(ctx, _s_, 622, ("state_" * string(15)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__62(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 62, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 80, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    _s_.current = score(ctx, _s_, 102, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__622(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 622, ("state_" * string(15)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 640, ("obs_" * string(15)), Normal(_s_.current, 1), observed = get_n(ys, 15))
    _s_.current = score(ctx, _s_, 662, ("state_" * string(16)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__662(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 662, ("state_" * string(16)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 680, ("obs_" * string(16)), Normal(_s_.current, 1), observed = get_n(ys, 16))
    _s_.current = score(ctx, _s_, 702, ("state_" * string(17)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__702(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 702, ("state_" * string(17)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 720, ("obs_" * string(17)), Normal(_s_.current, 1), observed = get_n(ys, 17))
    _s_.current = score(ctx, _s_, 742, ("state_" * string(18)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__742(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 742, ("state_" * string(18)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 760, ("obs_" * string(18)), Normal(_s_.current, 1), observed = get_n(ys, 18))
    _s_.current = score(ctx, _s_, 782, ("state_" * string(19)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__782(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 782, ("state_" * string(19)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 800, ("obs_" * string(19)), Normal(_s_.current, 1), observed = get_n(ys, 19))
    _s_.current = score(ctx, _s_, 822, ("state_" * string(20)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__822(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 822, ("state_" * string(20)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 840, ("obs_" * string(20)), Normal(_s_.current, 1), observed = get_n(ys, 20))
    _s_.current = score(ctx, _s_, 862, ("state_" * string(21)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__862(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 862, ("state_" * string(21)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 880, ("obs_" * string(21)), Normal(_s_.current, 1), observed = get_n(ys, 21))
    _s_.current = score(ctx, _s_, 902, ("state_" * string(22)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__902(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 902, ("state_" * string(22)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 920, ("obs_" * string(22)), Normal(_s_.current, 1), observed = get_n(ys, 22))
    _s_.current = score(ctx, _s_, 942, ("state_" * string(23)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__942(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 942, ("state_" * string(23)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 960, ("obs_" * string(23)), Normal(_s_.current, 1), observed = get_n(ys, 23))
    _s_.current = score(ctx, _s_, 982, ("state_" * string(24)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__982(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State)
    _s_.current = visit(ctx, _s_, 982, ("state_" * string(24)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1000, ("obs_" * string(24)), Normal(_s_.current, 1), observed = get_n(ys, 24))
    _s_.current = score(ctx, _s_, 1022, ("state_" * string(25)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_factor(ctx::AbstractFactorVisitContext, ys::Vector{Float64}, _s_::State, _addr_::String)
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

function hmm___start__(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    _s_.transition_probs = [0.1 0.2 0.7; 0.1 0.8 0.1; 0.3 0.3 0.4]
    _s_.current = score(ctx, _s_, 46, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = score(ctx, _s_, 62, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 80, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    return
end

function hmm_obs__1000(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1000, ("obs_" * string(24)), observed = get_n(ys, 24))
    _s_.current = score(ctx, _s_, 1022, ("state_" * string(25)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1040, ("obs_" * string(25)), Normal(_s_.current, 1), observed = get_n(ys, 25))
    return
end

function hmm_obs__1040(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1040, ("obs_" * string(25)), observed = get_n(ys, 25))
    _s_.current = score(ctx, _s_, 1062, ("state_" * string(26)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1080, ("obs_" * string(26)), Normal(_s_.current, 1), observed = get_n(ys, 26))
    return
end

function hmm_obs__1080(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1080, ("obs_" * string(26)), observed = get_n(ys, 26))
    _s_.current = score(ctx, _s_, 1102, ("state_" * string(27)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1120, ("obs_" * string(27)), Normal(_s_.current, 1), observed = get_n(ys, 27))
    return
end

function hmm_obs__1120(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1120, ("obs_" * string(27)), observed = get_n(ys, 27))
    _s_.current = score(ctx, _s_, 1142, ("state_" * string(28)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1160, ("obs_" * string(28)), Normal(_s_.current, 1), observed = get_n(ys, 28))
    return
end

function hmm_obs__1160(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1160, ("obs_" * string(28)), observed = get_n(ys, 28))
    _s_.current = score(ctx, _s_, 1182, ("state_" * string(29)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1200, ("obs_" * string(29)), Normal(_s_.current, 1), observed = get_n(ys, 29))
    return
end

function hmm_obs__120(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 120, ("obs_" * string(2)), observed = get_n(ys, 2))
    _s_.current = score(ctx, _s_, 142, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 160, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    return
end

function hmm_obs__1200(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1200, ("obs_" * string(29)), observed = get_n(ys, 29))
    _s_.current = score(ctx, _s_, 1222, ("state_" * string(30)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1240, ("obs_" * string(30)), Normal(_s_.current, 1), observed = get_n(ys, 30))
    return
end

function hmm_obs__1240(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1240, ("obs_" * string(30)), observed = get_n(ys, 30))
    _s_.current = score(ctx, _s_, 1262, ("state_" * string(31)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1280, ("obs_" * string(31)), Normal(_s_.current, 1), observed = get_n(ys, 31))
    return
end

function hmm_obs__1280(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1280, ("obs_" * string(31)), observed = get_n(ys, 31))
    _s_.current = score(ctx, _s_, 1302, ("state_" * string(32)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1320, ("obs_" * string(32)), Normal(_s_.current, 1), observed = get_n(ys, 32))
    return
end

function hmm_obs__1320(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1320, ("obs_" * string(32)), observed = get_n(ys, 32))
    _s_.current = score(ctx, _s_, 1342, ("state_" * string(33)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1360, ("obs_" * string(33)), Normal(_s_.current, 1), observed = get_n(ys, 33))
    return
end

function hmm_obs__1360(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1360, ("obs_" * string(33)), observed = get_n(ys, 33))
    _s_.current = score(ctx, _s_, 1382, ("state_" * string(34)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1400, ("obs_" * string(34)), Normal(_s_.current, 1), observed = get_n(ys, 34))
    return
end

function hmm_obs__1400(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1400, ("obs_" * string(34)), observed = get_n(ys, 34))
    _s_.current = score(ctx, _s_, 1422, ("state_" * string(35)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1440, ("obs_" * string(35)), Normal(_s_.current, 1), observed = get_n(ys, 35))
    return
end

function hmm_obs__1440(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1440, ("obs_" * string(35)), observed = get_n(ys, 35))
    _s_.current = score(ctx, _s_, 1462, ("state_" * string(36)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1480, ("obs_" * string(36)), Normal(_s_.current, 1), observed = get_n(ys, 36))
    return
end

function hmm_obs__1480(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1480, ("obs_" * string(36)), observed = get_n(ys, 36))
    _s_.current = score(ctx, _s_, 1502, ("state_" * string(37)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1520, ("obs_" * string(37)), Normal(_s_.current, 1), observed = get_n(ys, 37))
    return
end

function hmm_obs__1520(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1520, ("obs_" * string(37)), observed = get_n(ys, 37))
    _s_.current = score(ctx, _s_, 1542, ("state_" * string(38)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1560, ("obs_" * string(38)), Normal(_s_.current, 1), observed = get_n(ys, 38))
    return
end

function hmm_obs__1560(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1560, ("obs_" * string(38)), observed = get_n(ys, 38))
    _s_.current = score(ctx, _s_, 1582, ("state_" * string(39)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1600, ("obs_" * string(39)), Normal(_s_.current, 1), observed = get_n(ys, 39))
    return
end

function hmm_obs__160(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 160, ("obs_" * string(3)), observed = get_n(ys, 3))
    _s_.current = score(ctx, _s_, 182, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 200, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    return
end

function hmm_obs__1600(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1600, ("obs_" * string(39)), observed = get_n(ys, 39))
    _s_.current = score(ctx, _s_, 1622, ("state_" * string(40)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1640, ("obs_" * string(40)), Normal(_s_.current, 1), observed = get_n(ys, 40))
    return
end

function hmm_obs__1640(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1640, ("obs_" * string(40)), observed = get_n(ys, 40))
    _s_.current = score(ctx, _s_, 1662, ("state_" * string(41)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1680, ("obs_" * string(41)), Normal(_s_.current, 1), observed = get_n(ys, 41))
    return
end

function hmm_obs__1680(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1680, ("obs_" * string(41)), observed = get_n(ys, 41))
    _s_.current = score(ctx, _s_, 1702, ("state_" * string(42)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1720, ("obs_" * string(42)), Normal(_s_.current, 1), observed = get_n(ys, 42))
    return
end

function hmm_obs__1720(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1720, ("obs_" * string(42)), observed = get_n(ys, 42))
    _s_.current = score(ctx, _s_, 1742, ("state_" * string(43)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1760, ("obs_" * string(43)), Normal(_s_.current, 1), observed = get_n(ys, 43))
    return
end

function hmm_obs__1760(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1760, ("obs_" * string(43)), observed = get_n(ys, 43))
    _s_.current = score(ctx, _s_, 1782, ("state_" * string(44)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1800, ("obs_" * string(44)), Normal(_s_.current, 1), observed = get_n(ys, 44))
    return
end

function hmm_obs__1800(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1800, ("obs_" * string(44)), observed = get_n(ys, 44))
    _s_.current = score(ctx, _s_, 1822, ("state_" * string(45)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1840, ("obs_" * string(45)), Normal(_s_.current, 1), observed = get_n(ys, 45))
    return
end

function hmm_obs__1840(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1840, ("obs_" * string(45)), observed = get_n(ys, 45))
    _s_.current = score(ctx, _s_, 1862, ("state_" * string(46)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1880, ("obs_" * string(46)), Normal(_s_.current, 1), observed = get_n(ys, 46))
    return
end

function hmm_obs__1880(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1880, ("obs_" * string(46)), observed = get_n(ys, 46))
    _s_.current = score(ctx, _s_, 1902, ("state_" * string(47)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1920, ("obs_" * string(47)), Normal(_s_.current, 1), observed = get_n(ys, 47))
    return
end

function hmm_obs__1920(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1920, ("obs_" * string(47)), observed = get_n(ys, 47))
    _s_.current = score(ctx, _s_, 1942, ("state_" * string(48)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1960, ("obs_" * string(48)), Normal(_s_.current, 1), observed = get_n(ys, 48))
    return
end

function hmm_obs__1960(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 1960, ("obs_" * string(48)), observed = get_n(ys, 48))
    _s_.current = score(ctx, _s_, 1982, ("state_" * string(49)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 2000, ("obs_" * string(49)), Normal(_s_.current, 1), observed = get_n(ys, 49))
    return
end

function hmm_obs__200(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 200, ("obs_" * string(4)), observed = get_n(ys, 4))
    _s_.current = score(ctx, _s_, 222, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 240, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    return
end

function hmm_obs__2000(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 2000, ("obs_" * string(49)), observed = get_n(ys, 49))
    _s_.current = score(ctx, _s_, 2022, ("state_" * string(50)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 2040, ("obs_" * string(50)), Normal(_s_.current, 1), observed = get_n(ys, 50))
    return
end

function hmm_obs__2040(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 2040, ("obs_" * string(50)), observed = get_n(ys, 50))
    _s_.node_id = -1
    return
end

function hmm_obs__240(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 240, ("obs_" * string(5)), observed = get_n(ys, 5))
    _s_.current = score(ctx, _s_, 262, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 280, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    return
end

function hmm_obs__280(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 280, ("obs_" * string(6)), observed = get_n(ys, 6))
    _s_.current = score(ctx, _s_, 302, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 320, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    return
end

function hmm_obs__320(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 320, ("obs_" * string(7)), observed = get_n(ys, 7))
    _s_.current = score(ctx, _s_, 342, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 360, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    return
end

function hmm_obs__360(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 360, ("obs_" * string(8)), observed = get_n(ys, 8))
    _s_.current = score(ctx, _s_, 382, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 400, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    return
end

function hmm_obs__400(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 400, ("obs_" * string(9)), observed = get_n(ys, 9))
    _s_.current = score(ctx, _s_, 422, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 440, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))
    return
end

function hmm_obs__440(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 440, ("obs_" * string(10)), observed = get_n(ys, 10))
    _s_.current = score(ctx, _s_, 462, ("state_" * string(11)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 480, ("obs_" * string(11)), Normal(_s_.current, 1), observed = get_n(ys, 11))
    return
end

function hmm_obs__480(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 480, ("obs_" * string(11)), observed = get_n(ys, 11))
    _s_.current = score(ctx, _s_, 502, ("state_" * string(12)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 520, ("obs_" * string(12)), Normal(_s_.current, 1), observed = get_n(ys, 12))
    return
end

function hmm_obs__520(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 520, ("obs_" * string(12)), observed = get_n(ys, 12))
    _s_.current = score(ctx, _s_, 542, ("state_" * string(13)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 560, ("obs_" * string(13)), Normal(_s_.current, 1), observed = get_n(ys, 13))
    return
end

function hmm_obs__560(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 560, ("obs_" * string(13)), observed = get_n(ys, 13))
    _s_.current = score(ctx, _s_, 582, ("state_" * string(14)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 600, ("obs_" * string(14)), Normal(_s_.current, 1), observed = get_n(ys, 14))
    return
end

function hmm_obs__600(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 600, ("obs_" * string(14)), observed = get_n(ys, 14))
    _s_.current = score(ctx, _s_, 622, ("state_" * string(15)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 640, ("obs_" * string(15)), Normal(_s_.current, 1), observed = get_n(ys, 15))
    return
end

function hmm_obs__640(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 640, ("obs_" * string(15)), observed = get_n(ys, 15))
    _s_.current = score(ctx, _s_, 662, ("state_" * string(16)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 680, ("obs_" * string(16)), Normal(_s_.current, 1), observed = get_n(ys, 16))
    return
end

function hmm_obs__680(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 680, ("obs_" * string(16)), observed = get_n(ys, 16))
    _s_.current = score(ctx, _s_, 702, ("state_" * string(17)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 720, ("obs_" * string(17)), Normal(_s_.current, 1), observed = get_n(ys, 17))
    return
end

function hmm_obs__720(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 720, ("obs_" * string(17)), observed = get_n(ys, 17))
    _s_.current = score(ctx, _s_, 742, ("state_" * string(18)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 760, ("obs_" * string(18)), Normal(_s_.current, 1), observed = get_n(ys, 18))
    return
end

function hmm_obs__760(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 760, ("obs_" * string(18)), observed = get_n(ys, 18))
    _s_.current = score(ctx, _s_, 782, ("state_" * string(19)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 800, ("obs_" * string(19)), Normal(_s_.current, 1), observed = get_n(ys, 19))
    return
end

function hmm_obs__80(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 80, ("obs_" * string(1)), observed = get_n(ys, 1))
    _s_.current = score(ctx, _s_, 102, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 120, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    return
end

function hmm_obs__800(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 800, ("obs_" * string(19)), observed = get_n(ys, 19))
    _s_.current = score(ctx, _s_, 822, ("state_" * string(20)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 840, ("obs_" * string(20)), Normal(_s_.current, 1), observed = get_n(ys, 20))
    return
end

function hmm_obs__840(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 840, ("obs_" * string(20)), observed = get_n(ys, 20))
    _s_.current = score(ctx, _s_, 862, ("state_" * string(21)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 880, ("obs_" * string(21)), Normal(_s_.current, 1), observed = get_n(ys, 21))
    return
end

function hmm_obs__880(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 880, ("obs_" * string(21)), observed = get_n(ys, 21))
    _s_.current = score(ctx, _s_, 902, ("state_" * string(22)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 920, ("obs_" * string(22)), Normal(_s_.current, 1), observed = get_n(ys, 22))
    return
end

function hmm_obs__920(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 920, ("obs_" * string(22)), observed = get_n(ys, 22))
    _s_.current = score(ctx, _s_, 942, ("state_" * string(23)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 960, ("obs_" * string(23)), Normal(_s_.current, 1), observed = get_n(ys, 23))
    return
end

function hmm_obs__960(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State)
    read_trace(ctx, _s_, 960, ("obs_" * string(23)), observed = get_n(ys, 23))
    _s_.current = score(ctx, _s_, 982, ("state_" * string(24)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1000, ("obs_" * string(24)), Normal(_s_.current, 1), observed = get_n(ys, 24))
    return
end

function hmm_resume(ctx::AbstractFactorResumeContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 0
        return hmm___start__(ctx, ys, _s_)
    end
    if _s_.node_id == 1000
        return hmm_obs__1000(ctx, ys, _s_)
    end
    if _s_.node_id == 1040
        return hmm_obs__1040(ctx, ys, _s_)
    end
    if _s_.node_id == 1080
        return hmm_obs__1080(ctx, ys, _s_)
    end
    if _s_.node_id == 1120
        return hmm_obs__1120(ctx, ys, _s_)
    end
    if _s_.node_id == 1160
        return hmm_obs__1160(ctx, ys, _s_)
    end
    if _s_.node_id == 120
        return hmm_obs__120(ctx, ys, _s_)
    end
    if _s_.node_id == 1200
        return hmm_obs__1200(ctx, ys, _s_)
    end
    if _s_.node_id == 1240
        return hmm_obs__1240(ctx, ys, _s_)
    end
    if _s_.node_id == 1280
        return hmm_obs__1280(ctx, ys, _s_)
    end
    if _s_.node_id == 1320
        return hmm_obs__1320(ctx, ys, _s_)
    end
    if _s_.node_id == 1360
        return hmm_obs__1360(ctx, ys, _s_)
    end
    if _s_.node_id == 1400
        return hmm_obs__1400(ctx, ys, _s_)
    end
    if _s_.node_id == 1440
        return hmm_obs__1440(ctx, ys, _s_)
    end
    if _s_.node_id == 1480
        return hmm_obs__1480(ctx, ys, _s_)
    end
    if _s_.node_id == 1520
        return hmm_obs__1520(ctx, ys, _s_)
    end
    if _s_.node_id == 1560
        return hmm_obs__1560(ctx, ys, _s_)
    end
    if _s_.node_id == 160
        return hmm_obs__160(ctx, ys, _s_)
    end
    if _s_.node_id == 1600
        return hmm_obs__1600(ctx, ys, _s_)
    end
    if _s_.node_id == 1640
        return hmm_obs__1640(ctx, ys, _s_)
    end
    if _s_.node_id == 1680
        return hmm_obs__1680(ctx, ys, _s_)
    end
    if _s_.node_id == 1720
        return hmm_obs__1720(ctx, ys, _s_)
    end
    if _s_.node_id == 1760
        return hmm_obs__1760(ctx, ys, _s_)
    end
    if _s_.node_id == 1800
        return hmm_obs__1800(ctx, ys, _s_)
    end
    if _s_.node_id == 1840
        return hmm_obs__1840(ctx, ys, _s_)
    end
    if _s_.node_id == 1880
        return hmm_obs__1880(ctx, ys, _s_)
    end
    if _s_.node_id == 1920
        return hmm_obs__1920(ctx, ys, _s_)
    end
    if _s_.node_id == 1960
        return hmm_obs__1960(ctx, ys, _s_)
    end
    if _s_.node_id == 200
        return hmm_obs__200(ctx, ys, _s_)
    end
    if _s_.node_id == 2000
        return hmm_obs__2000(ctx, ys, _s_)
    end
    if _s_.node_id == 2040
        return hmm_obs__2040(ctx, ys, _s_)
    end
    if _s_.node_id == 240
        return hmm_obs__240(ctx, ys, _s_)
    end
    if _s_.node_id == 280
        return hmm_obs__280(ctx, ys, _s_)
    end
    if _s_.node_id == 320
        return hmm_obs__320(ctx, ys, _s_)
    end
    if _s_.node_id == 360
        return hmm_obs__360(ctx, ys, _s_)
    end
    if _s_.node_id == 400
        return hmm_obs__400(ctx, ys, _s_)
    end
    if _s_.node_id == 440
        return hmm_obs__440(ctx, ys, _s_)
    end
    if _s_.node_id == 480
        return hmm_obs__480(ctx, ys, _s_)
    end
    if _s_.node_id == 520
        return hmm_obs__520(ctx, ys, _s_)
    end
    if _s_.node_id == 560
        return hmm_obs__560(ctx, ys, _s_)
    end
    if _s_.node_id == 600
        return hmm_obs__600(ctx, ys, _s_)
    end
    if _s_.node_id == 640
        return hmm_obs__640(ctx, ys, _s_)
    end
    if _s_.node_id == 680
        return hmm_obs__680(ctx, ys, _s_)
    end
    if _s_.node_id == 720
        return hmm_obs__720(ctx, ys, _s_)
    end
    if _s_.node_id == 760
        return hmm_obs__760(ctx, ys, _s_)
    end
    if _s_.node_id == 80
        return hmm_obs__80(ctx, ys, _s_)
    end
    if _s_.node_id == 800
        return hmm_obs__800(ctx, ys, _s_)
    end
    if _s_.node_id == 840
        return hmm_obs__840(ctx, ys, _s_)
    end
    if _s_.node_id == 880
        return hmm_obs__880(ctx, ys, _s_)
    end
    if _s_.node_id == 920
        return hmm_obs__920(ctx, ys, _s_)
    end
    if _s_.node_id == 960
        return hmm_obs__960(ctx, ys, _s_)
    end
    _s_.node_id = -1 # marks termination
end

function model(ctx::SampleContext)
    return hmm(ctx, ys)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return hmm(ctx, ys, _s_)
end

function factor(ctx::AbstractFactorVisitContext, _s_::State, _addr_::String)
    return hmm_factor(ctx, ys, _s_, _addr_)
end

function resume_from_state(ctx::AbstractFactorResumeContext, _s_::State, _addr_::String)
    return hmm_resume(ctx, ys, _s_, _addr_)
end

