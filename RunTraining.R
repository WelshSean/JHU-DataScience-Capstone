####### Main script for running training analysis

# Libraries
library(rpart)
library(rpart.plot)
library(caret)
library(randomForest)

# Setup
set.seed(1974)
setwd("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone")


# Load Training Data
PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/1pct_samples"
#PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset"
load(paste(PATH, "yelptrain.rda", sep="/"))

trainpath <- paste(PATH, "trainingdata.rda", sep="/")


if (file.exists(trainpath)){
  print("Loading Training data from file") 
  load(trainpath)
} else {
  print("Creating training data")
  source("./FeatureExtraction.R")
  trainingData <- extractFeatures(yelpreviews)
  save(trainingData, file=trainpath)
}

training <- trainingData[[1]] 
rm(trainingData)
number_stars_index <- match("number_stars", names(training))
business_id_index <- match("business_id", names(training))

# Recursive Partitioning with default settings

rpartfit <- rpart(number_stars ~ . -business_id, data=training, method="class")


predicted <- predict(rpartfit, newdata=training[-number_stars_index], type="class")
 
rpartRes <- c()
 
rpartRes$Predictions <- as.data.frame(cbind(training$number_stars,predicted))
names(rpartRes$Predictions) <- c("observed", "predicted")
rpartRes$Predictions$Difference <- rpartRes$Predictions$observed - rpartRes$Predictions$predicted
rpartRes$summary <- summary(rpartRes$Predictions$Difference)
rpartRes$RMSError <- sqrt(mean((rpartRes$Predictions$Difference)^2))
rpartRes$ExactMatch <- nrow(subset(rpartRes$Predictions, rpartRes$Predictions$observed==rpartRes$Predictions$predicted))*100/nrow(rpartRes$Predictions)
 
rpartpath <- paste(PATH, "rparttraining.rda", sep="/")
save(rpartRes, rpartfit, file = rpartpath)

# Random Forest with default values

RFfit <- randomForest(training[-c(number_stars_index, business_id_index)], training[[number_stars_index]], method="class")
 
predicted <- predict(RFfit, newdata=training[-c(number_stars_index)], type="class")
 
RFRes <- c()
 
RFRes$Predictions <- as.data.frame(cbind(training$number_stars,predicted))
names(RFRes$Predictions) <- c("observed", "predicted")
RFRes$Predictions$Difference <- RFRes$Predictions$observed - RFRes$Predictions$predicted
RFRes$summary <- summary(RFRes$Predictions$Difference)
RFRes$RMSError <- sqrt(mean((RFRes$Predictions$Difference)^2))
RFRes$ExactMatch <- nrow(subset(RFRes$Predictions, RFRes$Predictions$observed==RFRes$Predictions$predicted))*100/nrow(RFRes$Predictions)

RFpath <- paste(PATH, "RFtraining.rda", sep="/")
save(RFRes, RFfit, file = RFpath)

# Linear model
 
lmtraining <- training
lmtraining$number_stars <- as.integer(as.character(training$number_stars))
 
lmfit <- lm(number_stars ~ . , data = lmtraining)
 
 
predicted <- predict(lmfit, newdata=training[-c(number_stars_index)])
 
lmRes <- c()
 
lmRes$Predictions <- as.data.frame(cbind(lmtraining$number_stars,predicted))
names(lmRes$Predictions) <- c("observed", "predicted")
lmRes$Predictions$observed <- as.integer(lmRes$Predictions$observed)
lmRes$Predictions$predicted <- as.integer(lmRes$Predictions$predicted)
lmRes$Predictions$Difference <- lmRes$Predictions$observed - lmRes$Predictions$predicted
lmRes$summary <- summary(lmRes$Predictions$Difference)
lmRes$RMSError <- sqrt(mean((lmRes$Predictions$Difference)^2))
lmRes$ExactMatch <- nrow(subset(lmRes$Predictions, lmRes$Predictions$observed==lmRes$Predictions$predicted))*100/nrow(lmRes$Predictions)

lmpath <- paste(PATH, "lmtraining.rda", sep="/")
save(lmRes, lmfit, file = lmpath)
