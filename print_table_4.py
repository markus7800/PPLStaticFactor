
import pandas as pd

df_ours = pd.read_csv("evaluation/paper_smc_results.csv", sep=",")
df_ours.set_index("model", inplace=True)

df_webppl = pd.read_csv("compare/webppl/paper_smc_results.csv", sep=",")
df_webppl.set_index("model", inplace=True)


models = {
    # "aircraft": "Aircraft",
    # "bayesian_network": "Bayesian Network",
    # "captcha": "Captcha",
    "dirichlet_process": "Dirichlet process",
    # "geometric": "Geometric",
    "gmm_fixed_numclust": "GMM (fixed \\#clusters)",
    "gmm_variable_numclust": "GMM (variable \\#clusters)",
    "hmm": "HMM",
    "hmm_unrolled": "HMM (no loop)",
    # "hurricane": "Hurricane",
    "lda_fixed_numtopic": "LDA (fixed \\#topics)",
    "lda_variable_numtopic": "LDA (variable \\#topics)",
    # "linear_regression": "Linear regression",
    # "marsaglia": "Marsaglia",
    # "pcfg": "PCFG",
    # "pedestrian": "Pedestrian",
    # "urn": "Urn",
}

for model, model_name in models.items():
    n_data = df_ours.loc[model].n_data
    
    ours_none = df_ours.loc[model].none
    ours_static = df_ours.loc[model].static
    ours_ratio = df_ours.loc[model].rel_static
    
    webppl_ratio = df_webppl.loc[model].cps_rel

    arrow = "$\\samearrow$"
    color = "\\textcolor{Gray}"
    if ours_ratio < 0.8:
        arrow = "$\\fastarrow$"
        color = "\\textcolor{ForestGreen}"
    if ours_ratio < 0.5:
        arrow = "$\\megafastarrow$"
        color = "\\textcolor{ForestGreen}"
    if ours_ratio > 1.2:
        arrow = "$\\slowarrow$"
        color = "\\textcolor{OrangeRed}"
    if ours_ratio > 1.5:
        arrow = "$\\megaslowarrow$"
        color = "\\textcolor{OrangeRed}"

    rel_str = color + "{" + f"{1/ours_ratio:.2f}" + "} & " + color + "{" + arrow + "}"
    print(model_name, "&", f"{int(n_data):d}", "&", f"{ours_none:.3f} & {ours_static:.3f} & {rel_str} & {1/webppl_ratio:.2f} \\\\")



