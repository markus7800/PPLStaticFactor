
# chosen such that every runtest takes 1-2s
name_to_N = Dict{String,Int}(
    "aircraft" => 100_000,
    "bayesian_network" => 100_000,
    "captcha" => 1_000,
    "dirichlet_process" => 10_000,
    "geometric" => 500_000,
    "gmm_fixed_numclust" => 50_000,
    "gmm_variable_numclust" => 50_000,
    "hmm_fixed_seqlen" => 100_000,
    "hurricane" => 1_000_000,
    "lda_fixed_numtopic" => 10_000,
    "lda_variable_numtopic" => 10_000,
    "linear_regression" => 100_000,
    "marsaglia" => 500_000,
    "pcfg" => 100_000,
    "pedestrian" => 100_000,
    "urn" => 100_000,

    "gmm_fixed_numclust_unrolled" => 50_000,
    "hmm_fixed_seqlen_unrolled" => 100_000,
    "lda_fixed_numtopic_unrolled" => 10_000,
    "linear_regression_unrolled" => 100_000,
)