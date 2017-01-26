library(survey)
library(splines)
source("rsquared.R")

## see github.com/tslumley/regression-paper for details on the data set construction
nhanes<-read.csv("ish-data.csv")
des<-svydesign(id=~SDMVPSU,strat=~SDMVSTRA,weights=~fouryearwt,
   nest=TRUE, data=subset(nhanes, !is.na(WTDRD1)))
des<-update(des, sodium=DR1TSODI/1000, potassium=DR1TPOTA/1000)
des<-update(des, namol=sodium/23, kmol=potassium/39)

## define isolated systolic hypertension

des<-update(des, ish=(BPXSAR>140) & (BPXDAR<90))
#linear splines, units in decades
des<-update(des, age1=pmin(RIDAGEYR,50)/10, age2=pmin(pmax(RIDAGEYR,50),65)/10, age3=pmin(pmax(RIDAGEYR,65),90)/10)

##
## fit some models
##
ish0s <- svyglm(ish~age1+age2+age3, design=des,family=quasibinomial)	
ish1s<- svyglm(ish~age1+age2+age3+factor(RIDRETH1), design=des,family=quasibinomial)	
ish2s<- svyglm(ish~age1+age2+age3+RIAGENDR+factor(RIDRETH1), design=des,family=quasibinomial)	
ish3s<- svyglm(ish~(age1+age2+age3)*RIAGENDR+factor(RIDRETH1), design=des,family=quasibinomial)	
ish4s<- svyglm(ish~(age1+age2+age3)*RIAGENDR+factor(RIDRETH1)+sodium, design=des,family=quasibinomial)	



##
## same analysis ignoring the sampling design
##

ish0 <-glm(ish~age1+age2+age3, data=des$variables,family=binomial)	
ish1<- glm(ish~age1+age2+age3+factor(RIDRETH1), data=des$variables,family=binomial)	
ish2<- glm(ish~age1+age2+age3+RIAGENDR+factor(RIDRETH1), data=des$variables,family=binomial)	
ish3<- glm(ish~(age1+age2+age3)*RIAGENDR+factor(RIDRETH1), data=des$variables,family=binomial)	
ish4<- glm(ish~(age1+age2+age3)*RIAGENDR+factor(RIDRETH1)+sodium, data=des$variables,family=binomial)	

## rsquareds

r2cs_hat<-c(psrsq(ish0s),psrsq(ish1s),psrsq(ish2s),psrsq(ish3s),psrsq(ish4s))
r2cs<-c(psrsq(ish0),psrsq(ish1),psrsq(ish2),psrsq(ish3),psrsq(ish4))

r2N_hat<-c(psrsq(ish0s,method="Nagelkerke"),
	psrsq(ish1s,method="Nagelkerke"),
	psrsq(ish2s,method="Nagelkerke"),
	psrsq(ish3s,method="Nagelkerke"),
	psrsq(ish4s,method="Nagelkerke")
	)
r2N<-c(psrsq(ish0,method="Nagelkerke"),
	psrsq(ish1,method="Nagelkerke"),
	psrsq(ish2,method="Nagelkerke"),
	psrsq(ish3,method="Nagelkerke"),
	psrsq(ish4,method="Nagelkerke")
	)
	
	
ish_rsq<-round(cbind(r2cs,r2cs_hat,r2N,r2N_hat),2)
library(xtable)
xtable(ish_rsq)
