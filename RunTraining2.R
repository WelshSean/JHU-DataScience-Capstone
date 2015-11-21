####### Main script for running training analysis

# Libraries
library(rpart)
library(randomForest)
library(rpart.plot)
library(caret)
library(kernlab)
library(e1071)
library(partykit)
library(caret)

# Setup
set.seed(1974)
setwd("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone")


# Load Training Data
#PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/1pct_samples"
PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset"

load(paste(PATH, "yelptrain.rda", sep="/"))
trainpath <- paste(PATH, "trainingdata.rda", sep="/")
ctreepath <- paste(PATH, "ctreetraining.rda", sep="/")
rpartpath <- paste(PATH, "rparttraining.rda", sep="/")
RFpath <- paste(PATH, "RFtraining.rda", sep="/")
SVMpath <- paste(PATH, "SVMtraining.rda", sep="/")
trainpath <- paste(PATH, "trainingdata.rda", sep="/")
lmpath <- paste(PATH, "lmtraining.rda", sep="/")
NBpath <- paste(PATH, "NaiveBayestraining.rda", sep="/")
lm2path <- paste(PATH, "lm2training.rda", sep="/")
RF2path <- paste(PATH, "RF2training.rda", sep="/")
rpart2path <- paste(PATH, "rpart2training.rda", sep="/")
ctree2path <- paste(PATH, "ctree2training.rda", sep="/")

if (file.exists(trainpath)){
  print("Loading Training data from file") 
  load(trainpath)
} else {
  print("Creating training data")
  source("./FeatureExtraction2.R")
  trainingData <- extractFeatures2(yelpreviews)
  save(trainingData, file=trainpath)
}

trainingData <- trainingData[c("business_id", "number_stars", "pos_com", "neg_com", "review_length")]

number_stars_index <- match("number_stars", names(trainingData))
business_id_index <- match("business_id", names(trainingData))


if (!file.exists(rpartpath))
{  
  print("rpart")
  start=date()
  
#  rpartfit <- rpart(number_stars ~ . -business_id, data=trainingData, method="class")
  
  rpartfit <- train(number_stars ~ . -business_id, data=trainingData, method="rpart", tuneLength=9)
  
  
  predicted <- predict(rpartfit, newdata=trainingData[-number_stars_index], type="class")
  
  rpartRes <- c()
  
  rpartRes$Predictions <- as.data.frame(cbind(trainingData$number_stars,predicted))
  names(rpartRes$Predictions) <- c("observed", "predicted")
  rpartRes$Predictions$Difference <- rpartRes$Predictions$observed - rpartRes$Predictions$predicted
  rpartRes$summary <- summary(rpartRes$Predictions$Difference)
  rpartRes$RMSError <- sqrt(mean((rpartRes$Predictions$Difference)^2))
  rpartRes$ExactMatch <- nrow(subset(rpartRes$Predictions, rpartRes$Predictions$observed==rpartRes$Predictions$predicted))*100/nrow(rpartRes$Predictions)
  rpartRes$Times$Start=start
  rpartRes$Times$End=date()
  
  save(rpartRes, rpartfit, file = rpartpath)
} else {
  load(rpartpath)
}

# Linear Model

if (!file.exists(lmpath))
{
  print("lm")
  start=date()
  lmtraining <- trainingData
  lmtraining$number_stars <- as.integer(as.character(lmtraining$number_stars))
  
  lmfit <- lm(number_stars ~ . -business_id, data = lmtraining)
  
  
  predicted <- predict(lmfit, newdata=lmtraining[-c(number_stars_index)])
  
  lmRes <- c()
  
  lmRes$Predictions <- as.data.frame(cbind(lmtraining$number_stars,predicted))
  names(lmRes$Predictions) <- c("observed", "predicted")
  lmRes$Predictions$observed <- as.integer(lmRes$Predictions$observed)
  lmRes$Predictions$predicted <- as.integer(lmRes$Predictions$predicted)
  lmRes$Predictions$Difference <- lmRes$Predictions$observed - lmRes$Predictions$predicted
  lmRes$summary <- summary(lmRes$Predictions$Difference)
  lmRes$RMSError <- sqrt(mean((lmRes$Predictions$Difference)^2))
  lmRes$ExactMatch <- nrow(subset(lmRes$Predictions, lmRes$Predictions$observed==lmRes$Predictions$predicted))*100/nrow(lmRes$Predictions)
  lmRes$Times$Start=start
  lmRes$Times$End=date()
  
  save(lmRes, lmfit, file = lmpath)
}



# Random Forest default settings

