# this file is auto-generated

include("../captcha.jl")

mutable struct State <: AbstractState
    node_id:: Int
    N_letters::Int
    font::Int
    fontsize::Int
    i::Int
    image::Vector{Float64}
    kerning::Int
    letter::Int
    noisy_letter_image::Vector{Float64}
    function State()
        return new(
            0,
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Int),
            zero(Vector{Float64}),
            zero(Int),
            zero(Int),
            zero(Vector{Float64}),
        )
    end
end

function Base.copy!(dst::State, _s_::State)
    dst.node_id = _s_.node_id
    dst.N_letters = _s_.N_letters
    dst.font = _s_.font
    dst.fontsize = _s_.fontsize
    dst.i = _s_.i
    dst.image = _s_.image
    dst.kerning = _s_.kerning
    dst.letter = _s_.letter
    dst.noisy_letter_image = _s_.noisy_letter_image
    return dst
end

Base.copy(_s_::State) = Base.copy!(State(), _s_)

function captcha(ctx::AbstractSampleRecordStateContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.N_letters::Int = sample_record_state(ctx, _s_, 72, "N", Poisson(7))
    _s_.font::Int = sample_record_state(ctx, _s_, 84, "font", DiscreteUniform(1, 4))
    _s_.image::Vector{Float64} = zeros((200 * 50))
    _s_.i::Int = 1
    while (_s_.i <= _s_.N_letters)
        _s_.fontsize::Int = sample_record_state(ctx, _s_, 120, ("fontsize_" * string(_s_.i)), DiscreteUniform(38, 44))
        _s_.kerning::Int = sample_record_state(ctx, _s_, 138, ("kerning_" * string(_s_.i)), DiscreteUniform(-2, 2))
        _s_.letter::Int = sample_record_state(ctx, _s_, 156, ("letter_" * string(_s_.i)), DiscreteUniform(1, 26))
        _s_.noisy_letter_image::Vector{Float64} = sample_record_state(ctx, _s_, 174, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
        _s_.image = (_s_.image + _s_.noisy_letter_image)
        _s_.i = (_s_.i + 1)
    end
    _ = sample_record_state(ctx, _s_, 213, "image", MvNormal(_s_.image, 1.0), observed = captcha_img)
end

function captcha_N_72(ctx::AbstractFactorVisitContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.N_letters = visit(ctx, _s_, 72, "N", Poisson(7))
    _s_.font = read_trace(ctx, _s_, 84, "font")
    _s_.image = zeros((200 * 50))
    _s_.i = 1
    while (_s_.i <= _s_.N_letters)
        _s_.fontsize = score(ctx, _s_, 120, ("fontsize_" * string(_s_.i)), DiscreteUniform(38, 44))
        _s_.kerning = score(ctx, _s_, 138, ("kerning_" * string(_s_.i)), DiscreteUniform(-2, 2))
        _s_.letter = score(ctx, _s_, 156, ("letter_" * string(_s_.i)), DiscreteUniform(1, 26))
        _s_.noisy_letter_image = score(ctx, _s_, 174, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
        _s_.image = (_s_.image + _s_.noisy_letter_image)
        _s_.i = (_s_.i + 1)
    end
    score(ctx, _s_, 213, "image", MvNormal(_s_.image, 1.0), observed = captcha_img)
end

function captcha_font_84(ctx::AbstractFactorVisitContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.font = visit(ctx, _s_, 84, "font", DiscreteUniform(1, 4))
    _s_.image = zeros((200 * 50))
    _s_.i = 1
    while (_s_.i <= _s_.N_letters)
        _s_.fontsize = read_trace(ctx, _s_, 120, ("fontsize_" * string(_s_.i)))
        _s_.kerning = read_trace(ctx, _s_, 138, ("kerning_" * string(_s_.i)))
        _s_.letter = read_trace(ctx, _s_, 156, ("letter_" * string(_s_.i)))
        _s_.noisy_letter_image = score(ctx, _s_, 174, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
        _s_.image = (_s_.image + _s_.noisy_letter_image)
        _s_.i = (_s_.i + 1)
    end
end

function captcha_fontsize__120(ctx::AbstractFactorVisitContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.fontsize = visit(ctx, _s_, 120, ("fontsize_" * string(_s_.i)), DiscreteUniform(38, 44))
    _s_.kerning = read_trace(ctx, _s_, 138, ("kerning_" * string(_s_.i)))
    _s_.letter = read_trace(ctx, _s_, 156, ("letter_" * string(_s_.i)))
    _s_.noisy_letter_image = score(ctx, _s_, 174, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
end

function captcha_kerning__138(ctx::AbstractFactorVisitContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.kerning = visit(ctx, _s_, 138, ("kerning_" * string(_s_.i)), DiscreteUniform(-2, 2))
    _s_.letter = read_trace(ctx, _s_, 156, ("letter_" * string(_s_.i)))
    _s_.noisy_letter_image = score(ctx, _s_, 174, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
end

function captcha_letter__156(ctx::AbstractFactorVisitContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.letter = visit(ctx, _s_, 156, ("letter_" * string(_s_.i)), DiscreteUniform(1, 26))
    _s_.noisy_letter_image = score(ctx, _s_, 174, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
end

function captcha_letter_image__174(ctx::AbstractFactorVisitContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.noisy_letter_image = visit(ctx, _s_, 174, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
    _s_.image = (_s_.image + _s_.noisy_letter_image)
    _s_.i = (_s_.i + 1)
    while (_s_.i <= _s_.N_letters)
        _s_.fontsize = read_trace(ctx, _s_, 120, ("fontsize_" * string(_s_.i)))
        _s_.kerning = read_trace(ctx, _s_, 138, ("kerning_" * string(_s_.i)))
        _s_.letter = read_trace(ctx, _s_, 156, ("letter_" * string(_s_.i)))
        _s_.noisy_letter_image = read_trace(ctx, _s_, 174, ("letter_image_" * string(_s_.i)))
        _s_.image = (_s_.image + _s_.noisy_letter_image)
        _s_.i = (_s_.i + 1)
    end
    score(ctx, _s_, 213, "image", MvNormal(_s_.image, 1.0), observed = captcha_img)
end

function captcha_factor(ctx::AbstractFactorVisitContext, captcha_img::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 72
        return captcha_N_72(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 84
        return captcha_font_84(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 120
        return captcha_fontsize__120(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 138
        return captcha_kerning__138(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 156
        return captcha_letter__156(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 174
        return captcha_letter_image__174(ctx, captcha_img, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return captcha(ctx, captcha_img)
end

function model(ctx::AbstractSampleRecordStateContext, _s_::State)
    return captcha(ctx, captcha_img, _s_)
end

function factor(ctx::AbstractFactorVisitContext, _s_::State, _addr_::String)
    return captcha_factor(ctx, captcha_img, _s_, _addr_)
end

