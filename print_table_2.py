
import pandas as pd

df_ours = pd.read_csv("evaluation/paper_lmh_results.csv", sep=",")
df_ours.set_index("model", inplace=True)

df_gen = pd.read_csv("compare/gen/paper_lmh_results.csv", sep=",")
df_gen.set_index("model", inplace=True)

df_webppl = pd.read_csv("compare/webppl/paper_lmh_results.csv", sep=",")
df_webppl.set_index("model", inplace=True)


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

speed_up = True


table_rows = []
for model, model_name in models.items():
    ours_rel = df_ours.loc[model].rel_static
    gen_rel = df_gen.loc[model].rel
    webppl_rel = df_webppl.loc[model].rel
    # print(model_name, ours_rel, gen_rel, webppl_rel)

    ours_str = f"{ours_rel:.2f}" if not speed_up else f"{1/ours_rel:.2f}"
    if not (ours_rel > gen_rel or ours_rel > webppl_rel):
        ours_str = "\\textbf{" + ours_str + "}"

    if pd.isna(gen_rel):
        gen_str = "-"
    else:
        gen_str = f"{gen_rel:.2f}" if not speed_up else f"{1/gen_rel:.2f}"
        if not (gen_rel > webppl_rel or gen_rel > ours_rel):
            gen_str = "\\textbf{" + gen_str + "}"

    webppl_str = f"{webppl_rel:.2f}" if not speed_up else f"{1/webppl_rel:.2f}"
    if not (webppl_rel > gen_rel or webppl_rel > ours_rel):
        webppl_str = "\\textbf{" + webppl_str + "}"

    table_rows.append(f"{model_name} & {ours_str} & {gen_str} & {webppl_str}")


for i in range(len(table_rows) // 2):
    print(table_rows[i], "&", table_rows[i + len(table_rows) // 2], "\\\\")

    


