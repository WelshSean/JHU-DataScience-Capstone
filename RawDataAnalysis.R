processDat <- function(sourceDir="/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/1pct_samples")
{
  
library(jsonlite)
library(dplyr)
library(caret)
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

yelpdata <- inner_join(review, business)

# Add a column detailing country

yelpdata <- mutate(yelpdata, country= derivedFactor(
  "DE" = state %in% c("NW", "RP", "BW"),
  "UK" = state %in% c("EDH", "MLN", "FIF", "ELN", "XGL", "KHL"),
  "CA" = state %in% c("QC", "ON"),
  .method = "first",
  .default = "US"
)
)

## Now save data into a .rda file

fname <- paste(sourceDir, "yelpdata.rda", sep="/")

save(yelpdata, file=fname )


## Generate training, test and validation datasets in 60/20/20 ratio

set.seed(1974)
trainIndex <- createDataPartition(yelpdata$stars, p = .6,
                                  list = FALSE,
                                  times = 1)
yelptrain <- yelpdata[trainIndex,]
remainder <- yelpdata[-trainIndex,]

validationIndex <- createDataPartition(remainder$stars, p = .5,
                                  list = FALSE,
                                  times = 1)

yelpvalidation <- remainder[validationIndex,]
yelptest <- remainder[-validationIndex,]


fname <- paste(sourceDir, "yelptrain.rda", sep="/")
save(yelptrain, file=fname )

fname <- paste(sourceDir, "yelpvalidation.rda", sep="/")
save(yelpvalidation, file=fname )

fname <- paste(sourceDir, "yelptest.rda", sep="/")
save(yelptest, file=fname )


}





