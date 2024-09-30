# this file is auto-generated

include("../lda_fixed_numtopic.jl")

mutable struct State <: AbstractState
    node_id:: Int
    K::Int
    phi::Vector{Float64}
    phis::Vector{Vector{Float64}}
    theta::Vector{Float64}
    thetas::Vector{Vector{Float64}}
    function State()
        return new(
            0,
            zero(Int),
            zero(Vector{Float64}),
            zero(Vector{Vector{Float64}}),
            zero(Vector{Float64}),
            zero(Vector{Vector{Float64}}),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.K = _s_.K
    dst.phi = _s_.phi
    dst.phis = _s_.phis
    dst.theta = _s_.theta
    dst.thetas = _s_.thetas
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function lda(ctx::AbstractGenerateRecordStateContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.K::Int = 2
    _s_.thetas::Vector{Vector{Float64}} = Vector{Vector{Float64}}()
    _s_.theta::Vector{Float64} = Float64[]
    _s_.theta = sample_record_state(ctx, _s_, 66, ("theta_" * string(1)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = sample_record_state(ctx, _s_, 93, ("theta_" * string(2)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = sample_record_state(ctx, _s_, 120, ("theta_" * string(3)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = sample_record_state(ctx, _s_, 147, ("theta_" * string(4)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = sample_record_state(ctx, _s_, 174, ("theta_" * string(5)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)

    _s_.phis::Vector{Vector{Float64}} = Vector{Vector{Float64}}()
    _s_.phi::Vector{Float64} = Float64[]
    _s_.phi = sample_record_state(ctx, _s_, 224, ("phi_" * string(1)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = sample_record_state(ctx, _s_, 251, ("phi_" * string(2)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)

    z = sample_record_state(ctx, _s_, 279, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 306, ("w_" * string(1)), Categorical(_s_.phis[z]), observed = w[1])
    z = sample_record_state(ctx, _s_, 328, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 355, ("w_" * string(2)), Categorical(_s_.phis[z]), observed = w[2])
    z = sample_record_state(ctx, _s_, 377, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 404, ("w_" * string(3)), Categorical(_s_.phis[z]), observed = w[3])
    z = sample_record_state(ctx, _s_, 426, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 453, ("w_" * string(4)), Categorical(_s_.phis[z]), observed = w[4])
    z = sample_record_state(ctx, _s_, 475, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 502, ("w_" * string(5)), Categorical(_s_.phis[z]), observed = w[5])
    z = sample_record_state(ctx, _s_, 524, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 551, ("w_" * string(6)), Categorical(_s_.phis[z]), observed = w[6])
    z = sample_record_state(ctx, _s_, 573, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 600, ("w_" * string(7)), Categorical(_s_.phis[z]), observed = w[7])
    z = sample_record_state(ctx, _s_, 622, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 649, ("w_" * string(8)), Categorical(_s_.phis[z]), observed = w[8])
    z = sample_record_state(ctx, _s_, 671, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 698, ("w_" * string(9)), Categorical(_s_.phis[z]), observed = w[9])
    z = sample_record_state(ctx, _s_, 720, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 747, ("w_" * string(10)), Categorical(_s_.phis[z]), observed = w[10])

end

function lda_phi__224(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.phi = resample(ctx, _s_, 224, ("phi_" * string(1)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 251, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = read(ctx, _s_, 279, ("z_" * string(1)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 306, ("w_" * string(1)), Categorical(_s_.phis[z]), observed = w[1])
    z = read(ctx, _s_, 328, ("z_" * string(2)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 355, ("w_" * string(2)), Categorical(_s_.phis[z]), observed = w[2])
    z = read(ctx, _s_, 377, ("z_" * string(3)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 404, ("w_" * string(3)), Categorical(_s_.phis[z]), observed = w[3])
    z = read(ctx, _s_, 426, ("z_" * string(4)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 453, ("w_" * string(4)), Categorical(_s_.phis[z]), observed = w[4])
    z = read(ctx, _s_, 475, ("z_" * string(5)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 502, ("w_" * string(5)), Categorical(_s_.phis[z]), observed = w[5])
    z = read(ctx, _s_, 524, ("z_" * string(6)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 551, ("w_" * string(6)), Categorical(_s_.phis[z]), observed = w[6])
    z = read(ctx, _s_, 573, ("z_" * string(7)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 600, ("w_" * string(7)), Categorical(_s_.phis[z]), observed = w[7])
    z = read(ctx, _s_, 622, ("z_" * string(8)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 649, ("w_" * string(8)), Categorical(_s_.phis[z]), observed = w[8])
    z = read(ctx, _s_, 671, ("z_" * string(9)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 698, ("w_" * string(9)), Categorical(_s_.phis[z]), observed = w[9])
    z = read(ctx, _s_, 720, ("z_" * string(10)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 747, ("w_" * string(10)), Categorical(_s_.phis[z]), observed = w[10])
end

function lda_phi__251(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.phi = resample(ctx, _s_, 251, ("phi_" * string(2)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = read(ctx, _s_, 279, ("z_" * string(1)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 306, ("w_" * string(1)), Categorical(_s_.phis[z]), observed = w[1])
    z = read(ctx, _s_, 328, ("z_" * string(2)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 355, ("w_" * string(2)), Categorical(_s_.phis[z]), observed = w[2])
    z = read(ctx, _s_, 377, ("z_" * string(3)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 404, ("w_" * string(3)), Categorical(_s_.phis[z]), observed = w[3])
    z = read(ctx, _s_, 426, ("z_" * string(4)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 453, ("w_" * string(4)), Categorical(_s_.phis[z]), observed = w[4])
    z = read(ctx, _s_, 475, ("z_" * string(5)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 502, ("w_" * string(5)), Categorical(_s_.phis[z]), observed = w[5])
    z = read(ctx, _s_, 524, ("z_" * string(6)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 551, ("w_" * string(6)), Categorical(_s_.phis[z]), observed = w[6])
    z = read(ctx, _s_, 573, ("z_" * string(7)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 600, ("w_" * string(7)), Categorical(_s_.phis[z]), observed = w[7])
    z = read(ctx, _s_, 622, ("z_" * string(8)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 649, ("w_" * string(8)), Categorical(_s_.phis[z]), observed = w[8])
    z = read(ctx, _s_, 671, ("z_" * string(9)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 698, ("w_" * string(9)), Categorical(_s_.phis[z]), observed = w[9])
    z = read(ctx, _s_, 720, ("z_" * string(10)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 747, ("w_" * string(10)), Categorical(_s_.phis[z]), observed = w[10])
end

function lda_theta__120(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 120, ("theta_" * string(3)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 147, ("theta_" * string(4)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 174, ("theta_" * string(5)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 224, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 251, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 279, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 306, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 328, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 355, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 377, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 404, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 426, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 453, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 475, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 502, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 524, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 551, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 573, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 600, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 622, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 649, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 671, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 698, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 720, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_theta__147(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 147, ("theta_" * string(4)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 174, ("theta_" * string(5)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 224, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 251, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 279, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 306, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 328, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 355, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 377, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 404, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 426, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 453, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 475, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 502, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 524, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 551, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 573, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 600, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 622, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 649, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 671, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 698, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 720, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_theta__174(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 174, ("theta_" * string(5)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 224, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 251, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 279, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 306, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 328, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 355, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 377, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 404, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 426, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 453, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 475, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 502, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 524, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 551, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 573, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 600, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 622, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 649, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 671, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 698, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 720, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_theta__66(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 66, ("theta_" * string(1)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 93, ("theta_" * string(2)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 120, ("theta_" * string(3)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 147, ("theta_" * string(4)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 174, ("theta_" * string(5)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 224, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 251, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 279, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 306, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 328, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 355, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 377, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 404, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 426, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 453, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 475, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 502, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 524, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 551, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 573, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 600, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 622, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 649, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 671, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 698, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 720, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_theta__93(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 93, ("theta_" * string(2)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 120, ("theta_" * string(3)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 147, ("theta_" * string(4)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 174, ("theta_" * string(5)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 224, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 251, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 279, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 306, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 328, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 355, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 377, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 404, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 426, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 453, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 475, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 502, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 524, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 551, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 573, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 600, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 622, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 649, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 671, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 698, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 720, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_z__279(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 279, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 306, ("w_" * string(1)), Categorical(_s_.phis[z]), observed = w[1])
end

function lda_z__328(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 328, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 355, ("w_" * string(2)), Categorical(_s_.phis[z]), observed = w[2])
end

function lda_z__377(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 377, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 404, ("w_" * string(3)), Categorical(_s_.phis[z]), observed = w[3])
end

function lda_z__426(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 426, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 453, ("w_" * string(4)), Categorical(_s_.phis[z]), observed = w[4])
end

function lda_z__475(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 475, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 502, ("w_" * string(5)), Categorical(_s_.phis[z]), observed = w[5])
end

function lda_z__524(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 524, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 551, ("w_" * string(6)), Categorical(_s_.phis[z]), observed = w[6])
end

function lda_z__573(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 573, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 600, ("w_" * string(7)), Categorical(_s_.phis[z]), observed = w[7])
end

function lda_z__622(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 622, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 649, ("w_" * string(8)), Categorical(_s_.phis[z]), observed = w[8])
end

function lda_z__671(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 671, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 698, ("w_" * string(9)), Categorical(_s_.phis[z]), observed = w[9])
end

function lda_z__720(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 720, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 747, ("w_" * string(10)), Categorical(_s_.phis[z]), observed = w[10])
end

function lda_factor(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State, _addr_::String)
    if _s_.node_id == 224
        return lda_phi__224(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 251
        return lda_phi__251(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 120
        return lda_theta__120(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 147
        return lda_theta__147(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 174
        return lda_theta__174(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 66
        return lda_theta__66(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 93
        return lda_theta__93(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 279
        return lda_z__279(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 328
        return lda_z__328(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 377
        return lda_z__377(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 426
        return lda_z__426(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 475
        return lda_z__475(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 524
        return lda_z__524(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 573
        return lda_z__573(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 622
        return lda_z__622(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 671
        return lda_z__671(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 720
        return lda_z__720(ctx, M, N, V, w, doc, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return lda(ctx, M, N, V, w, doc)
end

function model(ctx::AbstractGenerateRecordStateContext, _s_::State)
    return lda(ctx, M, N, V, w, doc, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return lda_factor(ctx, M, N, V, w, doc, _s_, _addr_)
end
