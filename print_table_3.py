
import pandas as pd

df = pd.read_csv("evaluation/paper_vi_results.csv", sep=",")


models = {
    "aircraft": "Aircraft",
    "bayesian_network": "Bayesian Network",
    "captcha": "Captcha",
    "dirichlet_process": "Dirichlet process",
    "geometric": "Geometric",
    "gmm_fixed_numclust": "GMM (fixed \\#clusters)",
    "gmm_variable_numclust": "GMM (variable \\#clusters)",
    "hmm": "HMM",
    "hmm_unrolled": "HMM (unrolled)",
    "hurricane": "Hurricane",
    "lda_fixed_numtopic": "LDA (fixed \\#topics)",
    "lda_variable_numtopic": "LDA (variable \\#topics)",
    "linear_regression": "Linear regression",
    "marsaglia": "Marsaglia",
    "pcfg": "PCFG",
    "pedestrian": "Pedestrian",
    "urn": "Urn",
}

for _, row in df.iterrows():
    ratio = row.rel_static
    arrow = "$\\samearrow$"
    color = "\\textcolor{Gray}"
    if ratio > 10:
        arrow = "$\\megaslowarrow$"
        color = "\\textcolor{ForestGreen}"
    elif ratio > 2:
        arrow = "$\\slowarrow$"
        color = "\\textcolor{ForestGreen}"
    elif ratio < 0.5:
        arrow = "$\\megafastarrow$"
        color = "\\textcolor{OrangeRed}"
    elif ratio < 0.1:
        arrow = "$\\fastarrow$"
        color = "\\textcolor{OrangeRed}"

    rel_str = color + "{" + f"{ratio:.2f}" + "} & " + color + "{" + arrow + "}"
    print(models[row.model], "&", f"{row.none:.3e} & {row.static:.3e} & {rel_str} \\\\")



