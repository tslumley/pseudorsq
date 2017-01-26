# Simulation example
library(survey)
set.seed(2017-1-26)
population<-data.frame(x=rnorm(1e5))
population$mu<-with(population, exp(x-6))
population$y<-with(population, rbinom(1e5,1,mu))

source("rsquared.R")
print(psrsq(glm(y~x,data=population, family=binomial)))
print(psrsq(glm(y~x,data=population, family=binomial),method="Nagelkerke"))


cases<-subset(population, y==1)
ncases<-nrow(cases)

notcases<-subset(population,y==0)
nnotcases<-nrow(notcases)

for(m in c(1,2,5,10,20)){
	controls<-notcases[sample(nnotcases, m*ncases),]
	df<-rbind(cases,controls)
	
	print(psrsq(glm(y~x,data=df,family=binomial)))
		print(psrsq(glm(y~x,data=df,family=binomial),method="Nagelkerke"))

	df$wt<-with(df, ifelse(y==1,1,nnotcases/(m*ncases)))
	des<-svydesign(id=~1, data=df, weights=~wt, strata=~y)	
	print(psrsq(svyglm(y~x,design=des,family=quasibinomial)))
	print(psrsq(svyglm(y~x,design=des,family=quasibinomial),method="Nagelkerke"))
}