if (!file.exists(RFpath))
{  
  print("Random Forest")
  start=date()
  
  RFfit <- randomForest(number_stars ~ . -business_id, data=trainingData)
  
  
  predicted <- predict(RFfit, newdata=trainingData[-number_stars_index], type="class")
  
  RFRes <- c()
  
  RFRes$Predictions <- as.data.frame(cbind(trainingData$number_stars,predicted))
  names(RFRes$Predictions) <- c("observed", "predicted")
  RFRes$Predictions$Difference <- RFRes$Predictions$observed - RFRes$Predictions$predicted
  RFRes$summary <- summary(RFRes$Predictions$Difference)
  RFRes$RMSError <- sqrt(mean((RFRes$Predictions$Difference)^2))
  RFRes$ExactMatch <- nrow(subset(RFRes$Predictions, RFRes$Predictions$observed==RFRes$Predictions$predicted))*100/nrow(RFRes$Predictions)
  RFRes$Times$Start=start
  RFRes$Times$End=date()
  
  save(RFRes, RFfit, file = RFpath)
} else {
  load(RFpath) 
}

## Ctree

if (!file.exists(ctreepath))
{  
  print("ctree")
  start=date()
  #training <-   data.frame(lapply(trainingData, factor))
  
  ctreefit <- ctree(number_stars ~ pos_com+neg_com+review_length , data=trainingData)
  
  
  predicted <- predict(ctreefit, newdata=trainingData[-number_stars_index])
  
  ctreeRes <- c()
  
  ctreeRes$Predictions <- as.data.frame(cbind(trainingData$number_stars,predicted))
  names(ctreeRes$Predictions) <- c("observed", "predicted")
  ctreeRes$Predictions$Difference <- ctreeRes$Predictions$observed - ctreeRes$Predictions$predicted
  ctreeRes$summary <- summary(ctreeRes$Predictions$Difference)
  ctreeRes$RMSError <- sqrt(mean((ctreeRes$Predictions$Difference)^2))
  ctreeRes$ExactMatch <- nrow(subset(ctreeRes$Predictions, ctreeRes$Predictions$observed==ctreeRes$Predictions$predicted))*100/nrow(ctreeRes$Predictions)
  ctreeRes$Times$Start=start
  ctreeRes$Times$End=date()
  
  save(ctreeRes, ctreefit, file = ctreepath)
}

# Naive Bayes

if (!file.exists(NBpath))
{  
  print("Naive Bayes")
  start=date()
  training <-   data.frame(lapply(trainingData, factor))
  
  NBfit <- naiveBayes(number_stars ~ pos_com+neg_com+review_length , data=training)
  
  
  predicted <- predict(NBfit, newdata=training[-number_stars_index], type="class")
  NBRes <- c()
  
  NBRes$Predictions <- as.data.frame(cbind(training$number_stars,predicted))
  names(NBRes$Predictions) <- c("observed", "predicted")
  NBRes$Predictions$Difference <- NBRes$Predictions$observed - NBRes$Predictions$predicted
  NBRes$summary <- summary(NBRes$Predictions$Difference)
  NBRes$RMSError <- sqrt(mean((NBRes$Predictions$Difference)^2))
  NBRes$ExactMatch <- nrow(subset(NBRes$Predictions, NBRes$Predictions$observed==NBRes$Predictions$predicted))*100/nrow(NBRes$Predictions)
  NBRes$Times$Start=start
  NBRes$Times$End=date()
  
  save(NBRes, NBfit, file = NBpath)
}

# # Support Vector Machine
# 
# if (!file.exists(SVMpath))
# {
#   print("SVM")
#   start=date()
#   SVMfit <- ksvm(number_stars ~ pos_com+neg_com+review_length,data=trainingData,kernel="rbfdot",kpar=list(sigma=0.05),C=5,cross=3, verbose=TRUE)
#   
#   predicted <- predict(SVMfit, newdata=trainingData[-c(number_stars_index)])
#   
#   SVMRes <- c()
#   
#   SVMRes$Predictions <- as.data.frame(cbind(trainingData$number_stars,predicted))
#   names(SVMRes$Predictions) <- c("observed", "predicted")
#   SVMRes$Predictions$Difference <- SVMRes$Predictions$observed - SVMRes$Predictions$predicted
#   SVMRes$summary <- summary(SVMRes$Predictions$Difference)
#   SVMRes$RMSError <- sqrt(mean((SVMRes$Predictions$Difference)^2))
#   SVMRes$ExactMatch <- nrow(subset(SVMRes$Predictions, SVMRes$Predictions$observed==SVMRes$Predictions$predicted))*100/nrow(SVMRes$Predictions)
#   SVMRes$Times$Start=start
#   SVMRes$Times$End=date()
#   
#   save(SVMRes, SVMfit, file = SVMpath)
# }

# Linear Model #2

