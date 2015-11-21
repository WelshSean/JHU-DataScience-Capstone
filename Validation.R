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

load(paste(PATH, "yelpvalidation.rda", sep="/"))

validationpath <- paste(PATH, "validationdata.rda", sep="/")


# Load models

ctreepath <- paste(PATH, "ctreetraining.rda", sep="/")
RFpath <- paste(PATH, "RFtraining.rda", sep="/")
NBpath <- paste(PATH, "NaiveBayestraining.rda", sep="/")

# Paths to save validation output to
ctreeVpath <- paste(PATH, "ctreeval.rda", sep="/")
RFVpath <- paste(PATH, "RFval.rda", sep="/")
NBVpath <- paste(PATH, "NaiveBayesval.rda", sep="/")




if (file.exists(validationpath)){
  print("Loading Validation data from file") 
  load(validationpath)
} else {
  print("Creating Validation data")
  source("./FeatureExtraction2.R")
  validationData <- extractFeatures2(yelpreviews)
  save(validationData, file=validationpath)
}

validationData <- validationData[c("business_id", "number_stars", "pos_com", "neg_com", "review_length")]

number_stars_index <- match("number_stars", names(validationData))
business_id_index <- match("business_id", names(validationData))


load(ctreepath)
load(RFpath)
load(NBpath)


# Random Forest 

if (!file.exists(RFVpath))
{  
  print("Random Forest")
  start=date()
  
  
  
  predicted <- predict(RFfit, newdata=validationData[-number_stars_index], type="class")
  
  RFVRes <- c()
  
  RFVRes$Predictions <- as.data.frame(cbind(validationData$number_stars,predicted))
  names(RFVRes$Predictions) <- c("observed", "predicted")
  RFVRes$Predictions$Difference <- RFVRes$Predictions$observed - RFVRes$Predictions$predicted
  RFVRes$summary <- summary(RFVRes$Predictions$Difference)
  RFVRes$RMSError <- sqrt(mean((RFVRes$Predictions$Difference)^2))
  RFVRes$ExactMatch <- nrow(subset(RFVRes$Predictions, RFVRes$Predictions$observed==RFVRes$Predictions$predicted))*100/nrow(RFVRes$Predictions)
  RFVRes$Times$Start=start
  RFVRes$Times$End=date()
  
save(RFVRes,  file = RFVpath)
} else {
  load(RFVpath) 
}

## Ctree

if (!file.exists(ctreeVpath))
{  
  print("ctree")
  start=date()
  
  predicted <- predict(ctreefit, newdata=validationData[-number_stars_index])
  
  ctreeVRes <- c()
  
  ctreeVRes$Predictions <- as.data.frame(cbind(validationData$number_stars,predicted))
  names(ctreeVRes$Predictions) <- c("observed", "predicted")
  ctreeVRes$Predictions$Difference <- ctreeVRes$Predictions$observed - ctreeVRes$Predictions$predicted
  ctreeVRes$summary <- summary(ctreeVRes$Predictions$Difference)
  ctreeVRes$RMSError <- sqrt(mean((ctreeVRes$Predictions$Difference)^2))
  ctreeVRes$ExactMatch <- nrow(subset(ctreeVRes$Predictions, ctreeVRes$Predictions$observed==ctreeVRes$Predictions$predicted))*100/nrow(ctreeVRes$Predictions)
  ctreeVRes$Times$Start=start
  ctreeVRes$Times$End=date()
  
  save(ctreeVRes, file = ctreeVpath)
}

# Naive Bayes

if (!file.exists(NBVpath))
{  
  print("Naive Bayes")
  start=date()
  validation <-   validationData
  
  
  predicted <- predict(NBfit, newdata=validation[-number_stars_index], type="class")
  NBVRes <- c()
  
  NBVRes$Predictions <- as.data.frame(cbind(validation$number_stars,predicted))
  names(NBVRes$Predictions) <- c("observed", "predicted")
  NBVRes$Predictions$Difference <- NBVRes$Predictions$observed - NBVRes$Predictions$predicted
  NBVRes$summary <- summary(NBVRes$Predictions$Difference)
  NBVRes$RMSError <- sqrt(mean((NBVRes$Predictions$Difference)^2))
  NBVRes$ExactMatch <- nrow(subset(NBVRes$Predictions, NBVRes$Predictions$observed==NBVRes$Predictions$predicted))*100/nrow(NBVRes$Predictions)
  NBVRes$Times$Start=start
  NBVRes$Times$End=date()
  
  save(NBVRes, file = NBVpath)
}




