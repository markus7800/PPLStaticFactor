using Gen
include("lmh.jl")
using LinearAlgebra: I

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

@gen function captcha()
    N_letters::Int = {:N} ~ poisson(7)
    font::Int = {:font} ~ uniform_discrete(1,4)
    image::Vector{Float64} = zeros(200 * 50)
    i::Int = 1
    while i <= N_letters
        fontsize::Int = {:fontsize => i} ~ uniform_discrete(38,44)
        kerning::Int = {:kerning => i} ~ uniform_discrete(-2,2)
        letter::Int = {:letter => i} ~ uniform_discrete(1,26)
        noisy_letter_image::Vector{Float64} = {:letter_image => i} ~ mvnormal(vec(render_letter(letter, font, fontsize, kerning)), 0.1*I(200*50))
        image = image + noisy_letter_image
        i = i + 1
    end
    {:image} ~ mvnormal(image, 1.0*I(200*50))
end

captcha_img = zeros(200*50)

model = captcha
args = ()
observations = choicemap();

observations[:image] = captcha_img

N = name_to_N[modelname]
acceptance_rate = lmh(10, N ÷ 10, model, args, observations)
res = @timed lmh(10, N ÷ 10, model, args, observations)
println(@sprintf("Gen time %.3f μs", res.time / N * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))