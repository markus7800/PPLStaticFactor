include(ARGS[1] * "/generated/" * ARGS[2])
if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm", "lda_fixed_numtopic", "bayesian_network")
    include("finite/"  * ARGS[2])
end
if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
    include("custom/"  * ARGS[2])
end