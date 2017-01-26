# pseudorsq
Pseudo-rsquareds under complex sampling

People have asked me about the Nagelkerke pseudo-rsquared statistic for logistic regression and how to compute it with the survey package. 

To start with, it's not trivial to decide what the statistic should even be under complex sampling.  The code in `rsquared.R` does the computations

Given the design-based definition, it's then interesting to see how the value differs from a computation ignoring the sampling.  

The difference is dramatic under case-control sampling: the statistic doesn't just depend on the likelihood ratio, so unweighted logistic regression isn't consistent for the full-cohort value.
