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

# # Random Forest with default values
# 
# for (i in 1:numfolds){
#   print(paste("RF", i))
#   foldtrain <- trn[folds[[i]],]
#   foldtest <- trn[-folds[[i]],]
#   foldtrain$business_id <- NULL
#   foldtest$business_id <- NULL
#   ##last <- ncol(foldtest)
#   j <- match("number_stars", names(training))
#   print(j)
  RFfit <- randomForest(training[-c(number_stars_index, business_id_index)], training[[number_stars_index]], method="class")
#   observed <- c(observed, foldtest$number_stars)
#   k <- match("number_stars", names(foldtest))
  predicted <- predict(RFfit, newdata=training[-c(number_stars_index)], type="class")
# }
# 
RFRes <- c()
# 
RFRes$Predictions <- as.data.frame(cbind(training$number_stars,predicted))
names(RFRes$Predictions) <- c("observed", "predicted")
RFRes$Predictions$Difference <- RFRes$Predictions$observed - RFRes$Predictions$predicted
RFRes$summary <- summary(RFRes$Predictions$Difference)
RFRes$RMSError <- sqrt(mean((RFRes$Predictions$Difference)^2))
RFRes$ExactMatch <- nrow(subset(RFRes$Predictions, RFRes$Predictions$observed==RFRes$Predictions$predicted))*100/nrow(RFRes$Predictions)

RFpath <- paste(PATH, "RFtraining.rda", sep="/")
save(RFRes, RFfit, file = RFpath)

# # Linear model
# 
# for (i in 1:numfolds){
#   print(paste("lm", i))
#   foldtrain <- trn[folds[[i]],]
#   foldtest <- trn[-folds[[i]],]
#   foldtrain$business_id <- NULL
#   foldtest$business_id <- NULL
#   foldtrain$number_stars <- as.numeric(as.character(foldtrain$number_stars))
#   foldtest$number_stars <- as.numeric(as.character(foldtest$number_stars))
#   lmfit <- lm(number_stars ~ . , data = foldtrain)
#   observed <- c(observed, foldtest$number_stars)
#   k <- match("number_stars", names(foldtest))
#   predicted <- c(predicted, predict(lmfit, newdata=foldtest[-k]))
# }
# 
# lmRes <- c()
# 
# resultsLM <- as.data.frame(cbind(observed,predicted))
# names(resultsLM) <- c("observed", "predicted")
# resultsLM$Difference <- resultsLM$observed - resultsLM$predicted
# lmRes$summary <- summary(resultsLM$Difference)
# lmRes$RMSError <- sqrt(mean((resultsLM$observed - resultsLM$predicted)^2))
# lmRes$ExactMatch <- nrow(subset(resultsLM, resultsLM$observed==resultsLM$predicted))*100/nrow(resultsLM)
# 
# 
# 
