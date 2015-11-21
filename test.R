####### Main script for running Validation analysis

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

load(paste(PATH, "yelptest.rda", sep="/"))

testpath <- paste(PATH, "testdata.rda", sep="/")


# Load models

ctreepath <- paste(PATH, "ctreetraining.rda", sep="/")


# Paths to save test output to
ctreeTpath <- paste(PATH, "ctreetest.rda", sep="/")





if (file.exists(testpath)){
  print("Loading Test data from file") 
  load(testpath)
} else {
  print("Creating test data")
  source("./FeatureExtraction2.R")
  testData <- extractFeatures2(yelpreviews)
  save(testData, file=testpath)
}

testData <- testData[c("business_id", "number_stars", "pos_com", "neg_com", "review_length")]

number_stars_index <- match("number_stars", names(testData))
business_id_index <- match("business_id", names(testData))


load(ctreepath)





## Ctree

if (!file.exists(ctreeTpath))
{  
  print("ctree")
  start=date()
  
  predicted <- predict(ctreefit, newdata=testData[-number_stars_index])
  
  ctreeTRes <- c()
  
  ctreeTRes$Predictions <- as.data.frame(cbind(testData$number_stars,predicted))
  names(ctreeTRes$Predictions) <- c("observed", "predicted")
  ctreeTRes$Predictions$Difference <- ctreeTRes$Predictions$observed - ctreeTRes$Predictions$predicted
  ctreeTRes$summary <- summary(ctreeTRes$Predictions$Difference)
  ctreeTRes$RMSError <- sqrt(mean((ctreeTRes$Predictions$Difference)^2))
  ctreeTRes$ExactMatch <- nrow(subset(ctreeTRes$Predictions, ctreeTRes$Predictions$observed==ctreeTRes$Predictions$predicted))*100/nrow(ctreeTRes$Predictions)
  ctreeTRes$Times$Start=start
  ctreeTRes$Times$End=date()
  
  save(ctreeVRes, file = ctreeVpath)
}






