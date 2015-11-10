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

trn <- trainingData[[1]] 
trn$number_stars <- as.numeric(as.character(trn$number_stars))

### lm cant handle number_stars as factor
lmFit <- lm(number_stars ~ . -business_id, data = trn)
lmPredict <- predict(lmFit, newdata = trn)
lmCM <- confusionMatrix(table(factor(lmPredict, levels=min(trn$number_stars):max(trn$number_stars)),factor(trn$number_stars, levels=min(trn$number_stars):max(trn$number_stars))))


### cart can handle nstars as factor
cartModelFit <- rpart(number_stars ~ . -business_id -number_stars, data = trn, method = "class")

cartPredict <- predict(cartModelFit, newdata = trn, type = "class")
cartCM <- confusionMatrix(cartPredict, trn$number_stars)

# rf doesnt like formula notation here and doesnt like business_id being included!

trn2 <- trn
trn2$business_id <- NULL
i <- match("number_stars", names(trn2))
rfFit <- randomForest(trn2[-i], trn2[[i]])
rfPredict <- predict(rfFit, newdata = trn2, type = "class")
rfCM <- confusionMatrix(rfPredict, trn2$number_stars)
