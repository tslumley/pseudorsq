library(survey)

## continuous data: Chapter 7, Volume 1, Breslow & Day
## http://faculty.washington.edu/norm/datasets.html
## control weight of 441 estimated from population size
tuyns<-read.table("tuynsc.txt",col.names=c("case","age","agegp","tobgp","tobacco","logtb","beer","cider",'wine',"aperitif","digestif","alcohol","logalc"))
tuyns$wt<-ifelse(tuyns$case==1,1,441)
tuyns<-subset(tuyns,  (tobacco!=99))
tdes<-svydesign(id=~1,strata=~case,data=tuyns,weight=~wt)

## Grouped data. Same original source, but now in R as data(esoph)
data(esoph)
options(contrasts=c("contr.treatment","contr.treatment"))
esophcase<-esoph[rep(1:88,esoph$ncases),1:3]
esophctrl<-esoph[rep(1:88,esoph$ncontrols),1:3]
esophcase$status<-1
esophctrl$status<-0
esophcase$wt<-1
esophctrl$wt<-441
esophlong<-rbind(esophcase,esophctrl)
des<-svydesign(id=~1,weights=~wt,data=esophlong)

##
## model fitting
grouped1s<-svyglm(status~agegp+alcgp+tobgp,family=binomial,design=des)
grouped2s<-svyglm(status~agegp+alcgp+tobgp+as.numeric(alcgp):as.numeric(tobgp),family=binomial,design=des)

grouped1<-glm(status~agegp+alcgp+tobgp,family=binomial,data=esophlong)
grouped2<-glm(status~agegp+alcgp+tobgp+as.numeric(alcgp):as.numeric(tobgp),family=binomial,data=esophlong)


cont1s<-svyglm(case~age+I(age^2)+alcohol+tobacco,family=binomial,design=tdes)
cont2s<-svyglm(case~age+I(age^2)+alcohol*tobacco,family=binomial,design=tdes)

cont1<-glm(case~age+I(age^2)+alcohol+tobacco,family=binomial,data=tuyns)
cont2<-glm(case~age+I(age^2)+alcohol*tobacco,family=binomial,data=tuyns)

## r-squared
source("rsquared.R")

rsqCS<-c(psrsq(grouped1),psrsq(grouped2),psrsq(cont1),psrsq(cont2))
rsqCS_hat<-c(psrsq(grouped1s),psrsq(grouped2s),psrsq(cont1s),psrsq(cont2s))

rsqN<-c(psrsq(grouped1,method="Nagelkerke"),
	psrsq(grouped2,method="Nagelkerke"),
	psrsq(cont1,method="Nagelkerke"),
	psrsq(cont2,method="Nagelkerke"))

rsqN_hat<-c(psrsq(grouped1s,method="Nagelkerke"),
	psrsq(grouped2s,method="Nagelkerke"),
	psrsq(cont1s,method="Nagelkerke"),
	psrsq(cont2s,method="Nagelkerke"))
	
library(xtable)	
xtable(cbind(round(rsqCS,2), round(rsqCS_hat,4),round(rsqN,2),round(rsqN_hat,2)))