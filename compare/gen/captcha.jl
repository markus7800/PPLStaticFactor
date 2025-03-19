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
    N_letters::Int = {:N_letters} ~ poisson(7)
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

struct CaptchaLMHSelector <: LMHSelector
end
function get_length(::CaptchaLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    K = trace[:N_letters]
    return 2 + 4*K
end
function get_resample_address(::CaptchaLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)
    K = trace[:N_letters]

    U = rand()

    n = 1
    if U < n/N
        return :N_letters
    end
    n += 1

    if U < n/N
        return :font
    end

    for i in 1:K
        n += 1
        if U < n/N
            return :fontsize => i
        end
        n += 1
        if U < n/N
            return :kerning => i
        end
        n += 1
        if U < n/N
            return :letter => i
        end
        n += 1
        if U < n/N
            return :letter_image => i
        end
    end
end

captcha_img = zeros(200*50)

N_iter = name_to_N[modelname]

model = captcha
args = ()
observations = choicemap();

observations[:image] = captcha_img

selector = CaptchaLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
base_time = res.time / N_iter # total of N_iter / 10 * 10 iterations
println(@sprintf("Gen time: %.3f μs", base_time*10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))


# === Implementation with Combinators  ===


@gen function gen_letter(font::Int)::Vector{Float64}
    fontsize::Int = {:fontsize} ~ uniform_discrete(38,44)
    kerning::Int = {:kerning} ~ uniform_discrete(-2,2)
    letter::Int = {:letter} ~ uniform_discrete(1,26)
    noisy_letter_image::Vector{Float64} = {:letter_image} ~ mvnormal(vec(render_letter(letter, font, fontsize, kerning)), 0.1*I(200*50))
    return noisy_letter_image
end

const gen_letters = Map(gen_letter)

@gen (static) function captcha_combinator()
    N_letters::Int = {:N_letters} ~ poisson(7)
    font::Int = {:font} ~ uniform_discrete(1,4)
    letters ~ gen_letters(fill(font,N_letters))
    image::Vector{Float64} = sum(letters)
    {:image} ~ mvnormal(image, 1.0*I(200*50))
end


# tr, _ = generate(captcha_combinator, args, observations);
# display(get_choices(tr))

struct CaptchaCombinatorLMHSelector <: LMHSelector
end
function get_length(::CaptchaCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)::Int
    K = trace[:N_letters]
    return 2 + 4*K
end
function get_resample_address(::CaptchaCombinatorLMHSelector, trace::Gen.ChoiceMap, args::Tuple, observations::Gen.ChoiceMap)
    N = get_length(selector, trace, args, observations)
    K = trace[:N_letters]

    U = rand()

    n = 1
    if U < n/N
        return :N_letters
    end
    n += 1

    if U < n/N
        return :font
    end

    for i in 1:K
        n += 1
        if U < n/N
            return :letters => i => :fontsize
        end
        n += 1
        if U < n/N
            return :letters => i => :kerning
        end
        n += 1
        if U < n/N
            return :letters => i => :letter
        end
        n += 1
        if U < n/N
            return :letters => i => :letter_image
        end
    end
end

model = captcha_combinator
selector = CaptchaCombinatorLMHSelector()

acceptance_rate = lmh(10, N_iter ÷ 10, selector, model, args, observations, check=true)
res = @timed lmh(10, N_iter ÷ 10, selector, model, args, observations)
combinator_time = res.time / N_iter
println(@sprintf("Gen combinator time: %.3f μs", combinator_time * 10^6))
println(@sprintf("Acceptance rate: %.2f%%", acceptance_rate*100))

f = open("compare/gen/results.csv", "a")
println(f, modelname, ",", N_iter, ",", acceptance_rate, ",", base_time*10^6, ",", combinator_time*10^6, ",", combinator_time / base_time)