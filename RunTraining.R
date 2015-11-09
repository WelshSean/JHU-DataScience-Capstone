####### Main script for running training analysis

# Libraries
library(rpart)
library(rpart.plot)
library(caret)

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


cartModelFit <- rpart(stars ~ . -business_id, data = trainingData[[1]], method = "class")
cartPredict <- predict(cartModelFit, newdata = trainingData[[1]], type = "class")
cartCM <- confusionMatrix(cartPredict, trainingData[[1]]$stars)
