####### Main script for running training analysis

# Libraries
library(rpart)
library(randomForest)
library(rpart.plot)
library(caret)
library(kernlab)
library(e1071)
library(partykit)

# Setup
set.seed(1974)
setwd("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone")


# Load Training Data
PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/1pct_samples"
#PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset"
load(paste(PATH, "yelptrain.rda", sep="/"))
trainpath <- paste(PATH, "trainingdata.rda", sep="/")
ctreepath <- paste(PATH, "ctreetraining.rda", sep="/")
rpartpath <- paste(PATH, "rparttraining.rda", sep="/")
RFpath <- paste(PATH, "RFtraining.rda", sep="/")
SVMpath <- paste(PATH, "SVMtraining.rda", sep="/")
trainpath <- paste(PATH, "trainingdata.rda", sep="/")
lmpath <- paste(PATH, "lmtraining.rda", sep="/")

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
  
  rpartfit <- rpart(number_stars ~ . -business_id, data=trainingData, method="class")
  
  
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
