include("vi_standard.jl")

Random.seed!(0)
bbvi(1, 2, 0.001, model)
