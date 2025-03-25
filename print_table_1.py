
import pandas as pd

df = pd.read_csv("evaluation/paper_lmh_results.csv", sep=",")

row_start = {
    "aircraft": "Aircraft & $\\infty$ & $1\\mathrm{e}{5}$",
    "bayesian_network": "Bayesian Network & 37 & $1\\mathrm{e}{5}$",
    "captcha": "Captcha & $\\infty$ & $1\\mathrm{e}{3}$",
    "dirichlet_process": "Dirichlet process & $\\infty$ & $1\\mathrm{e}{4}$",
    "geometric": "Geometric &  $\\infty$ & $5\\mathrm{e}{5}$",
    "gmm_fixed_numclust": "GMM (fixed \\#clusters) & 209 & $5\\mathrm{e}{4}$",
    "gmm_variable_numclust": "GMM (variable \\#clusters) & $\\infty$ & $5\\mathrm{e}{4}$",
    "hmm": "HMM & 101 & $1\\mathrm{e}{5}$",
    "hurricane": "Hurricane & 5 & $1\\mathrm{e}{6}$",
    "lda_fixed_numtopic": "LDA (fixed \\#topics) & 551 & $1\\mathrm{e}{4}$",
    "lda_variable_numtopic": "LDA (variable \\#topics) & $\\infty$ & $1\\mathrm{e}{4}$",
    "linear_regression": "Linear regression & 102 & $1\\mathrm{e}{5}$",
    "marsaglia": "Marsaglia & $\\infty$ & $5\\mathrm{e}{5}$",
    "pedestrian": "Pedestrian & $\\infty$ & $1\\mathrm{e}{5}$",
    "pcfg": "PCFG & $\\infty$ & $1\\mathrm{e}{5}$",
    "urn": "Urn & $\\infty$ & $1\\mathrm{e}{5}$",
    "hmm_unrolled": "HMM (unrolled loop) & 101 & $1\\mathrm{e}{5}$"
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
    print(row_start[row.model], "&", f"{row.acceptancerate:.2f}", "&", f"{row.none:.3f} & {row.static:.3f} & {rel_str}", end="")
    if pd.isna(row.finite):
        print(" & - & - \\\\")
    else:
        print(f" & {row.finite:.3f} & {1/(row.finite/row.none):.2f} \\\\")


