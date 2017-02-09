# pseudorsq
Pseudo-rsquareds under complex sampling

People have asked me about the Nagelkerke pseudo-rsquared statistic for logistic regression and how to compute it with the survey package. 

To start with, it's not trivial to decide what the statistic should even be under complex sampling.  I wrote a paper: https://arxiv.org/abs/1701.07745. The code in `rsquared.R` does the computations. It will end up in the 'survey' package

Given the design-based definition, it's then interesting to see how the value differs from a computation ignoring the sampling.  

The difference is dramatic under case-control sampling: the statistic doesn't just depend on the likelihood ratio, so unweighted logistic regression isn't consistent for the full-cohort value.

THE R CODE IN THIS REPOSITORY MAY BE USED BY ANYONE FOR ANY PURPOSE.  ATTRIBUTION WOULD BE NICE BUT IS NOT REQUIRED.  

