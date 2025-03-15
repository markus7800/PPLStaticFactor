# this file is auto-generated

include("../hmm_fixed_seqlen.jl")

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
    _s_.current::Int = sample_record_state(ctx, _s_, 50, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = sample_record_state(ctx, _s_, 66, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 84, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    _s_.current = sample_record_state(ctx, _s_, 106, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 124, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    _s_.current = sample_record_state(ctx, _s_, 146, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 164, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    _s_.current = sample_record_state(ctx, _s_, 186, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 204, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    _s_.current = sample_record_state(ctx, _s_, 226, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 244, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    _s_.current = sample_record_state(ctx, _s_, 266, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 284, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    _s_.current = sample_record_state(ctx, _s_, 306, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 324, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    _s_.current = sample_record_state(ctx, _s_, 346, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 364, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    _s_.current = sample_record_state(ctx, _s_, 386, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 404, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    _s_.current = sample_record_state(ctx, _s_, 426, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 444, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))
    _s_.current = sample_record_state(ctx, _s_, 466, ("state_" * string(11)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 484, ("obs_" * string(11)), Normal(_s_.current, 1), observed = get_n(ys, 11))
    _s_.current = sample_record_state(ctx, _s_, 506, ("state_" * string(12)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 524, ("obs_" * string(12)), Normal(_s_.current, 1), observed = get_n(ys, 12))
    _s_.current = sample_record_state(ctx, _s_, 546, ("state_" * string(13)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 564, ("obs_" * string(13)), Normal(_s_.current, 1), observed = get_n(ys, 13))
    _s_.current = sample_record_state(ctx, _s_, 586, ("state_" * string(14)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 604, ("obs_" * string(14)), Normal(_s_.current, 1), observed = get_n(ys, 14))
    _s_.current = sample_record_state(ctx, _s_, 626, ("state_" * string(15)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 644, ("obs_" * string(15)), Normal(_s_.current, 1), observed = get_n(ys, 15))
    _s_.current = sample_record_state(ctx, _s_, 666, ("state_" * string(16)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 684, ("obs_" * string(16)), Normal(_s_.current, 1), observed = get_n(ys, 16))
    _s_.current = sample_record_state(ctx, _s_, 706, ("state_" * string(17)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 724, ("obs_" * string(17)), Normal(_s_.current, 1), observed = get_n(ys, 17))
    _s_.current = sample_record_state(ctx, _s_, 746, ("state_" * string(18)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 764, ("obs_" * string(18)), Normal(_s_.current, 1), observed = get_n(ys, 18))
    _s_.current = sample_record_state(ctx, _s_, 786, ("state_" * string(19)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 804, ("obs_" * string(19)), Normal(_s_.current, 1), observed = get_n(ys, 19))
    _s_.current = sample_record_state(ctx, _s_, 826, ("state_" * string(20)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 844, ("obs_" * string(20)), Normal(_s_.current, 1), observed = get_n(ys, 20))
    _s_.current = sample_record_state(ctx, _s_, 866, ("state_" * string(21)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 884, ("obs_" * string(21)), Normal(_s_.current, 1), observed = get_n(ys, 21))
    _s_.current = sample_record_state(ctx, _s_, 906, ("state_" * string(22)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 924, ("obs_" * string(22)), Normal(_s_.current, 1), observed = get_n(ys, 22))
    _s_.current = sample_record_state(ctx, _s_, 946, ("state_" * string(23)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 964, ("obs_" * string(23)), Normal(_s_.current, 1), observed = get_n(ys, 23))
    _s_.current = sample_record_state(ctx, _s_, 986, ("state_" * string(24)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1004, ("obs_" * string(24)), Normal(_s_.current, 1), observed = get_n(ys, 24))
    _s_.current = sample_record_state(ctx, _s_, 1026, ("state_" * string(25)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1044, ("obs_" * string(25)), Normal(_s_.current, 1), observed = get_n(ys, 25))
    _s_.current = sample_record_state(ctx, _s_, 1066, ("state_" * string(26)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1084, ("obs_" * string(26)), Normal(_s_.current, 1), observed = get_n(ys, 26))
    _s_.current = sample_record_state(ctx, _s_, 1106, ("state_" * string(27)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1124, ("obs_" * string(27)), Normal(_s_.current, 1), observed = get_n(ys, 27))
    _s_.current = sample_record_state(ctx, _s_, 1146, ("state_" * string(28)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1164, ("obs_" * string(28)), Normal(_s_.current, 1), observed = get_n(ys, 28))
    _s_.current = sample_record_state(ctx, _s_, 1186, ("state_" * string(29)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1204, ("obs_" * string(29)), Normal(_s_.current, 1), observed = get_n(ys, 29))
    _s_.current = sample_record_state(ctx, _s_, 1226, ("state_" * string(30)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1244, ("obs_" * string(30)), Normal(_s_.current, 1), observed = get_n(ys, 30))
    _s_.current = sample_record_state(ctx, _s_, 1266, ("state_" * string(31)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1284, ("obs_" * string(31)), Normal(_s_.current, 1), observed = get_n(ys, 31))
    _s_.current = sample_record_state(ctx, _s_, 1306, ("state_" * string(32)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1324, ("obs_" * string(32)), Normal(_s_.current, 1), observed = get_n(ys, 32))
    _s_.current = sample_record_state(ctx, _s_, 1346, ("state_" * string(33)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1364, ("obs_" * string(33)), Normal(_s_.current, 1), observed = get_n(ys, 33))
    _s_.current = sample_record_state(ctx, _s_, 1386, ("state_" * string(34)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1404, ("obs_" * string(34)), Normal(_s_.current, 1), observed = get_n(ys, 34))
    _s_.current = sample_record_state(ctx, _s_, 1426, ("state_" * string(35)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1444, ("obs_" * string(35)), Normal(_s_.current, 1), observed = get_n(ys, 35))
    _s_.current = sample_record_state(ctx, _s_, 1466, ("state_" * string(36)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1484, ("obs_" * string(36)), Normal(_s_.current, 1), observed = get_n(ys, 36))
    _s_.current = sample_record_state(ctx, _s_, 1506, ("state_" * string(37)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1524, ("obs_" * string(37)), Normal(_s_.current, 1), observed = get_n(ys, 37))
    _s_.current = sample_record_state(ctx, _s_, 1546, ("state_" * string(38)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1564, ("obs_" * string(38)), Normal(_s_.current, 1), observed = get_n(ys, 38))
    _s_.current = sample_record_state(ctx, _s_, 1586, ("state_" * string(39)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1604, ("obs_" * string(39)), Normal(_s_.current, 1), observed = get_n(ys, 39))
    _s_.current = sample_record_state(ctx, _s_, 1626, ("state_" * string(40)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1644, ("obs_" * string(40)), Normal(_s_.current, 1), observed = get_n(ys, 40))
    _s_.current = sample_record_state(ctx, _s_, 1666, ("state_" * string(41)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1684, ("obs_" * string(41)), Normal(_s_.current, 1), observed = get_n(ys, 41))
    _s_.current = sample_record_state(ctx, _s_, 1706, ("state_" * string(42)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1724, ("obs_" * string(42)), Normal(_s_.current, 1), observed = get_n(ys, 42))
    _s_.current = sample_record_state(ctx, _s_, 1746, ("state_" * string(43)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1764, ("obs_" * string(43)), Normal(_s_.current, 1), observed = get_n(ys, 43))
    _s_.current = sample_record_state(ctx, _s_, 1786, ("state_" * string(44)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1804, ("obs_" * string(44)), Normal(_s_.current, 1), observed = get_n(ys, 44))
    _s_.current = sample_record_state(ctx, _s_, 1826, ("state_" * string(45)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1844, ("obs_" * string(45)), Normal(_s_.current, 1), observed = get_n(ys, 45))
    _s_.current = sample_record_state(ctx, _s_, 1866, ("state_" * string(46)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1884, ("obs_" * string(46)), Normal(_s_.current, 1), observed = get_n(ys, 46))
    _s_.current = sample_record_state(ctx, _s_, 1906, ("state_" * string(47)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1924, ("obs_" * string(47)), Normal(_s_.current, 1), observed = get_n(ys, 47))
    _s_.current = sample_record_state(ctx, _s_, 1946, ("state_" * string(48)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 1964, ("obs_" * string(48)), Normal(_s_.current, 1), observed = get_n(ys, 48))
    _s_.current = sample_record_state(ctx, _s_, 1986, ("state_" * string(49)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 2004, ("obs_" * string(49)), Normal(_s_.current, 1), observed = get_n(ys, 49))
    _s_.current = sample_record_state(ctx, _s_, 2026, ("state_" * string(50)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    _ = sample_record_state(ctx, _s_, 2044, ("obs_" * string(50)), Normal(_s_.current, 1), observed = get_n(ys, 50))

end

function hmm_initial_state_50(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 50, "initial_state", Categorical([0.33, 0.33, 0.34]))
    _s_.current = score(ctx, _s_, 66, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1026(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1026, ("state_" * string(25)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1044, ("obs_" * string(25)), Normal(_s_.current, 1), observed = get_n(ys, 25))
    _s_.current = score(ctx, _s_, 1066, ("state_" * string(26)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__106(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 106, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 124, ("obs_" * string(2)), Normal(_s_.current, 1), observed = get_n(ys, 2))
    _s_.current = score(ctx, _s_, 146, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1066(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1066, ("state_" * string(26)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1084, ("obs_" * string(26)), Normal(_s_.current, 1), observed = get_n(ys, 26))
    _s_.current = score(ctx, _s_, 1106, ("state_" * string(27)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1106(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1106, ("state_" * string(27)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1124, ("obs_" * string(27)), Normal(_s_.current, 1), observed = get_n(ys, 27))
    _s_.current = score(ctx, _s_, 1146, ("state_" * string(28)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1146(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1146, ("state_" * string(28)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1164, ("obs_" * string(28)), Normal(_s_.current, 1), observed = get_n(ys, 28))
    _s_.current = score(ctx, _s_, 1186, ("state_" * string(29)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1186(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1186, ("state_" * string(29)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1204, ("obs_" * string(29)), Normal(_s_.current, 1), observed = get_n(ys, 29))
    _s_.current = score(ctx, _s_, 1226, ("state_" * string(30)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1226(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1226, ("state_" * string(30)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1244, ("obs_" * string(30)), Normal(_s_.current, 1), observed = get_n(ys, 30))
    _s_.current = score(ctx, _s_, 1266, ("state_" * string(31)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1266(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1266, ("state_" * string(31)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1284, ("obs_" * string(31)), Normal(_s_.current, 1), observed = get_n(ys, 31))
    _s_.current = score(ctx, _s_, 1306, ("state_" * string(32)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1306(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1306, ("state_" * string(32)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1324, ("obs_" * string(32)), Normal(_s_.current, 1), observed = get_n(ys, 32))
    _s_.current = score(ctx, _s_, 1346, ("state_" * string(33)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1346(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1346, ("state_" * string(33)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1364, ("obs_" * string(33)), Normal(_s_.current, 1), observed = get_n(ys, 33))
    _s_.current = score(ctx, _s_, 1386, ("state_" * string(34)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1386(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1386, ("state_" * string(34)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1404, ("obs_" * string(34)), Normal(_s_.current, 1), observed = get_n(ys, 34))
    _s_.current = score(ctx, _s_, 1426, ("state_" * string(35)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1426(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1426, ("state_" * string(35)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1444, ("obs_" * string(35)), Normal(_s_.current, 1), observed = get_n(ys, 35))
    _s_.current = score(ctx, _s_, 1466, ("state_" * string(36)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__146(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 146, ("state_" * string(3)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 164, ("obs_" * string(3)), Normal(_s_.current, 1), observed = get_n(ys, 3))
    _s_.current = score(ctx, _s_, 186, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1466(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1466, ("state_" * string(36)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1484, ("obs_" * string(36)), Normal(_s_.current, 1), observed = get_n(ys, 36))
    _s_.current = score(ctx, _s_, 1506, ("state_" * string(37)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1506(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1506, ("state_" * string(37)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1524, ("obs_" * string(37)), Normal(_s_.current, 1), observed = get_n(ys, 37))
    _s_.current = score(ctx, _s_, 1546, ("state_" * string(38)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1546(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1546, ("state_" * string(38)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1564, ("obs_" * string(38)), Normal(_s_.current, 1), observed = get_n(ys, 38))
    _s_.current = score(ctx, _s_, 1586, ("state_" * string(39)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1586(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1586, ("state_" * string(39)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1604, ("obs_" * string(39)), Normal(_s_.current, 1), observed = get_n(ys, 39))
    _s_.current = score(ctx, _s_, 1626, ("state_" * string(40)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1626(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1626, ("state_" * string(40)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1644, ("obs_" * string(40)), Normal(_s_.current, 1), observed = get_n(ys, 40))
    _s_.current = score(ctx, _s_, 1666, ("state_" * string(41)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1666(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1666, ("state_" * string(41)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1684, ("obs_" * string(41)), Normal(_s_.current, 1), observed = get_n(ys, 41))
    _s_.current = score(ctx, _s_, 1706, ("state_" * string(42)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1706(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1706, ("state_" * string(42)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1724, ("obs_" * string(42)), Normal(_s_.current, 1), observed = get_n(ys, 42))
    _s_.current = score(ctx, _s_, 1746, ("state_" * string(43)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1746(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1746, ("state_" * string(43)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1764, ("obs_" * string(43)), Normal(_s_.current, 1), observed = get_n(ys, 43))
    _s_.current = score(ctx, _s_, 1786, ("state_" * string(44)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1786(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1786, ("state_" * string(44)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1804, ("obs_" * string(44)), Normal(_s_.current, 1), observed = get_n(ys, 44))
    _s_.current = score(ctx, _s_, 1826, ("state_" * string(45)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1826(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1826, ("state_" * string(45)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1844, ("obs_" * string(45)), Normal(_s_.current, 1), observed = get_n(ys, 45))
    _s_.current = score(ctx, _s_, 1866, ("state_" * string(46)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__186(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 186, ("state_" * string(4)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 204, ("obs_" * string(4)), Normal(_s_.current, 1), observed = get_n(ys, 4))
    _s_.current = score(ctx, _s_, 226, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1866(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1866, ("state_" * string(46)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1884, ("obs_" * string(46)), Normal(_s_.current, 1), observed = get_n(ys, 46))
    _s_.current = score(ctx, _s_, 1906, ("state_" * string(47)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1906(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1906, ("state_" * string(47)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1924, ("obs_" * string(47)), Normal(_s_.current, 1), observed = get_n(ys, 47))
    _s_.current = score(ctx, _s_, 1946, ("state_" * string(48)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1946(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1946, ("state_" * string(48)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1964, ("obs_" * string(48)), Normal(_s_.current, 1), observed = get_n(ys, 48))
    _s_.current = score(ctx, _s_, 1986, ("state_" * string(49)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__1986(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 1986, ("state_" * string(49)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 2004, ("obs_" * string(49)), Normal(_s_.current, 1), observed = get_n(ys, 49))
    _s_.current = score(ctx, _s_, 2026, ("state_" * string(50)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__2026(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 2026, ("state_" * string(50)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 2044, ("obs_" * string(50)), Normal(_s_.current, 1), observed = get_n(ys, 50))
end

function hmm_state__226(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 226, ("state_" * string(5)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 244, ("obs_" * string(5)), Normal(_s_.current, 1), observed = get_n(ys, 5))
    _s_.current = score(ctx, _s_, 266, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__266(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 266, ("state_" * string(6)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 284, ("obs_" * string(6)), Normal(_s_.current, 1), observed = get_n(ys, 6))
    _s_.current = score(ctx, _s_, 306, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__306(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 306, ("state_" * string(7)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 324, ("obs_" * string(7)), Normal(_s_.current, 1), observed = get_n(ys, 7))
    _s_.current = score(ctx, _s_, 346, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__346(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 346, ("state_" * string(8)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 364, ("obs_" * string(8)), Normal(_s_.current, 1), observed = get_n(ys, 8))
    _s_.current = score(ctx, _s_, 386, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__386(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 386, ("state_" * string(9)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 404, ("obs_" * string(9)), Normal(_s_.current, 1), observed = get_n(ys, 9))
    _s_.current = score(ctx, _s_, 426, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__426(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 426, ("state_" * string(10)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 444, ("obs_" * string(10)), Normal(_s_.current, 1), observed = get_n(ys, 10))
    _s_.current = score(ctx, _s_, 466, ("state_" * string(11)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__466(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 466, ("state_" * string(11)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 484, ("obs_" * string(11)), Normal(_s_.current, 1), observed = get_n(ys, 11))
    _s_.current = score(ctx, _s_, 506, ("state_" * string(12)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__506(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 506, ("state_" * string(12)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 524, ("obs_" * string(12)), Normal(_s_.current, 1), observed = get_n(ys, 12))
    _s_.current = score(ctx, _s_, 546, ("state_" * string(13)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__546(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 546, ("state_" * string(13)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 564, ("obs_" * string(13)), Normal(_s_.current, 1), observed = get_n(ys, 13))
    _s_.current = score(ctx, _s_, 586, ("state_" * string(14)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__586(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 586, ("state_" * string(14)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 604, ("obs_" * string(14)), Normal(_s_.current, 1), observed = get_n(ys, 14))
    _s_.current = score(ctx, _s_, 626, ("state_" * string(15)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__626(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 626, ("state_" * string(15)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 644, ("obs_" * string(15)), Normal(_s_.current, 1), observed = get_n(ys, 15))
    _s_.current = score(ctx, _s_, 666, ("state_" * string(16)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__66(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 66, ("state_" * string(1)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 84, ("obs_" * string(1)), Normal(_s_.current, 1), observed = get_n(ys, 1))
    _s_.current = score(ctx, _s_, 106, ("state_" * string(2)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__666(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 666, ("state_" * string(16)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 684, ("obs_" * string(16)), Normal(_s_.current, 1), observed = get_n(ys, 16))
    _s_.current = score(ctx, _s_, 706, ("state_" * string(17)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__706(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 706, ("state_" * string(17)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 724, ("obs_" * string(17)), Normal(_s_.current, 1), observed = get_n(ys, 17))
    _s_.current = score(ctx, _s_, 746, ("state_" * string(18)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__746(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 746, ("state_" * string(18)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 764, ("obs_" * string(18)), Normal(_s_.current, 1), observed = get_n(ys, 18))
    _s_.current = score(ctx, _s_, 786, ("state_" * string(19)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__786(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 786, ("state_" * string(19)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 804, ("obs_" * string(19)), Normal(_s_.current, 1), observed = get_n(ys, 19))
    _s_.current = score(ctx, _s_, 826, ("state_" * string(20)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__826(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 826, ("state_" * string(20)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 844, ("obs_" * string(20)), Normal(_s_.current, 1), observed = get_n(ys, 20))
    _s_.current = score(ctx, _s_, 866, ("state_" * string(21)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__866(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 866, ("state_" * string(21)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 884, ("obs_" * string(21)), Normal(_s_.current, 1), observed = get_n(ys, 21))
    _s_.current = score(ctx, _s_, 906, ("state_" * string(22)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__906(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 906, ("state_" * string(22)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 924, ("obs_" * string(22)), Normal(_s_.current, 1), observed = get_n(ys, 22))
    _s_.current = score(ctx, _s_, 946, ("state_" * string(23)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__946(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 946, ("state_" * string(23)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 964, ("obs_" * string(23)), Normal(_s_.current, 1), observed = get_n(ys, 23))
    _s_.current = score(ctx, _s_, 986, ("state_" * string(24)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_state__986(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State)
    _s_.current = resample(ctx, _s_, 986, ("state_" * string(24)), Categorical(get_row(_s_.transition_probs, _s_.current)))
    score(ctx, _s_, 1004, ("obs_" * string(24)), Normal(_s_.current, 1), observed = get_n(ys, 24))
    _s_.current = score(ctx, _s_, 1026, ("state_" * string(25)), Categorical(get_row(_s_.transition_probs, _s_.current)))
end

function hmm_factor(ctx::AbstractFactorResampleContext, ys::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 50
        return hmm_initial_state_50(ctx, ys, _s_)
    end
    if _s_.node_id == 1026
        return hmm_state__1026(ctx, ys, _s_)
    end
    if _s_.node_id == 106
        return hmm_state__106(ctx, ys, _s_)
    end
    if _s_.node_id == 1066
        return hmm_state__1066(ctx, ys, _s_)
    end
    if _s_.node_id == 1106
        return hmm_state__1106(ctx, ys, _s_)
    end
    if _s_.node_id == 1146
        return hmm_state__1146(ctx, ys, _s_)
    end
    if _s_.node_id == 1186
        return hmm_state__1186(ctx, ys, _s_)
    end
    if _s_.node_id == 1226
        return hmm_state__1226(ctx, ys, _s_)
    end
    if _s_.node_id == 1266
        return hmm_state__1266(ctx, ys, _s_)
    end
    if _s_.node_id == 1306
        return hmm_state__1306(ctx, ys, _s_)
    end
    if _s_.node_id == 1346
        return hmm_state__1346(ctx, ys, _s_)
    end
    if _s_.node_id == 1386
        return hmm_state__1386(ctx, ys, _s_)
    end
    if _s_.node_id == 1426
        return hmm_state__1426(ctx, ys, _s_)
    end
    if _s_.node_id == 146
        return hmm_state__146(ctx, ys, _s_)
    end
    if _s_.node_id == 1466
        return hmm_state__1466(ctx, ys, _s_)
    end
    if _s_.node_id == 1506
        return hmm_state__1506(ctx, ys, _s_)
    end
    if _s_.node_id == 1546
        return hmm_state__1546(ctx, ys, _s_)
    end
    if _s_.node_id == 1586
        return hmm_state__1586(ctx, ys, _s_)
    end
    if _s_.node_id == 1626
        return hmm_state__1626(ctx, ys, _s_)
    end
    if _s_.node_id == 1666
        return hmm_state__1666(ctx, ys, _s_)
    end
    if _s_.node_id == 1706
        return hmm_state__1706(ctx, ys, _s_)
    end
    if _s_.node_id == 1746
        return hmm_state__1746(ctx, ys, _s_)
    end
    if _s_.node_id == 1786
        return hmm_state__1786(ctx, ys, _s_)
    end
    if _s_.node_id == 1826
        return hmm_state__1826(ctx, ys, _s_)
    end
    if _s_.node_id == 186
        return hmm_state__186(ctx, ys, _s_)
    end
    if _s_.node_id == 1866
        return hmm_state__1866(ctx, ys, _s_)
    end
    if _s_.node_id == 1906
        return hmm_state__1906(ctx, ys, _s_)
    end
    if _s_.node_id == 1946
        return hmm_state__1946(ctx, ys, _s_)
    end
    if _s_.node_id == 1986
        return hmm_state__1986(ctx, ys, _s_)
    end
    if _s_.node_id == 2026
        return hmm_state__2026(ctx, ys, _s_)
    end
    if _s_.node_id == 226
        return hmm_state__226(ctx, ys, _s_)
    end
    if _s_.node_id == 266
        return hmm_state__266(ctx, ys, _s_)
    end
    if _s_.node_id == 306
        return hmm_state__306(ctx, ys, _s_)
    end
    if _s_.node_id == 346
        return hmm_state__346(ctx, ys, _s_)
    end
    if _s_.node_id == 386
        return hmm_state__386(ctx, ys, _s_)
    end
    if _s_.node_id == 426
        return hmm_state__426(ctx, ys, _s_)
    end
    if _s_.node_id == 466
        return hmm_state__466(ctx, ys, _s_)
    end
    if _s_.node_id == 506
        return hmm_state__506(ctx, ys, _s_)
    end
    if _s_.node_id == 546
        return hmm_state__546(ctx, ys, _s_)
    end
    if _s_.node_id == 586
        return hmm_state__586(ctx, ys, _s_)
    end
    if _s_.node_id == 626
        return hmm_state__626(ctx, ys, _s_)
    end
    if _s_.node_id == 66
        return hmm_state__66(ctx, ys, _s_)
    end
    if _s_.node_id == 666
        return hmm_state__666(ctx, ys, _s_)
    end
    if _s_.node_id == 706
        return hmm_state__706(ctx, ys, _s_)
    end
    if _s_.node_id == 746
        return hmm_state__746(ctx, ys, _s_)
    end
    if _s_.node_id == 786
        return hmm_state__786(ctx, ys, _s_)
    end
    if _s_.node_id == 826
        return hmm_state__826(ctx, ys, _s_)
    end
    if _s_.node_id == 866
        return hmm_state__866(ctx, ys, _s_)
    end
    if _s_.node_id == 906
        return hmm_state__906(ctx, ys, _s_)
    end
    if _s_.node_id == 946
        return hmm_state__946(ctx, ys, _s_)
    end
    if _s_.node_id == 986
        return hmm_state__986(ctx, ys, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return hmm(ctx, ys)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return hmm(ctx, ys, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return hmm_factor(ctx, ys, _s_, _addr_)
end
