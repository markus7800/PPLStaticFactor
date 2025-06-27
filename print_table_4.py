
import pandas as pd

df = pd.read_csv("evaluation/paper_smc_results.csv", sep=",")


models = {
    "aircraft": "Aircraft",
    "bayesian_network": "Bayesian Network",
    "captcha": "Captcha",
    "dirichlet_process": "Dirichlet process",
    "geometric": "Geometric",
    "gmm_fixed_numclust": "GMM (fixed \\#clusters)",
    "gmm_variable_numclust": "GMM (variable \\#clusters)",
    "hmm": "HMM",
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
    if ratio < 0.8:
        arrow = "$\\fastarrow$"
        color = "\\textcolor{ForestGreen}"
    if ratio < 0.5:
        arrow = "$\\megafastarrow$"
        color = "\\textcolor{ForestGreen}"
    if ratio > 1.2:
        arrow = "$\\slowarrow$"
        color = "\\textcolor{OrangeRed}"
    if ratio > 1.5:
        arrow = "$\\megaslowarrow$"
        color = "\\textcolor{OrangeRed}"

    rel_str = color + "{" + f"{1/ratio:.2f}" + "} & " + color + "{" + arrow + "}"
    print(models[row.model], "&", f"{int(row.n_data):d}", "&", f"{row.none:.3f} & {row.static:.3f} & {rel_str} \\\\")



