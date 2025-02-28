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

function lda(ctx::AbstractSampleRecordStateContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.K::Int = 2
    _s_.thetas::Vector{Vector{Float64}} = Vector{Vector{Float64}}()
    _s_.theta::Vector{Float64} = Float64[]
    _s_.theta = sample_record_state(ctx, _s_, 73, ("theta_" * string(1)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = sample_record_state(ctx, _s_, 100, ("theta_" * string(2)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = sample_record_state(ctx, _s_, 127, ("theta_" * string(3)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = sample_record_state(ctx, _s_, 154, ("theta_" * string(4)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = sample_record_state(ctx, _s_, 181, ("theta_" * string(5)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)

    _s_.phis::Vector{Vector{Float64}} = Vector{Vector{Float64}}()
    _s_.phi::Vector{Float64} = Float64[]
    _s_.phi = sample_record_state(ctx, _s_, 231, ("phi_" * string(1)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = sample_record_state(ctx, _s_, 258, ("phi_" * string(2)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)

    z = sample_record_state(ctx, _s_, 286, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 313, ("w_" * string(1)), Categorical(_s_.phis[z]), observed = w[1])
    z = sample_record_state(ctx, _s_, 335, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 362, ("w_" * string(2)), Categorical(_s_.phis[z]), observed = w[2])
    z = sample_record_state(ctx, _s_, 384, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 411, ("w_" * string(3)), Categorical(_s_.phis[z]), observed = w[3])
    z = sample_record_state(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 460, ("w_" * string(4)), Categorical(_s_.phis[z]), observed = w[4])
    z = sample_record_state(ctx, _s_, 482, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 509, ("w_" * string(5)), Categorical(_s_.phis[z]), observed = w[5])
    z = sample_record_state(ctx, _s_, 531, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 558, ("w_" * string(6)), Categorical(_s_.phis[z]), observed = w[6])
    z = sample_record_state(ctx, _s_, 580, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 607, ("w_" * string(7)), Categorical(_s_.phis[z]), observed = w[7])
    z = sample_record_state(ctx, _s_, 629, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 656, ("w_" * string(8)), Categorical(_s_.phis[z]), observed = w[8])
    z = sample_record_state(ctx, _s_, 678, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 705, ("w_" * string(9)), Categorical(_s_.phis[z]), observed = w[9])
    z = sample_record_state(ctx, _s_, 727, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
    z = min(length(_s_.phis), z)
    _ = sample_record_state(ctx, _s_, 754, ("w_" * string(10)), Categorical(_s_.phis[z]), observed = w[10])

end

function lda_phi__231(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.phi = resample(ctx, _s_, 231, ("phi_" * string(1)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 258, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = read(ctx, _s_, 286, ("z_" * string(1)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 313, ("w_" * string(1)), Categorical(_s_.phis[z]), observed = w[1])
    z = read(ctx, _s_, 335, ("z_" * string(2)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 362, ("w_" * string(2)), Categorical(_s_.phis[z]), observed = w[2])
    z = read(ctx, _s_, 384, ("z_" * string(3)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 411, ("w_" * string(3)), Categorical(_s_.phis[z]), observed = w[3])
    z = read(ctx, _s_, 433, ("z_" * string(4)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 460, ("w_" * string(4)), Categorical(_s_.phis[z]), observed = w[4])
    z = read(ctx, _s_, 482, ("z_" * string(5)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 509, ("w_" * string(5)), Categorical(_s_.phis[z]), observed = w[5])
    z = read(ctx, _s_, 531, ("z_" * string(6)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 558, ("w_" * string(6)), Categorical(_s_.phis[z]), observed = w[6])
    z = read(ctx, _s_, 580, ("z_" * string(7)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 607, ("w_" * string(7)), Categorical(_s_.phis[z]), observed = w[7])
    z = read(ctx, _s_, 629, ("z_" * string(8)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 656, ("w_" * string(8)), Categorical(_s_.phis[z]), observed = w[8])
    z = read(ctx, _s_, 678, ("z_" * string(9)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 705, ("w_" * string(9)), Categorical(_s_.phis[z]), observed = w[9])
    z = read(ctx, _s_, 727, ("z_" * string(10)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 754, ("w_" * string(10)), Categorical(_s_.phis[z]), observed = w[10])
end

function lda_phi__258(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.phi = resample(ctx, _s_, 258, ("phi_" * string(2)), Dirichlet(fill((1 / V), V)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = read(ctx, _s_, 286, ("z_" * string(1)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 313, ("w_" * string(1)), Categorical(_s_.phis[z]), observed = w[1])
    z = read(ctx, _s_, 335, ("z_" * string(2)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 362, ("w_" * string(2)), Categorical(_s_.phis[z]), observed = w[2])
    z = read(ctx, _s_, 384, ("z_" * string(3)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 411, ("w_" * string(3)), Categorical(_s_.phis[z]), observed = w[3])
    z = read(ctx, _s_, 433, ("z_" * string(4)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 460, ("w_" * string(4)), Categorical(_s_.phis[z]), observed = w[4])
    z = read(ctx, _s_, 482, ("z_" * string(5)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 509, ("w_" * string(5)), Categorical(_s_.phis[z]), observed = w[5])
    z = read(ctx, _s_, 531, ("z_" * string(6)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 558, ("w_" * string(6)), Categorical(_s_.phis[z]), observed = w[6])
    z = read(ctx, _s_, 580, ("z_" * string(7)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 607, ("w_" * string(7)), Categorical(_s_.phis[z]), observed = w[7])
    z = read(ctx, _s_, 629, ("z_" * string(8)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 656, ("w_" * string(8)), Categorical(_s_.phis[z]), observed = w[8])
    z = read(ctx, _s_, 678, ("z_" * string(9)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 705, ("w_" * string(9)), Categorical(_s_.phis[z]), observed = w[9])
    z = read(ctx, _s_, 727, ("z_" * string(10)))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 754, ("w_" * string(10)), Categorical(_s_.phis[z]), observed = w[10])
end

function lda_theta__100(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 100, ("theta_" * string(2)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 127, ("theta_" * string(3)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 154, ("theta_" * string(4)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 181, ("theta_" * string(5)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 231, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 258, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 286, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 313, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 335, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 362, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 384, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 411, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 460, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 482, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 509, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 531, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 558, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 580, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 607, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 629, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 656, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 678, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 705, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 727, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_theta__127(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 127, ("theta_" * string(3)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 154, ("theta_" * string(4)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 181, ("theta_" * string(5)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 231, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 258, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 286, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 313, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 335, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 362, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 384, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 411, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 460, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 482, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 509, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 531, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 558, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 580, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 607, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 629, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 656, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 678, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 705, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 727, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_theta__154(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 154, ("theta_" * string(4)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 181, ("theta_" * string(5)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 231, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 258, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 286, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 313, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 335, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 362, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 384, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 411, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 460, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 482, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 509, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 531, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 558, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 580, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 607, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 629, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 656, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 678, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 705, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 727, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_theta__181(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 181, ("theta_" * string(5)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 231, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 258, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 286, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 313, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 335, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 362, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 384, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 411, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 460, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 482, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 509, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 531, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 558, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 580, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 607, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 629, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 656, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 678, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 705, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 727, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_theta__73(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    _s_.theta = resample(ctx, _s_, 73, ("theta_" * string(1)), Dirichlet(fill((1 / _s_.K), _s_.K)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 100, ("theta_" * string(2)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 127, ("theta_" * string(3)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 154, ("theta_" * string(4)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.theta = read(ctx, _s_, 181, ("theta_" * string(5)))
    _s_.thetas = append(_s_.thetas, _s_.theta)
    _s_.phis = Vector{Vector{Float64}}()
    _s_.phi = Float64[]
    _s_.phi = read(ctx, _s_, 231, ("phi_" * string(1)))
    _s_.phis = append(_s_.phis, _s_.phi)
    _s_.phi = read(ctx, _s_, 258, ("phi_" * string(2)))
    _s_.phis = append(_s_.phis, _s_.phi)
    z = score(ctx, _s_, 286, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 313, ("w_" * string(1)), observed = w[1])
    z = score(ctx, _s_, 335, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 362, ("w_" * string(2)), observed = w[2])
    z = score(ctx, _s_, 384, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 411, ("w_" * string(3)), observed = w[3])
    z = score(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 460, ("w_" * string(4)), observed = w[4])
    z = score(ctx, _s_, 482, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 509, ("w_" * string(5)), observed = w[5])
    z = score(ctx, _s_, 531, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 558, ("w_" * string(6)), observed = w[6])
    z = score(ctx, _s_, 580, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 607, ("w_" * string(7)), observed = w[7])
    z = score(ctx, _s_, 629, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 656, ("w_" * string(8)), observed = w[8])
    z = score(ctx, _s_, 678, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    read(ctx, _s_, 705, ("w_" * string(9)), observed = w[9])
    z = score(ctx, _s_, 727, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
end

function lda_z__286(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 286, ("z_" * string(1)), Categorical(_s_.thetas[doc[1]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 313, ("w_" * string(1)), Categorical(_s_.phis[z]), observed = w[1])
end

function lda_z__335(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 335, ("z_" * string(2)), Categorical(_s_.thetas[doc[2]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 362, ("w_" * string(2)), Categorical(_s_.phis[z]), observed = w[2])
end

function lda_z__384(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 384, ("z_" * string(3)), Categorical(_s_.thetas[doc[3]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 411, ("w_" * string(3)), Categorical(_s_.phis[z]), observed = w[3])
end

function lda_z__433(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 433, ("z_" * string(4)), Categorical(_s_.thetas[doc[4]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 460, ("w_" * string(4)), Categorical(_s_.phis[z]), observed = w[4])
end

function lda_z__482(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 482, ("z_" * string(5)), Categorical(_s_.thetas[doc[5]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 509, ("w_" * string(5)), Categorical(_s_.phis[z]), observed = w[5])
end

function lda_z__531(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 531, ("z_" * string(6)), Categorical(_s_.thetas[doc[6]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 558, ("w_" * string(6)), Categorical(_s_.phis[z]), observed = w[6])
end

function lda_z__580(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 580, ("z_" * string(7)), Categorical(_s_.thetas[doc[7]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 607, ("w_" * string(7)), Categorical(_s_.phis[z]), observed = w[7])
end

function lda_z__629(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 629, ("z_" * string(8)), Categorical(_s_.thetas[doc[8]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 656, ("w_" * string(8)), Categorical(_s_.phis[z]), observed = w[8])
end

function lda_z__678(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 678, ("z_" * string(9)), Categorical(_s_.thetas[doc[9]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 705, ("w_" * string(9)), Categorical(_s_.phis[z]), observed = w[9])
end

function lda_z__727(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State)
    z = resample(ctx, _s_, 727, ("z_" * string(10)), Categorical(_s_.thetas[doc[10]]))
    z = min(length(_s_.phis), z)
    score(ctx, _s_, 754, ("w_" * string(10)), Categorical(_s_.phis[z]), observed = w[10])
end

function lda_factor(ctx::AbstractFactorResampleContext, M::Int, N::Int, V::Int, w::Vector{Int}, doc::Vector{Int}, _s_::State, _addr_::String)
    if _s_.node_id == 231
        return lda_phi__231(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 258
        return lda_phi__258(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 100
        return lda_theta__100(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 127
        return lda_theta__127(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 154
        return lda_theta__154(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 181
        return lda_theta__181(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 73
        return lda_theta__73(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 286
        return lda_z__286(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 335
        return lda_z__335(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 384
        return lda_z__384(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 433
        return lda_z__433(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 482
        return lda_z__482(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 531
        return lda_z__531(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 580
        return lda_z__580(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 629
        return lda_z__629(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 678
        return lda_z__678(ctx, M, N, V, w, doc, _s_)
    end
    if _s_.node_id == 727
        return lda_z__727(ctx, M, N, V, w, doc, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return lda(ctx, M, N, V, w, doc)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return lda(ctx, M, N, V, w, doc, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return lda_factor(ctx, M, N, V, w, doc, _s_, _addr_)
end
