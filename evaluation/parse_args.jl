MODEL_DIRECTORY = ARGS[1]
FILENAME = ARGS[2]
include(MODEL_DIRECTORY * "/generated/" * FILENAME)
if MODEL_DIRECTORY == "benchmark"
    if modelname in ("linear_regression", "gmm_fixed_numclust", "hmm", "lda_fixed_numtopic", "bayesian_network")
        include("finite/"  * FILENAME)
    end
    if modelname in ("gmm_fixed_numclust", "lda_fixed_numtopic")
        include("custom/"  * FILENAME)
    end
end