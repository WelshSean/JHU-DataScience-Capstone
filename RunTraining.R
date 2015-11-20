####### Main script for running training analysis

# Libraries
library(rpart)
library(rpart.plot)
library(caret)
library(kernlab)
library(e1071)
library(partykit)

# Setup
set.seed(1974)
setwd("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone")


# Load Training Data
#PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/1pct_samples"
PATH="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset"
load(paste(PATH, "yelptrain.rda", sep="/"))
ctreepath <- paste(PATH, "ctreetraining.rda", sep="/")
rpartpath <- paste(PATH, "rparttraining.rda", sep="/")
rpart2path <- paste(PATH, "rpart2training.rda", sep="/")
SVMpath <- paste(PATH, "SVMtraining.rda", sep="/")
trainpath <- paste(PATH, "trainingdata.rda", sep="/")
lmpath <- paste(PATH, "lmtraining.rda", sep="/")
NBpath <- paste(PATH, "NaiveBayestraining.rda", sep="/")

# includelist <- read.table("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/words.txt.tagged.processed", stringsAsFactors = FALSE)
# includelist <- as.list(includelist[[1]])
# includelist <- c(includelist, "business_id", "number_stars")

includelist <- c("amazing", "awesome", "bad", "best", "better", "bland", "delicious", "dirty", "disappointed", "disappointing", "dont", "dry","excellent","favorite", "friendly", "great", "horrible" , "mediocre", "overpriced", "perfect", "poor", "rude","sorry", "terrible", "wonderful", "number_stars", "business_id")

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
training <- training[match(includelist, names(training), nomatch=0)]
number_stars_index <- match("number_stars", names(training))
business_id_index <- match("business_id", names(training))

# Recursive Partitioning with default settings

if (!file.exists(rpartpath))
{  
  print("rpart")
  start=date()

  rpartfit <- rpart(number_stars ~ . -business_id, data=training, method="class")


  predicted <- predict(rpartfit, newdata=training[-number_stars_index], type="class")
 
  rpartRes <- c()
 
  rpartRes$Predictions <- as.data.frame(cbind(training$number_stars,predicted))
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

# Support Vector Machine

if (!file.exists(SVMpath))
{
  print("SVM")
  start=date()
  SVMfit <- ksvm(number_stars~. -business_id,data=training,kernel="rbfdot",kpar=list(sigma=0.05),C=5,cross=3, verbose=TRUE)
  
  predicted <- predict(SVMfit, newdata=training[-c(number_stars_index)])
  
  SVMRes <- c()
  
  SVMRes$Predictions <- as.data.frame(cbind(training$number_stars,predicted))
  names(SVMRes$Predictions) <- c("observed", "predicted")
  SVMRes$Predictions$Difference <- SVMRes$Predictions$observed - SVMRes$Predictions$predicted
  SVMRes$summary <- summary(SVMRes$Predictions$Difference)
  SVMRes$RMSError <- sqrt(mean((SVMRes$Predictions$Difference)^2))
  SVMRes$ExactMatch <- nrow(subset(SVMRes$Predictions, SVMRes$Predictions$observed==SVMRes$Predictions$predicted))*100/nrow(SVMRes$Predictions)
  SVMRes$Times$Start=start
  SVMRes$Times$End=date()
  
  save(SVMRes, SVMfit, file = SVMpath)
}

# Linear model

if (!file.exists(lmpath))
{
  print("lm")
  start=date()
  lmtraining <- training
  lmtraining$number_stars <- as.integer(as.character(training$number_stars))
  
  lmfit <- lm(number_stars ~ . -business_id, data = lmtraining)
  
  
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
  lmRes$Times$Start=start
  lmRes$Times$End=date()
  
  save(lmRes, lmfit, file = lmpath)
}

# Naive Bayes

if (!file.exists(NBpath))
{  
  print("Naive Bayes")
  start=date()
  training <-   data.frame(lapply(training, factor))
  
  NBfit <- naiveBayes(number_stars ~ . -business_id, data=training, method="class")
  
  
  predicted <- predict(NBfit, newdata=training[-number_stars_index], type="class")
  libra
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


## Prune rpart model

# if (exists("rpartRes") && !file.exists(rpart2path))
# {
#   optimalcp <- rpartfit$cptable[which.min(rpartfit$cptable[,"xerror"]),"CP"]
#   rpart2fit <- prune(rpartfit, cp=optimalcp )
#   
#   predicted <- predict(rpart2fit, newdata=training[-number_stars_index], type="class")
#   
#   rpart2Res <- c()
#   
#   rpart2Res$Predictions <- as.data.frame(cbind(training$number_stars,predicted))
#   names(rpart2Res$Predictions) <- c("observed", "predicted")
#   rpart2Res$Predictions$Difference <- rpart2Res$Predictions$observed - rpart2Res$Predictions$predicted
#   rpart2Res$summary <- summary(rpart2Res$Predictions$Difference)
#   rpart2Res$RMSError <- sqrt(mean((rpart2Res$Predictions$Difference)^2))
#   rpart2Res$ExactMatch <- nrow(subset(rpart2Res$Predictions, rpart2Res$Predictions$observed==rpart2Res$Predictions$predicted))*100/nrow(rpart2Res$Predictions)
# 
#   save(rpart2Res, rpart2fit, file = rpart2path)
#   
#   }

## Ctree

if (!file.exists(ctreepath))
{  
  print("ctree")
  start=date()
  training <-   data.frame(lapply(training, factor))
  
  ctreefit <- ctree(number_stars ~ . -business_id, data=training)
  
  
  predicted <- predict(ctreefit, newdata=training[-number_stars_index])
  
  ctreeRes <- c()
  
  ctreeRes$Predictions <- as.data.frame(cbind(training$number_stars,predicted))
  names(ctreeRes$Predictions) <- c("observed", "predicted")
  ctreeRes$Predictions$Difference <- ctreeRes$Predictions$observed - ctreeRes$Predictions$predicted
  ctreeRes$summary <- summary(ctreeRes$Predictions$Difference)
  ctreeRes$RMSError <- sqrt(mean((ctreeRes$Predictions$Difference)^2))
  ctreeRes$ExactMatch <- nrow(subset(ctreeRes$Predictions, ctreeRes$Predictions$observed==ctreeRes$Predictions$predicted))*100/nrow(ctreeRes$Predictions)
  ctreeRes$Times$Start=start
  ctreeRes$Times$End=date()
  
  save(ctreeRes, ctreefit, file = ctreepath)
}
