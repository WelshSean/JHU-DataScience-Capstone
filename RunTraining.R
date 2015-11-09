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

# K-Fold Validation
#numfolds=10
#observed <- c()
#predicted <- c()
#folds <- createFolds(y=trainingData[[1]]$stars, k=numfolds, list = TRUE, returnTrain = TRUE)
#for (i in 1:numfolds){
#  foldtrain <- trainingData[[1]][folds[[i]],]
#  foldtest <- trainingData[[1]][-folds[[i]],]
  ##last <- ncol(foldtest)
#  cartfit <- rpart(stars ~ . -business_id, data=foldtrain, method="class")
#  observed <- c(observed, foldtest$stars)
#  predicted <- c(predicted, predict(cartfit, foldtest, method="class"))
#}


cartModelFit <- rpart(stars ~ . -business_id, data = trainingData[[1]], method = "class")
#cartPredict <- predict(cartModelFit, newdata = trainingData[[1]], type = "class")
#cartCM <- confusionMatrix(cartPredict, trainingData[[1]]$stars)
