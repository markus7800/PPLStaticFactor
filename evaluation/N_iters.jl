const N_seeds = 10

const name_to_N = Dict{String,Int}(
    "aircraft" => 10_000,
    "bayesian_network" => 10_000,
    "captcha" => 100,
    "dirichlet_process" => 1_000,
    "geometric" => 50_000,
    "gmm_fixed_numclust" => 5_000,
    "gmm_variable_numclust" => 5_000,
    "hmm" => 10_000,
    "hurricane" => 100_000,
    "lda_fixed_numtopic" => 1_000,
    "lda_variable_numtopic" => 1_000,
    "linear_regression" => 10_000,
    "marsaglia" => 50_000,
    "pcfg" => 10_000,
    "pedestrian" => 10_000,
    "urn" => 10_000,

    "gmm_fixed_numclust_unrolled" => 5_000,
    "hmm_unrolled" => 10_000,
    "lda_fixed_numtopic_unrolled" => 1_000,
    "linear_regression_unrolled" => 10_000,
)