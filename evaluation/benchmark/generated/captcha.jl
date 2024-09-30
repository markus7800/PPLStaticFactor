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

function captcha(ctx::AbstractGenerateRecordStateContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.N_letters::Int = sample_record_state(ctx, _s_, 69, "N", Poisson(7))
    _s_.font::Int = sample_record_state(ctx, _s_, 81, "font", DiscreteUniform(1, 4))
    _s_.image::Vector{Float64} = zeros((200 * 50))
    _s_.i::Int = 1
    while (_s_.i <= _s_.N_letters)
        _s_.fontsize::Int = sample_record_state(ctx, _s_, 117, ("fontsize_" * string(_s_.i)), DiscreteUniform(38, 44))
        _s_.kerning::Int = sample_record_state(ctx, _s_, 135, ("kerning_" * string(_s_.i)), DiscreteUniform(-2, 2))
        _s_.letter::Int = sample_record_state(ctx, _s_, 153, ("letter_" * string(_s_.i)), DiscreteUniform(1, 26))
        _s_.noisy_letter_image::Vector{Float64} = sample_record_state(ctx, _s_, 171, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
        _s_.image = (_s_.image + _s_.noisy_letter_image)
        _s_.i = (_s_.i + 1)
    end
    _ = sample_record_state(ctx, _s_, 210, "image", MvNormal(_s_.image, 1.0), observed = captcha_img)
end

function captcha_N_69(ctx::AbstractFactorResampleContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.N_letters = resample(ctx, _s_, 69, "N", Poisson(7))
    _s_.font = read(ctx, _s_, 81, "font")
    _s_.image = zeros((200 * 50))
    _s_.i = 1
    while (_s_.i <= _s_.N_letters)
        _s_.fontsize = score(ctx, _s_, 117, ("fontsize_" * string(_s_.i)), DiscreteUniform(38, 44))
        _s_.kerning = score(ctx, _s_, 135, ("kerning_" * string(_s_.i)), DiscreteUniform(-2, 2))
        _s_.letter = score(ctx, _s_, 153, ("letter_" * string(_s_.i)), DiscreteUniform(1, 26))
        _s_.noisy_letter_image = score(ctx, _s_, 171, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
        _s_.image = (_s_.image + _s_.noisy_letter_image)
        _s_.i = (_s_.i + 1)
    end
    score(ctx, _s_, 210, "image", MvNormal(_s_.image, 1.0), observed = captcha_img)
end

function captcha_font_81(ctx::AbstractFactorResampleContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.font = resample(ctx, _s_, 81, "font", DiscreteUniform(1, 4))
    _s_.image = zeros((200 * 50))
    _s_.i = 1
    while (_s_.i <= _s_.N_letters)
        _s_.fontsize = read(ctx, _s_, 117, ("fontsize_" * string(_s_.i)))
        _s_.kerning = read(ctx, _s_, 135, ("kerning_" * string(_s_.i)))
        _s_.letter = read(ctx, _s_, 153, ("letter_" * string(_s_.i)))
        _s_.noisy_letter_image = score(ctx, _s_, 171, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
        _s_.image = (_s_.image + _s_.noisy_letter_image)
        _s_.i = (_s_.i + 1)
    end
end

function captcha_fontsize__117(ctx::AbstractFactorResampleContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.fontsize = resample(ctx, _s_, 117, ("fontsize_" * string(_s_.i)), DiscreteUniform(38, 44))
    _s_.kerning = read(ctx, _s_, 135, ("kerning_" * string(_s_.i)))
    _s_.letter = read(ctx, _s_, 153, ("letter_" * string(_s_.i)))
    _s_.noisy_letter_image = score(ctx, _s_, 171, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
end

function captcha_kerning__135(ctx::AbstractFactorResampleContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.kerning = resample(ctx, _s_, 135, ("kerning_" * string(_s_.i)), DiscreteUniform(-2, 2))
    _s_.letter = read(ctx, _s_, 153, ("letter_" * string(_s_.i)))
    _s_.noisy_letter_image = score(ctx, _s_, 171, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
end

function captcha_letter__153(ctx::AbstractFactorResampleContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.letter = resample(ctx, _s_, 153, ("letter_" * string(_s_.i)), DiscreteUniform(1, 26))
    _s_.noisy_letter_image = score(ctx, _s_, 171, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
end

function captcha_letter_image__171(ctx::AbstractFactorResampleContext, captcha_img::Vector{Float64}, _s_::State)
    _s_.noisy_letter_image = resample(ctx, _s_, 171, ("letter_image_" * string(_s_.i)), MvNormal(vec(render_letter(_s_.letter, _s_.font, _s_.fontsize, _s_.kerning)), 0.1))
    _s_.image = (_s_.image + _s_.noisy_letter_image)
    _s_.i = (_s_.i + 1)
    while (_s_.i <= _s_.N_letters)
        _s_.fontsize = read(ctx, _s_, 117, ("fontsize_" * string(_s_.i)))
        _s_.kerning = read(ctx, _s_, 135, ("kerning_" * string(_s_.i)))
        _s_.letter = read(ctx, _s_, 153, ("letter_" * string(_s_.i)))
        _s_.noisy_letter_image = read(ctx, _s_, 171, ("letter_image_" * string(_s_.i)))
        _s_.image = (_s_.image + _s_.noisy_letter_image)
        _s_.i = (_s_.i + 1)
    end
    score(ctx, _s_, 210, "image", MvNormal(_s_.image, 1.0), observed = captcha_img)
end

function captcha_factor(ctx::AbstractFactorResampleContext, captcha_img::Vector{Float64}, _s_::State, _addr_::String)
    if _s_.node_id == 69
        return captcha_N_69(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 81
        return captcha_font_81(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 117
        return captcha_fontsize__117(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 135
        return captcha_kerning__135(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 153
        return captcha_letter__153(ctx, captcha_img, _s_)
    end
    if _s_.node_id == 171
        return captcha_letter_image__171(ctx, captcha_img, _s_)
    end
    error("Cannot find factor for $_addr_ $_s_")
end

function model(ctx::SampleContext)
    return captcha(ctx, captcha_img)
end

function model(ctx::AbstractGenerateRecordStateContext, _s_::State)
    return captcha(ctx, captcha_img, _s_)
end

function factor(ctx::AbstractFactorResampleContext, _s_::State, _addr_::String)
    return captcha_factor(ctx, captcha_img, _s_, _addr_)
end
