PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset"


load(paste(PATH,"RFval.rda", sep="/"))
load(paste(PATH,"ctreeval.rda", sep="/"))
load(paste(PATH,"NaiveBayesval.rda", sep="/"))



Results <- c()

Results <- list(RF=RFVRes, ctree=ctreeVRes,NB=NBVRes)

RMSValues <- unlist(lapply(Results,function(x) x$RMSError ))



PctMatches <- unlist(lapply(Results,function(x) x$ExactMatch ))

barchart(RMSValues)
barchart(PctMatches)
