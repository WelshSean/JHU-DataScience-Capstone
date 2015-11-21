PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset"


load(paste(PATH,"rparttraining.rda", sep="/"))
load(paste(PATH,"lmtraining.rda", sep="/"))
load(paste(PATH,"RFtraining.rda", sep="/"))
load(paste(PATH,"ctreetraining.rda", sep="/"))
load(paste(PATH,"ctree2training.rda", sep="/"))
load(paste(PATH,"NaiveBayestraining.rda", sep="/"))
load(paste(PATH,"lm2training.rda", sep="/"))
load(paste(PATH,"RF2training.rda", sep="/"))
load(paste(PATH,"rpart2training.rda", sep="/"))


Results <- c()

Results <- list(rpart=rpartRes, lm=lmRes, RF=RFRes, ctree=ctreeRes,NB=NBRes,RF2=RF2Res, lm2=lm2Res,rpart2=rpart2Res,ctree2=ctree2Res)

RMSValues <- unlist(lapply(Results,function(x) x$RMSError ))



PctMatches <- unlist(lapply(Results,function(x) x$ExactMatch ))

barchart(RMSValues)
barchart(PctMatches)
