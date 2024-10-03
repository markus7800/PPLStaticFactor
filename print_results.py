#%%
import pandas as pd
# %%
df = pd.read_csv("evaluation/paper_results.csv", sep=", ")
# %%
row_start = {
    "aircraft": "Aircraft & $\\infty$",
    "captcha": "Captcha & $\\infty$",
    "dirichlet_process": "Dirichlet process & $\\infty$",
    "geometric": "Geometric &  $\\infty$",
    "gmm_fixed_numclust": "GMM (fixed number of clusters) & 209",
    "gmm_variable_numclust": " GMM (variable number of clusters) & $\\infty$",
    "hmm_fixed_seqlen": "HMM (fixed sequence length) & 21",
    "hmm_variable_seqlen": "HMM (variable sequence length) & $\\infty$",
    "hurricane": "Hurricane & 4",
    "lda_fixed_numtopic": "LDA (fixed number of topics) & 551",
    "lda_variable_numtopic": "LDA (variable number of topics) & $\\infty$",
    "linear_regression": "Linear regression & 102",
    "marsaglia": "Marsaglia & $\\infty$",
    "pedestrian": "Pedestrian & $\\infty$",
    "urn": "Urn & $\\infty$",
}
# %%
for _, row in df.iterrows():
    print(row_start[row.model], "&", f"{row.none:.3f} & {row.static:.3f} ({row.static/row.none:.2f})", end="")
    if pd.isna(row.finite):
        print(" & - \\\\")
    else:
        print(f" & {row.finite:.3f} ({row.finite/row.none:.2f}) \\\\")

# %%
