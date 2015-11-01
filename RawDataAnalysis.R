library(jsonlite)


## Here just reading in the data and generating some smaller samples to take a look at it.

setwd("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/1pct_samples")

set.seed(1974)

## The files are not valid JSON in their entirety. Each line of the file is a valid JSON doc.
## They can be read in using stream_in from the jsonlite package
## Lets pull a sample of 1000 rows from each one.

## FUll samples were hangning so used this one liner to create 1 percent sized samples
## perl -ne 'print if (rand() < .01)' yelp_academic_dataset_user.json > 1pct_samples/user.json
## this came from the forums

## Business - this summarises the data about the business

business <- stream_in(file('business.json'))

## checkin tracks check-ins - this is where the customers check in at the business via the mobile app
## some times the customers get a discount

checkin <- stream_in(file('checkin.json'))

## Review contain customer reviews (funnily enough!)

review <- stream_in(file('review.json'))


## tips are ways for people to leave information about the business without posting a full review

tip <- stream_in(file('tip.json'))

## User details

user <- stream_in(file('user.json'))




