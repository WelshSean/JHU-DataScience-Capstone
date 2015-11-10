extractFeatures <- function(yelpDF)
{

# Input - Dataframe containing Yelp data as created by RawDataAnalysis.R
  
# Output
#          List Element 1  Dataframe containing bag of words, star ratings and business IDs
#          List Element 2 Document Term Matrix
  
library(tm)

yelpreviews$corpus <- Corpus(VectorSource(yelpDF$text))

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
tdmDF$number_stars <- as.factor(yelpreviews$stars)
tdmDF$business_id <- as.factor(yelpreviews$business_id)

retlist <- list()
retlist[[1]] <- tdmDF
retlist[[2]] <- tdm
return(retlist)

}