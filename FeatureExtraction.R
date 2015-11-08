extractFeatures <- function(phase="train", sourceDir="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/1pct_samples")
{

library(tm)
library(caret)
library(rpart)
library(rpart.plot)
  
set.seed(1974)

fname=paste("yelp",phase,".rda", sep="")
varname=paste("yelp", phase, sep="")
fpath=paste(sourceDir, fname, sep="/")
print(fpath)

load(fpath)  
yelpreviews$corpus <- Corpus(VectorSource(yelpreviews$text))

# Tidy up words as much as possible

yelpreviews$corpus <- tm_map(yelpreviews$corpus, content_transformer(tolower)) 
yelpreviews$corpus <- tm_map(yelpreviews$corpus, content_transformer(removePunctuation)) 
yelpreviews$corpus <- tm_map(yelpreviews$corpus, content_transformer(removeNumbers))
yelpreviews$corpus <- tm_map(yelpreviews$corpus, content_transformer(stripWhitespace))
myStopwords <- stopwords("english")
myStopwords <- c(myStopwords, "they", "but", "and", "for", "get", "just")
yelpreviews$corpus <- tm_map(yelpreviews$corpus, removeWords, myStopwords)
yelpreviews$corpus <- tm_map(yelpreviews$corpus, content_transformer(PlainTextDocument))
  
# Convert Coprora to Term Document Matrix

tdm <- DocumentTermMatrix((yelpreviews$corpus))

# Lets find only words that occur in more than 1% of reviews

tdm <- removeSparseTerms(tdm, 0.99)

tdmDF <- as.data.frame(as.matrix(tdm))
tdmDF$stars <- as.factor(yelpreviews$stars)
tdmDF$business_id <- as.factor(yelpreviews$business_id)

return(tdmDF)

}