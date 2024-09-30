include("ppl.jl")

modelname = "captcha"

function render_letter(letter::Int, font::Int, fontsize::Int, kerning::Int)
    # mock heavy computation
    t0 = time_ns()
    t = (time_ns() - t0)
    while t < 100_000
        t = (time_ns() - t0)
    end
    return zeros(200, 50)
end

@model function captcha(ctx::SampleContext, captcha_img::Vector{Float64})
    N_letters::Int = sample(ctx, "N", Poisson(7))
    font::Int = sample(ctx, "font", DiscreteUniform(1,4))
    image::Vector{Float64} = zeros(200 * 50)
    i::Int = 1
    while i <= N_letters
        fontsize::Int = sample(ctx, "fontsize_" * string(i), DiscreteUniform(38,44))
        kerning::Int = sample(ctx, "kerning_" * string(i), DiscreteUniform(-2,2))
        letter::Int = sample(ctx, "letter_" * string(i), DiscreteUniform(1,26))
        noisy_letter_image::Vector{Float64} = sample(ctx, "letter_image_"*string(i), MvNormal(vec(render_letter(letter, font, fontsize, kerning)), 0.1))
        image = image + noisy_letter_image
        i = i + 1
    end
    sample(ctx, "image", MvNormal(image, 1.), observed=captcha_img)
end

captcha_img = zeros(200*50)