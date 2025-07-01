
import pandas as pd


df_ours = pd.read_csv("evaluation/paper_vi_results.csv", sep=",")
df_ours.set_index("model", inplace=True)

df_pyro = pd.read_csv("compare/pyro_bbvi/paper_vi_results.csv", sep=",")
df_pyro.set_index("model", inplace=True)

models = {
    "aircraft": "Aircraft",
    "bayesian_network": "Bayesian Network",
    # "captcha": "Captcha",
    # "dirichlet_process": "Dirichlet process",
    "geometric": "Geometric",
    "gmm_fixed_numclust": "GMM (fixed \\#clusters)",
    # "gmm_variable_numclust": "GMM (variable \\#clusters)",
    "hmm": "HMM",
    "hmm_unrolled": "HMM (unrolled)",
    "hurricane": "Hurricane",
    "lda_fixed_numtopic": "LDA (fixed \\#topics)",
    # "lda_variable_numtopic": "LDA (variable \\#topics)",
    "linear_regression": "Linear regression",
    "marsaglia": "Marsaglia",
    "pcfg": "PCFG",
    "pedestrian": "Pedestrian",
    # "urn": "Urn",
}

for model, model_name in models.items():
    
    ours_none = df_ours.loc[model].none
    ours_time_none = df_ours.loc[model].time_none
    ours_static = df_ours.loc[model].static
    ours_time_static = df_ours.loc[model].time_static
    ours_ratio = df_ours.loc[model].rel_static
    
    try:
        pyro_ratio = df_pyro.loc[model].rel_graph
        pyro_time_none = df_pyro.loc[model].time_none
        pyro_time_graph = df_pyro.loc[model].time_graph
        pyro_str = f"{pyro_ratio:.2f} & {pyro_time_graph / pyro_time_none: .2f}"
    except KeyError:
        pyro_str = "- & -"
        
    
    arrow = "$\\samearrow$"
    color = "\\textcolor{Gray}"
    if ours_ratio > 10:
        arrow = "$\\megaslowarrow$"
        color = "\\textcolor{ForestGreen}"
    elif ours_ratio > 2:
        arrow = "$\\slowarrow$"
        color = "\\textcolor{ForestGreen}"
    elif ours_ratio < 0.5:
        arrow = "$\\megafastarrow$"
        color = "\\textcolor{OrangeRed}"
    elif ours_ratio < 0.1:
        arrow = "$\\fastarrow$"
        color = "\\textcolor{OrangeRed}"

    rel_str = color + "{" + f"{ours_ratio:.2f}" + "} & " + color + "{" + arrow + "}"
    print(model_name, "&", f"{ours_none:.3e} & {ours_static:.3e} & {rel_str} & {ours_time_static/ours_time_none:.2f} & {pyro_str} \\\\")



