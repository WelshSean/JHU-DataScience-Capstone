processDat <- function(sourceDir="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/1pct_samples")
{
  
library(jsonlite)
library(dplyr)
setwd(sourceDir)
set.seed(1974)

## The files are not valid JSON in their entirety. Each line of the file is a valid JSON doc.
## They can be read in using stream_in from the jsonlite package

## FUll samples were hanging so used this one liner to create 1 percent sized samples
## perl -ne 'print if (rand() < .01)' yelp_academic_dataset_user.json > 1pct_samples/user.json
## this came from the forums

## Business - this summarises the data about the business

business <- stream_in(file('yelp_academic_dataset_business.json'))

business[c("hours", "open", "attributes", "type", "review_count", "neighborhoods", "stars")] <- list(NULL) # Remove unwanted columns

## Review contain customer reviews (funnily enough!)

review <- stream_in(file('yelp_academic_dataset_review.json'))

review[c("type", "review_id", "votes")] <- list(NULL) # Remove unwanted columns

## Now join datasets together

joined <- inner_join(review, business)

## Now save data into a .rda file

fname <- paste(sourceDir, "yelpdata.rda", sep="/")

save(joined, file=fname )

}