if (!file.exists(lm2path))
{
  print("lm2")
  start=date()
  lm2training <- trainingData
  lm2training$number_stars <- as.integer(as.character(lm2training$number_stars))
  
  lm2fit <- lm(number_stars ~ pos_com+neg_com, data = lm2training)
  
  
  predicted <- predict(lm2fit, newdata=lm2training[-c(number_stars_index)])
  
  lm2Res <- c()
  
  lm2Res$Predictions <- as.data.frame(cbind(lm2training$number_stars,predicted))
  names(lm2Res$Predictions) <- c("observed", "predicted")
  lm2Res$Predictions$observed <- as.integer(lm2Res$Predictions$observed)
  lm2Res$Predictions$predicted <- as.integer(lm2Res$Predictions$predicted)
  lm2Res$Predictions$Difference <- lm2Res$Predictions$observed - lm2Res$Predictions$predicted
  lm2Res$summary <- summary(lm2Res$Predictions$Difference)
  lm2Res$RMSError <- sqrt(mean((lm2Res$Predictions$Difference)^2))
  lm2Res$ExactMatch <- nrow(subset(lm2Res$Predictions, lm2Res$Predictions$observed==lm2Res$Predictions$predicted))*100/nrow(lm2Res$Predictions)
  lm2Res$Times$Start=start
  lm2Res$Times$End=date()
  
  save(lm2Res, lm2fit, file = lm2path)
} else {
  load(lm2path)
}

# Random Forest ntree =1000

if (!file.exists(RF2path))
{  
  print("Random Forest 2")
  start=date()
  
  # SPlitting as getting Fortran longvector errors for larger ntree
  
  RF2fit1 <- randomForest(number_stars ~ . -business_id, data=trainingData[1:470780,], ntree=1000)
  print ("First tree done")
  RF2fit2 <- randomForest(number_stars ~ . -business_id, data=trainingData[470781:941560,], ntree=1000)
  RF2fit <- combine(RF2fit1, RF2fit2)
  
  predicted <- predict(RF2fit, newdata=trainingData[-number_stars_index], type="class")
  
  RF2Res <- c()
  
  RF2Res$Predictions <- as.data.frame(cbind(trainingData$number_stars,predicted))
  names(RF2Res$Predictions) <- c("observed", "predicted")
  RF2Res$Predictions$Difference <- RF2Res$Predictions$observed - RF2Res$Predictions$predicted
  RF2Res$summary <- summary(RF2Res$Predictions$Difference)
  RF2Res$RMSError <- sqrt(mean((RF2Res$Predictions$Difference)^2))
  RF2Res$ExactMatch <- nrow(subset(RF2Res$Predictions, RF2Res$Predictions$observed==RF2Res$Predictions$predicted))*100/nrow(RF2Res$Predictions)
  RF2Res$Times$Start=start
  RF2Res$Times$End=date()
  
  save(RF2Res, RF2fit, file = RF2path)
} else {
  load(RF2path) 
}

# rpart with only positive abd nagative comments used

if (!file.exists(rpart2path))
{  
  print("rpart2")
  start=date()
  
  rpart2fit <- rpart(number_stars ~ pos_com+neg_com, data=trainingData, method="class")
  
  
  predicted <- predict(rpartfit, newdata=trainingData[-number_stars_index], type="class")
  
  rpart2Res <- c()
  
  rpart2Res$Predictions <- as.data.frame(cbind(trainingData$number_stars,predicted))
  names(rpart2Res$Predictions) <- c("observed", "predicted")
  rpart2Res$Predictions$Difference <- rpart2Res$Predictions$observed - rpart2Res$Predictions$predicted
  rpart2Res$summary <- summary(rpart2Res$Predictions$Difference)
  rpart2Res$RMSError <- sqrt(mean((rpart2Res$Predictions$Difference)^2))
  rpart2Res$ExactMatch <- nrow(subset(rpart2Res$Predictions, rpart2Res$Predictions$observed==rpart2Res$Predictions$predicted))*100/nrow(rpartRes$Predictions)
  rpart2Res$Times$Start=start
  rpart2Res$Times$End=date()
  
  save(rpart2Res, rpart2fit, file = rpart2path)
} else {
  load(rpart2path)
}

## Ctree2

if (!file.exists(ctreepath))
{  
  print("ctree2")
  start=date()
  #training <-   data.frame(lapply(trainingData, factor))
  
  ctree2fit <- ctree(number_stars ~ pos_com+neg_com , data=trainingData)
  
  
  predicted <- predict(ctree2fit, newdata=trainingData[-number_stars_index])
  
  ctree2Res <- c()
  
  ctree2Res$Predictions <- as.data.frame(cbind(trainingData$number_stars,predicted))
  names(ctree2Res$Predictions) <- c("observed", "predicted")
  ctree2Res$Predictions$Difference <- ctree2Res$Predictions$observed - ctree2Res$Predictions$predicted
  ctree2Res$summary <- summary(ctree2Res$Predictions$Difference)
  ctree2Res$RMSError <- sqrt(mean((ctree2Res$Predictions$Difference)^2))
  ctree2Res$ExactMatch <- nrow(subset(ctree2Res$Predictions, ctree2Res$Predictions$observed==ctree2Res$Predictions$predicted))*100/nrow(ctree2Res$Predictions)
  ctree2Res$Times$Start=start
  ctree2Res$Times$End=date()
  
  save(ctree2Res, ctree2fit, file = ctree2path)
}



