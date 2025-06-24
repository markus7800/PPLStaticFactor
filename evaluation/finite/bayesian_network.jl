

function bayesian_network_ANAPHYLAXIS(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    ANAPHYLAXIS_old::Int = manual_read(ctx, "ANAPHYLAXIS")
    ANAPHYLAXIS_new::Int = manual_revisit(ctx, "ANAPHYLAXIS", Categorical(get_cpt(CPTs, "ANAPHYLAXIS"), check_args = false))

    manual_add_logpdf(ctx, "TPR", Categorical(get_cpt(CPTs, "TPR", ANAPHYLAXIS_new), check_args = false))
    manual_sub_logpdf(ctx, "TPR", Categorical(get_cpt(CPTs, "TPR", ANAPHYLAXIS_old), check_args = false))
end

function bayesian_network_ARTCO2(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    VENTLUNG::Int = manual_read(ctx, "VENTLUNG")
    VENTALV::Int = manual_read(ctx, "VENTALV")
    SAO2::Int = manual_read(ctx, "SAO2")
    TPR::Int = manual_read(ctx, "TPR")
    INSUFFANESTH::Int = manual_read(ctx, "INSUFFANESTH")

    ARTCO2_old::Int = manual_read(ctx, "ARTCO2")
    ARTCO2_new::Int = manual_revisit(ctx, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", VENTALV), check_args = false))

    manual_add_logpdf(ctx, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", ARTCO2_new, VENTLUNG), check_args = false))
    manual_sub_logpdf(ctx, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", ARTCO2_old, VENTLUNG), check_args = false))
    
    manual_add_logpdf(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2_new, INSUFFANESTH, SAO2, TPR), check_args = false))
    manual_sub_logpdf(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2_old, INSUFFANESTH, SAO2, TPR), check_args = false))
end

function bayesian_network_BP(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    TPR::Int = manual_read(ctx, "TPR")
    CO::Int = manual_read(ctx, "CO")

    BP_old::Int = manual_read(ctx, "BP")
    BP_new::Int = manual_revisit(ctx, "BP", Categorical(get_cpt(CPTs, "BP", CO, TPR), check_args = false))
end

function bayesian_network_CATECHOL(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    ARTCO2::Int = manual_read(ctx, "ARTCO2")
    SAO2::Int = manual_read(ctx, "SAO2")
    TPR::Int = manual_read(ctx, "TPR")
    INSUFFANESTH::Int = manual_read(ctx, "INSUFFANESTH")

    CATECHOL_old::Int = manual_read(ctx, "CATECHOL")
    CATECHOL_new::Int = manual_revisit(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH, SAO2, TPR), check_args = false))

    manual_add_logpdf(ctx, "HR", Categorical(get_cpt(CPTs, "HR", CATECHOL_new), check_args = false))
    manual_sub_logpdf(ctx, "HR", Categorical(get_cpt(CPTs, "HR", CATECHOL_old), check_args = false))
end

function bayesian_network_CO(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    TPR::Int = manual_read(ctx, "TPR")
    HR::Int = manual_read(ctx, "HR")
    STROKEVOLUME::Int = manual_read(ctx, "STROKEVOLUME")

    CO_old::Int = manual_read(ctx, "CO")
    CO_new::Int = manual_revisit(ctx, "CO", Categorical(get_cpt(CPTs, "CO", HR, STROKEVOLUME), check_args = false))

    manual_add_logpdf(ctx, "BP", Categorical(get_cpt(CPTs, "BP", CO_new, TPR), check_args = false))
    manual_sub_logpdf(ctx, "BP", Categorical(get_cpt(CPTs, "BP", CO_old, TPR), check_args = false))
end

function bayesian_network_CVP(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    LVEDVOLUME::Int = manual_read(ctx, "LVEDVOLUME")

    CVP_old::Int = manual_read(ctx, "CVP")
    CVP_new::Int = manual_revisit(ctx, "CVP", Categorical(get_cpt(CPTs, "CVP", LVEDVOLUME), check_args = false))
end

function bayesian_network_DISCONNECT(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    VENTMACH::Int = manual_read(ctx, "VENTMACH")

    DISCONNECT_old::Int = manual_read(ctx, "DISCONNECT")
    DISCONNECT_new::Int = manual_revisit(ctx, "DISCONNECT", Categorical(get_cpt(CPTs, "DISCONNECT"), check_args = false))

    manual_add_logpdf(ctx, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", DISCONNECT_new, VENTMACH), check_args = false))
    manual_sub_logpdf(ctx, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", DISCONNECT_old, VENTMACH), check_args = false))
end

function bayesian_network_ERRCAUTER(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    HR::Int = manual_read(ctx, "HR")

    ERRCAUTER_old::Int = manual_read(ctx, "ERRCAUTER")
    ERRCAUTER_new::Int = manual_revisit(ctx, "ERRCAUTER", Categorical(get_cpt(CPTs, "ERRCAUTER"), check_args = false))

    manual_add_logpdf(ctx, "HREKG", Categorical(get_cpt(CPTs, "HREKG", ERRCAUTER_new, HR), check_args = false))
    manual_sub_logpdf(ctx, "HREKG", Categorical(get_cpt(CPTs, "HREKG", ERRCAUTER_old, HR), check_args = false))

    manual_add_logpdf(ctx, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", ERRCAUTER_new, HR), check_args = false))
    manual_sub_logpdf(ctx, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", ERRCAUTER_old, HR), check_args = false))
end

function bayesian_network_ERRLOWOUTPUT(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    HR::Int = manual_read(ctx, "HR")

    ERRLOWOUTPUT_old::Int = manual_read(ctx, "ERRLOWOUTPUT")
    ERRLOWOUTPUT_new::Int = manual_revisit(ctx, "ERRLOWOUTPUT", Categorical(get_cpt(CPTs, "ERRLOWOUTPUT"), check_args = false))

    manual_add_logpdf(ctx, "HRBP", Categorical(get_cpt(CPTs, "HRBP", ERRLOWOUTPUT_new, HR), check_args = false))
    manual_sub_logpdf(ctx, "HRBP", Categorical(get_cpt(CPTs, "HRBP", ERRLOWOUTPUT_old, HR), check_args = false))
end

function bayesian_network_EXPCO2(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    VENTLUNG::Int = manual_read(ctx, "VENTLUNG")
    ARTCO2::Int = manual_read(ctx, "ARTCO2")

    EXPCO2_old::Int = manual_read(ctx, "EXPCO2")
    EXPCO2_new::Int = manual_revisit(ctx, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", ARTCO2, VENTLUNG), check_args = false))
end

function bayesian_network_FIO2(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    VENTALV::Int = manual_read(ctx, "VENTALV")

    FIO2_old::Int = manual_read(ctx, "FIO2")
    FIO2_new::Int = manual_revisit(ctx, "FIO2", Categorical(get_cpt(CPTs, "FIO2"), check_args = false))
    
    manual_add_logpdf(ctx, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", FIO2_new, VENTALV), check_args = false))
    manual_sub_logpdf(ctx, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", FIO2_old, VENTALV), check_args = false))
end

function bayesian_network_HISTORY(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    LVFAILURE::Int = manual_read(ctx, "LVFAILURE")

    HISTORY_old::Int = manual_read(ctx, "HISTORY")
    HISTORY_new::Int = manual_revisit(ctx, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", LVFAILURE), check_args = false))
end

function bayesian_network_HRBP(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    HR::Int = manual_read(ctx, "HR")
    ERRLOWOUTPUT::Int = manual_read(ctx, "ERRLOWOUTPUT")

    HRBP_old::Int = manual_read(ctx, "HRBP")
    HRBP_new::Int = manual_revisit(ctx, "HRBP", Categorical(get_cpt(CPTs, "HRBP", ERRLOWOUTPUT, HR), check_args = false))
end

function bayesian_network_HREKG(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    HR::Int = manual_read(ctx, "HR")
    ERRCAUTER::Int = manual_read(ctx, "ERRCAUTER")

    HREKG_old::Int = manual_read(ctx, "HREKG")
    HREKG_new::Int = manual_revisit(ctx, "HREKG", Categorical(get_cpt(CPTs, "HREKG", ERRCAUTER, HR), check_args = false))
end

function bayesian_network_HRSAT(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    HR::Int = manual_read(ctx, "HR")
    ERRCAUTER::Int = manual_read(ctx, "ERRCAUTER")

    HRSAT_old::Int = manual_read(ctx, "HRSAT")
    HRSAT_new::Int = manual_revisit(ctx, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", ERRCAUTER, HR), check_args = false))
end

function bayesian_network_HR(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    CATECHOL::Int = manual_read(ctx, "CATECHOL")
    ERRCAUTER::Int = manual_read(ctx, "ERRCAUTER")
    ERRLOWOUTPUT::Int = manual_read(ctx, "ERRLOWOUTPUT")
    STROKEVOLUME::Int = manual_read(ctx, "STROKEVOLUME")

    HR_old::Int = manual_read(ctx, "HR")
    HR_new::Int = manual_revisit(ctx, "HR", Categorical(get_cpt(CPTs, "HR", CATECHOL), check_args = false))
    
    manual_add_logpdf(ctx, "HREKG", Categorical(get_cpt(CPTs, "HREKG", ERRCAUTER, HR_new), check_args = false))
    manual_sub_logpdf(ctx, "HREKG", Categorical(get_cpt(CPTs, "HREKG", ERRCAUTER, HR_old), check_args = false))

    manual_add_logpdf(ctx, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", ERRCAUTER, HR_new), check_args = false))
    manual_sub_logpdf(ctx, "HRSAT", Categorical(get_cpt(CPTs, "HRSAT", ERRCAUTER, HR_old), check_args = false))
    
    manual_add_logpdf(ctx, "HRBP", Categorical(get_cpt(CPTs, "HRBP", ERRLOWOUTPUT, HR_new), check_args = false))
    manual_sub_logpdf(ctx, "HRBP", Categorical(get_cpt(CPTs, "HRBP", ERRLOWOUTPUT, HR_old), check_args = false))
    
    manual_add_logpdf(ctx, "CO", Categorical(get_cpt(CPTs, "CO", HR_new, STROKEVOLUME), check_args = false))
    manual_sub_logpdf(ctx, "CO", Categorical(get_cpt(CPTs, "CO", HR_old, STROKEVOLUME), check_args = false))
end

function bayesian_network_HYPOVOLEMIA(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    LVFAILURE::Int = manual_read(ctx, "LVFAILURE")

    HYPOVOLEMIA_old::Int = manual_read(ctx, "HYPOVOLEMIA")
    HYPOVOLEMIA_new::Int = manual_revisit(ctx, "HYPOVOLEMIA", Categorical(get_cpt(CPTs, "HYPOVOLEMIA"), check_args = false))

    manual_add_logpdf(ctx, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", HYPOVOLEMIA_new, LVFAILURE), check_args = false))
    manual_sub_logpdf(ctx, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", HYPOVOLEMIA_old, LVFAILURE), check_args = false))
    
    
    manual_add_logpdf(ctx, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", HYPOVOLEMIA_new, LVFAILURE), check_args = false))
    manual_sub_logpdf(ctx, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", HYPOVOLEMIA_old, LVFAILURE), check_args = false))
end

function bayesian_network_INSUFFANESTH(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    ARTCO2::Int = manual_read(ctx, "ARTCO2")
    SAO2::Int = manual_read(ctx, "SAO2")
    TPR::Int = manual_read(ctx, "TPR")

    INSUFFANESTH_old::Int = manual_read(ctx, "INSUFFANESTH")
    INSUFFANESTH_new::Int = manual_revisit(ctx, "INSUFFANESTH", Categorical(get_cpt(CPTs, "INSUFFANESTH"), check_args = false))

    manual_add_logpdf(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH_new, SAO2, TPR), check_args = false))
    manual_sub_logpdf(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH_old, SAO2, TPR), check_args = false))
end

function bayesian_network_INTUBATION(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    VENTTUBE::Int = manual_read(ctx, "VENTTUBE")
    PULMEMBOLUS::Int = manual_read(ctx, "PULMEMBOLUS")
    KINKEDTUBE::Int = manual_read(ctx, "KINKEDTUBE")
    VENTLUNG::Int = manual_read(ctx, "VENTLUNG")

    INTUBATION_old::Int = manual_read(ctx, "INTUBATION")
    INTUBATION_new::Int = manual_revisit(ctx, "INTUBATION", Categorical(get_cpt(CPTs, "INTUBATION"), check_args = false))
    
    
    manual_add_logpdf(ctx, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", INTUBATION_new, PULMEMBOLUS), check_args = false))
    manual_sub_logpdf(ctx, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", INTUBATION_old, PULMEMBOLUS), check_args = false))
    
    manual_add_logpdf(ctx, "PRESS", Categorical(get_cpt(CPTs, "PRESS", INTUBATION_new, KINKEDTUBE, VENTTUBE), check_args = false))
    manual_sub_logpdf(ctx, "PRESS", Categorical(get_cpt(CPTs, "PRESS", INTUBATION_old, KINKEDTUBE, VENTTUBE), check_args = false))

    manual_add_logpdf(ctx, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION_new, KINKEDTUBE, VENTTUBE), check_args = false))
    manual_sub_logpdf(ctx, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION_old, KINKEDTUBE, VENTTUBE), check_args = false))

    manual_add_logpdf(ctx, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", INTUBATION_new, VENTLUNG), check_args = false))
    manual_sub_logpdf(ctx, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", INTUBATION_old, VENTLUNG), check_args = false))
    
    manual_add_logpdf(ctx, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", INTUBATION_new, VENTLUNG), check_args = false))
    manual_sub_logpdf(ctx, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", INTUBATION_old, VENTLUNG), check_args = false))
end

function bayesian_network_KINKEDTUBE(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    VENTTUBE::Int = manual_read(ctx, "VENTTUBE")
    INTUBATION::Int = manual_read(ctx, "INTUBATION")

    KINKEDTUBE_old::Int = manual_read(ctx, "KINKEDTUBE")
    KINKEDTUBE_new::Int = manual_revisit(ctx, "KINKEDTUBE", Categorical(get_cpt(CPTs, "KINKEDTUBE"), check_args = false))

    manual_add_logpdf(ctx, "PRESS", Categorical(get_cpt(CPTs, "PRESS", INTUBATION, KINKEDTUBE_new, VENTTUBE), check_args = false))
    manual_sub_logpdf(ctx, "PRESS", Categorical(get_cpt(CPTs, "PRESS", INTUBATION, KINKEDTUBE_old, VENTTUBE), check_args = false))

    manual_add_logpdf(ctx, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION, KINKEDTUBE_new, VENTTUBE), check_args = false))
    manual_sub_logpdf(ctx, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION, KINKEDTUBE_old, VENTTUBE), check_args = false))
end

function bayesian_network_LVEDVOLUME(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    LVFAILURE::Int = manual_read(ctx, "LVFAILURE")
    HYPOVOLEMIA::Int = manual_read(ctx, "HYPOVOLEMIA")

    LVEDVOLUME_old::Int = manual_read(ctx, "LVEDVOLUME")
    LVEDVOLUME_new::Int = manual_revisit(ctx, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", HYPOVOLEMIA, LVFAILURE), check_args = false))

    manual_add_logpdf(ctx, "PCWP", Categorical(get_cpt(CPTs, "PCWP", LVEDVOLUME_new), check_args = false))
    manual_sub_logpdf(ctx, "PCWP", Categorical(get_cpt(CPTs, "PCWP", LVEDVOLUME_old), check_args = false))

    manual_add_logpdf(ctx, "CVP", Categorical(get_cpt(CPTs, "CVP", LVEDVOLUME_new), check_args = false))
    manual_sub_logpdf(ctx, "CVP", Categorical(get_cpt(CPTs, "CVP", LVEDVOLUME_old), check_args = false))
end

function bayesian_network_LVFAILURE(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    HYPOVOLEMIA::Int = manual_read(ctx, "HYPOVOLEMIA")

    LVFAILURE_old::Int = manual_read(ctx, "LVFAILURE")
    LVFAILURE_new::Int = manual_revisit(ctx, "LVFAILURE", Categorical(get_cpt(CPTs, "LVFAILURE"), check_args = false))

    manual_add_logpdf(ctx, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", LVFAILURE_new), check_args = false))
    manual_sub_logpdf(ctx, "HISTORY", Categorical(get_cpt(CPTs, "HISTORY", LVFAILURE_old), check_args = false))
    
    manual_add_logpdf(ctx, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", HYPOVOLEMIA, LVFAILURE_new), check_args = false))
    manual_sub_logpdf(ctx, "LVEDVOLUME", Categorical(get_cpt(CPTs, "LVEDVOLUME", HYPOVOLEMIA, LVFAILURE_old), check_args = false))
    
    
    manual_add_logpdf(ctx, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", HYPOVOLEMIA, LVFAILURE_new), check_args = false))
    manual_sub_logpdf(ctx, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", HYPOVOLEMIA, LVFAILURE_old), check_args = false))
end

function bayesian_network_MINVOLSET(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    MINVOLSET_old::Int = manual_read(ctx, "MINVOLSET")
    MINVOLSET_new::Int = manual_revisit(ctx, "MINVOLSET", Categorical(get_cpt(CPTs, "MINVOLSET"), check_args = false))

    manual_add_logpdf(ctx, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", MINVOLSET_new), check_args = false))
    manual_sub_logpdf(ctx, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", MINVOLSET_old), check_args = false))
end

function bayesian_network_MINVOL(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    INTUBATION::Int = manual_read(ctx, "INTUBATION")
    VENTLUNG::Int = manual_read(ctx, "VENTLUNG")

    MINVOL_old::Int = manual_read(ctx, "MINVOL")
    MINVOL_new::Int = manual_revisit(ctx, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", INTUBATION, VENTLUNG), check_args = false))
end

function bayesian_network_PAP(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    PULMEMBOLUS::Int = manual_read(ctx, "PULMEMBOLUS")

    PAP_old::Int = manual_read(ctx, "PAP")
    PAP_new::Int = manual_revisit(ctx, "PAP", Categorical(get_cpt(CPTs, "PAP", PULMEMBOLUS), check_args = false))
end

function bayesian_network_PCWP(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    LVEDVOLUME::Int = manual_read(ctx, "LVEDVOLUME")

    PCWP_old::Int = manual_read(ctx, "PCWP")
    PCWP_new::Int = manual_revisit(ctx, "PCWP", Categorical(get_cpt(CPTs, "PCWP", LVEDVOLUME), check_args = false))
end

function bayesian_network_PRESS(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    VENTTUBE::Int = manual_read(ctx, "VENTTUBE")
    INTUBATION::Int = manual_read(ctx, "INTUBATION")
    KINKEDTUBE::Int = manual_read(ctx, "KINKEDTUBE")

    PRESS_old::Int = manual_read(ctx, "PRESS")
    PRESS_new::Int = manual_revisit(ctx, "PRESS", Categorical(get_cpt(CPTs, "PRESS", INTUBATION, KINKEDTUBE, VENTTUBE), check_args = false))
end

function bayesian_network_PULMEMBOLUS(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    INTUBATION::Int = manual_read(ctx, "INTUBATION")

    PULMEMBOLUS_old::Int = manual_read(ctx, "PULMEMBOLUS")
    PULMEMBOLUS_new::Int = manual_revisit(ctx, "PULMEMBOLUS", Categorical(get_cpt(CPTs, "PULMEMBOLUS"), check_args = false))

    manual_add_logpdf(ctx, "PAP", Categorical(get_cpt(CPTs, "PAP", PULMEMBOLUS_new), check_args = false))
    manual_sub_logpdf(ctx, "PAP", Categorical(get_cpt(CPTs, "PAP", PULMEMBOLUS_old), check_args = false))

    manual_add_logpdf(ctx, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", INTUBATION, PULMEMBOLUS_new), check_args = false))
    manual_sub_logpdf(ctx, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", INTUBATION, PULMEMBOLUS_old), check_args = false))
end

function bayesian_network_PVSAT(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    SHUNT::Int = manual_read(ctx, "SHUNT")
    FIO2::Int = manual_read(ctx, "FIO2")
    VENTALV::Int = manual_read(ctx, "VENTALV")

    PVSAT_old::Int = manual_read(ctx, "PVSAT")
    PVSAT_new::Int = manual_revisit(ctx, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", FIO2, VENTALV), check_args = false))

    manual_add_logpdf(ctx, "SAO2", Categorical(get_cpt(CPTs, "SAO2", PVSAT_new, SHUNT), check_args = false))
    manual_sub_logpdf(ctx, "SAO2", Categorical(get_cpt(CPTs, "SAO2", PVSAT_old, SHUNT), check_args = false))
end

function bayesian_network_SAO2(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    SHUNT::Int = manual_read(ctx, "SHUNT")
    ARTCO2::Int = manual_read(ctx, "ARTCO2")
    PVSAT::Int = manual_read(ctx, "PVSAT")
    TPR::Int = manual_read(ctx, "TPR")
    INSUFFANESTH::Int = manual_read(ctx, "INSUFFANESTH")

    SAO2_old::Int = manual_read(ctx, "SAO2")
    SAO2_new::Int = manual_revisit(ctx, "SAO2", Categorical(get_cpt(CPTs, "SAO2", PVSAT, SHUNT), check_args = false))
    
    manual_add_logpdf(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH, SAO2_new, TPR), check_args = false))
    manual_sub_logpdf(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH, SAO2_old, TPR), check_args = false))
end

function bayesian_network_SHUNT(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    INTUBATION::Int = manual_read(ctx, "INTUBATION")
    PULMEMBOLUS::Int = manual_read(ctx, "PULMEMBOLUS")
    PVSAT::Int = manual_read(ctx, "PVSAT")

    SHUNT_old::Int = manual_read(ctx, "SHUNT")
    SHUNT_new::Int = manual_revisit(ctx, "SHUNT", Categorical(get_cpt(CPTs, "SHUNT", INTUBATION, PULMEMBOLUS), check_args = false))
    
    manual_add_logpdf(ctx, "SAO2", Categorical(get_cpt(CPTs, "SAO2", PVSAT, SHUNT_new), check_args = false))
    manual_sub_logpdf(ctx, "SAO2", Categorical(get_cpt(CPTs, "SAO2", PVSAT, SHUNT_old), check_args = false))
end

function bayesian_network_STROKEVOLUME(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    HR::Int = manual_read(ctx, "HR")
    LVFAILURE::Int = manual_read(ctx, "LVFAILURE")
    HYPOVOLEMIA::Int = manual_read(ctx, "HYPOVOLEMIA")

    STROKEVOLUME_old::Int = manual_read(ctx, "STROKEVOLUME")
    STROKEVOLUME_new::Int = manual_revisit(ctx, "STROKEVOLUME", Categorical(get_cpt(CPTs, "STROKEVOLUME", HYPOVOLEMIA, LVFAILURE), check_args = false))

    manual_add_logpdf(ctx, "CO", Categorical(get_cpt(CPTs, "CO", HR, STROKEVOLUME_new), check_args = false))
    manual_sub_logpdf(ctx, "CO", Categorical(get_cpt(CPTs, "CO", HR, STROKEVOLUME_old), check_args = false))
end

function bayesian_network_TPR(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    ARTCO2::Int = manual_read(ctx, "ARTCO2")
    SAO2::Int = manual_read(ctx, "SAO2")
    ANAPHYLAXIS::Int = manual_read(ctx, "ANAPHYLAXIS")
    INSUFFANESTH::Int = manual_read(ctx, "INSUFFANESTH")
    CO::Int = manual_read(ctx, "CO")

    TPR_old::Int = manual_read(ctx, "TPR")
    TPR_new::Int = manual_revisit(ctx, "TPR", Categorical(get_cpt(CPTs, "TPR", ANAPHYLAXIS), check_args = false))
    
    manual_add_logpdf(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH, SAO2, TPR_new), check_args = false))
    manual_sub_logpdf(ctx, "CATECHOL", Categorical(get_cpt(CPTs, "CATECHOL", ARTCO2, INSUFFANESTH, SAO2, TPR_old), check_args = false))
    
    manual_add_logpdf(ctx, "BP", Categorical(get_cpt(CPTs, "BP", CO, TPR_new), check_args = false))
    manual_sub_logpdf(ctx, "BP", Categorical(get_cpt(CPTs, "BP", CO, TPR_old), check_args = false))
end

function bayesian_network_VENTALV(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    INTUBATION::Int = manual_read(ctx, "INTUBATION")
    FIO2::Int = manual_read(ctx, "FIO2")
    VENTLUNG::Int = manual_read(ctx, "VENTLUNG")

    VENTALV_old::Int = manual_read(ctx, "VENTALV")
    VENTALV_new::Int = manual_revisit(ctx, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", INTUBATION, VENTLUNG), check_args = false))

    manual_add_logpdf(ctx, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", VENTALV_new), check_args = false))
    manual_sub_logpdf(ctx, "ARTCO2", Categorical(get_cpt(CPTs, "ARTCO2", VENTALV_old), check_args = false))
    
    manual_add_logpdf(ctx, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", FIO2, VENTALV_new), check_args = false))
    manual_sub_logpdf(ctx, "PVSAT", Categorical(get_cpt(CPTs, "PVSAT", FIO2, VENTALV_old), check_args = false))
end

function bayesian_network_VENTLUNG(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    VENTTUBE::Int = manual_read(ctx, "VENTTUBE")
    INTUBATION::Int = manual_read(ctx, "INTUBATION")
    KINKEDTUBE::Int = manual_read(ctx, "KINKEDTUBE")
    ARTCO2::Int = manual_read(ctx, "ARTCO2")

    VENTLUNG_old::Int = manual_read(ctx, "VENTLUNG")
    VENTLUNG_new::Int = manual_revisit(ctx, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION, KINKEDTUBE, VENTTUBE), check_args = false))

    manual_add_logpdf(ctx, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", INTUBATION, VENTLUNG_new), check_args = false))
    manual_sub_logpdf(ctx, "MINVOL", Categorical(get_cpt(CPTs, "MINVOL", INTUBATION, VENTLUNG_old), check_args = false))

    manual_add_logpdf(ctx, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", INTUBATION, VENTLUNG_new), check_args = false))
    manual_sub_logpdf(ctx, "VENTALV", Categorical(get_cpt(CPTs, "VENTALV", INTUBATION, VENTLUNG_old), check_args = false))
    
    manual_add_logpdf(ctx, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", ARTCO2, VENTLUNG_new), check_args = false))
    manual_sub_logpdf(ctx, "EXPCO2", Categorical(get_cpt(CPTs, "EXPCO2", ARTCO2, VENTLUNG_old), check_args = false))
end

function bayesian_network_VENTMACH(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    MINVOLSET::Int = manual_read(ctx, "MINVOLSET")
    DISCONNECT::Int = manual_read(ctx, "DISCONNECT")

    VENTMACH_old::Int = manual_read(ctx, "VENTMACH")
    VENTMACH_new::Int = manual_revisit(ctx, "VENTMACH", Categorical(get_cpt(CPTs, "VENTMACH", MINVOLSET), check_args = false))
    
    manual_add_logpdf(ctx, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", DISCONNECT, VENTMACH_new), check_args = false))
    manual_sub_logpdf(ctx, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", DISCONNECT, VENTMACH_old), check_args = false))
end

function bayesian_network_VENTTUBE(ctx::AbstractManualRevisitContext, CPTs::CPTsDict)
    VENTMACH::Int = manual_read(ctx, "VENTMACH")
    DISCONNECT::Int = manual_read(ctx, "DISCONNECT")
    INTUBATION::Int = manual_read(ctx, "INTUBATION")
    KINKEDTUBE::Int = manual_read(ctx, "KINKEDTUBE")

    VENTTUBE_old::Int = manual_read(ctx, "VENTTUBE")
    VENTTUBE_new::Int = manual_revisit(ctx, "VENTTUBE", Categorical(get_cpt(CPTs, "VENTTUBE", DISCONNECT, VENTMACH), check_args = false))
    
    manual_add_logpdf(ctx, "PRESS", Categorical(get_cpt(CPTs, "PRESS", INTUBATION, KINKEDTUBE, VENTTUBE_new), check_args = false))
    manual_sub_logpdf(ctx, "PRESS", Categorical(get_cpt(CPTs, "PRESS", INTUBATION, KINKEDTUBE, VENTTUBE_old), check_args = false))
    
    manual_add_logpdf(ctx, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION, KINKEDTUBE, VENTTUBE_new), check_args = false))
    manual_sub_logpdf(ctx, "VENTLUNG", Categorical(get_cpt(CPTs, "VENTLUNG", INTUBATION, KINKEDTUBE, VENTTUBE_old), check_args = false))
end

function bayesian_network_manual_factor(ctx::AbstractManualRevisitContext, CPTs::CPTsDict, addr::String)
    if addr == "ANAPHYLAXIS"
        return bayesian_network_ANAPHYLAXIS(ctx, CPTs)
    end
    if addr == "ARTCO2"
        return bayesian_network_ARTCO2(ctx, CPTs)
    end
    if addr == "BP"
        return bayesian_network_BP(ctx, CPTs)
    end
    if addr == "CATECHOL"
        return bayesian_network_CATECHOL(ctx, CPTs)
    end
    if addr == "CO"
        return bayesian_network_CO(ctx, CPTs)
    end
    if addr == "CVP"
        return bayesian_network_CVP(ctx, CPTs)
    end
    if addr == "DISCONNECT"
        return bayesian_network_DISCONNECT(ctx, CPTs)
    end
    if addr == "ERRCAUTER"
        return bayesian_network_ERRCAUTER(ctx, CPTs)
    end
    if addr == "ERRLOWOUTPUT"
        return bayesian_network_ERRLOWOUTPUT(ctx, CPTs)
    end
    if addr == "EXPCO2"
        return bayesian_network_EXPCO2(ctx, CPTs)
    end
    if addr == "FIO2"
        return bayesian_network_FIO2(ctx, CPTs)
    end
    if addr == "HISTORY"
        return bayesian_network_HISTORY(ctx, CPTs)
    end
    if addr == "HRBP"
        return bayesian_network_HRBP(ctx, CPTs)
    end
    if addr == "HREKG"
        return bayesian_network_HREKG(ctx, CPTs)
    end
    if addr == "HRSAT"
        return bayesian_network_HRSAT(ctx, CPTs)
    end
    if addr == "HR"
        return bayesian_network_HR(ctx, CPTs)
    end
    if addr == "HYPOVOLEMIA"
        return bayesian_network_HYPOVOLEMIA(ctx, CPTs)
    end
    if addr == "INSUFFANESTH"
        return bayesian_network_INSUFFANESTH(ctx, CPTs)
    end
    if addr == "INTUBATION"
        return bayesian_network_INTUBATION(ctx, CPTs)
    end
    if addr == "KINKEDTUBE"
        return bayesian_network_KINKEDTUBE(ctx, CPTs)
    end
    if addr == "LVEDVOLUME"
        return bayesian_network_LVEDVOLUME(ctx, CPTs)
    end
    if addr == "LVFAILURE"
        return bayesian_network_LVFAILURE(ctx, CPTs)
    end
    if addr == "MINVOLSET"
        return bayesian_network_MINVOLSET(ctx, CPTs)
    end
    if addr == "MINVOL"
        return bayesian_network_MINVOL(ctx, CPTs)
    end
    if addr == "PAP"
        return bayesian_network_PAP(ctx, CPTs)
    end
    if addr == "PCWP"
        return bayesian_network_PCWP(ctx, CPTs)
    end
    if addr == "PRESS"
        return bayesian_network_PRESS(ctx, CPTs)
    end
    if addr == "PULMEMBOLUS"
        return bayesian_network_PULMEMBOLUS(ctx, CPTs)
    end
    if addr == "PVSAT"
        return bayesian_network_PVSAT(ctx, CPTs)
    end
    if addr == "SAO2"
        return bayesian_network_SAO2(ctx, CPTs)
    end
    if addr == "SHUNT"
        return bayesian_network_SHUNT(ctx, CPTs)
    end
    if addr == "STROKEVOLUME"
        return bayesian_network_STROKEVOLUME(ctx, CPTs)
    end
    if addr == "TPR"
        return bayesian_network_TPR(ctx, CPTs)
    end
    if addr == "VENTALV"
        return bayesian_network_VENTALV(ctx, CPTs)
    end
    if addr == "VENTLUNG"
        return bayesian_network_VENTLUNG(ctx, CPTs)
    end
    if addr == "VENTMACH"
        return bayesian_network_VENTMACH(ctx, CPTs)
    end
    if addr == "VENTTUBE"
        return bayesian_network_VENTTUBE(ctx, CPTs)
    end
    error("Cannot find factor for $addr")
end


function finite_factor(ctx::AbstractManualRevisitContext, addr::String)
    return bayesian_network_manual_factor(ctx, CPTs, addr)
end

function finite_factor(ctx::AbstractManualRevisitContext)
    return bayesian_network_manual_factor(ctx, CPTs, ctx.resample_addr)
end
