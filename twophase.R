library(survey)
library(survival)
##
## Built-in dataset data(nwtco) from National Wilms' Tumor Study Group
##

data(nwtco)

model_cohort <- glm(rel~factor(stage)*factor(histol),data=nwtco,family=binomial())


### case-control
set.seed(2017-1-26)
ccsample<-rbind(subset(nwtco, rel==1), subset(nwtco,rel==0)[sample(3457,571),])
ccsample$weights<-with(ccsample, ifelse(rel==1,1, 3457/571))
dccsample<-svydesign(id=~1, strata=~rel, weights=~weights,data=ccsample)
model_ccsample<-svyglm(rel~factor(stage)*factor(histol),design=dccsample,family=quasibinomial())

## unweighted logistic regression for case-control sample
model_unwt <- glm(rel~factor(stage)*factor(histol),data=ccsample,family=binomial())


 ## two-phase case-control
 ## Similar to Breslow & Chatterjee, Applied Statistics (1999) but with
 ## a slightly different version of the data set
 
 nwtco$incc2<-as.logical(with(nwtco, ifelse(rel | instit==2,1,rbinom(nrow(nwtco),1,.1))))
 dsample_xy<-twophase(id=list(~seqno,~seqno),strata=list(NULL,~interaction(rel,instit)),
    data=nwtco, subset=~incc2)
 
  model_samplexy<-svyglm(rel~factor(stage)*factor(histol),design=dsample_xy,family=quasibinomial())
  
## Cox--Snell 

psrsq(model_cohort)    # full cohort
psrsq(model_ccsample)  # design-based, case-control sample
psrsq(model_samplexy)  # design-based, twophase sample

psrsq(model_unwt) # biased, ignores design  

## Nagelkerke

psrsq(model_cohort,method="Nagelkerke")    # full cohort
psrsq(model_ccsample,method="Nagelkerke")  # design-based, case-control sample
psrsq(model_samplexy,method="Nagelkerke")  # design-based, twophase sample

psrsq(model_unwt,method="Nagelkerke") # biased, ignores design  
