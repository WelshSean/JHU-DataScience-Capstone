extractFeatures2 <- function(yelpDF)
{

# Input - Dataframe containing Yelp data as created by RawDataAnalysis.R
  
# Output
#          List Element 1  Dataframe containing bag of words, star ratings and business IDs
#          List Element 2 Document Term Matrix
  
library(tm)

dataDir <- "/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone"

# Following https://github.com/jeffreybreen/twitter-sentiment-analysis-tutorial-201107 for the lists
  
hu.liu.pos <- scan(file.path(dataDir,  'positive-words.txt'), what='character', comment.char=';')
hu.liu.neg <- scan(file.path(dataDir,  'negative-words.txt'), what='character', comment.char=';')
  
# add a few twitter and industry favorites
pos.words <- c(hu.liu.pos, 'upgrade')
neg.words <- c(hu.liu.neg, 'wtf', 'wait', 'waiting', 'epicfail', 'mechanical')
  

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
tdmDF$pos_com <- numbmatch(tdmDF, hu.liu.pos)
tdmDF$neg_com <- numbmatch(tdmDF, hu.liu.neg)
number_stars_index <- match("number_stars", names(tdmDF))
business_id_index <- match("business_id", names(tdmDF))
tempDF <- tdmDF[,-c(number_stars_index, business_id_index)] 
tdmDF$review_length <- numbentries(tempDF)
tdmDF$pos_com <- numbmatch(tdmDF, hu.liu.pos)
tdmDF$neg_com <- numbmatch(tdmDF, hu.liu.neg)


return(tdmDF)

}

numbmatch <- function(df, checkmatchinline)
{
  require(dplyr)
  matchindices <- match(checkmatchinline, names(df), nomatch=0)
  matchfreq <- df[c(matchindices)]
  ans <- matchfreq %>%
    mutate(sumrow=Reduce("+",.))
  ans$sumrow
}

numbentries <- function(df)
{
  require(dplyr)
  ans <- df %>%
    mutate(sumrow=Reduce("+",.))
  ans$sumrow
}


