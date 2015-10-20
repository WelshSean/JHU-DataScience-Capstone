# Q1

After untaring the the dataset, how many files are there (including the documentation pdfs)?
5
7
3
2

** 7

# Q2

The data files are in what format?
.RData
.xlsx
json
csv

** json

# Q3

How many lines of text are there in the reviews file (in orders of magnitude)?
One hundred thousand
One million
Ten million
Ten thousand

** One million


# Q4

Consider line 100 of the reviews file. “I’ve been going to the Grab n Eat for almost XXX years”
2
20
10
5

** 20

# Q5 

Question 5
What percentage of the reviews are five star reviews (rounded to the nearest percentage point)?
30%
37%
14%
10%


library(jsonlite)
setwd("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset")

set.seed(1974)

review <- stream_in(file('yelp_academic_dataset_review.json'))

nrow(subset(review, stars == 5))


** 37

# Q6

How many lines are there in the businesses file?
Around 1.5 million
Around 60 thousand
Around 15 million
Around 55 million

** 60 Thousnad

# Q7

Conditional on having an response for the attribute "Wi-Fi", how many businesses are reported for having free wi-fi (rounded to the nearest percentage point)?
2%
40%
1%
57%



library(jsonlite)
setwd("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset")

set.seed(1974)

business <- stream_in(file('yelp_academic_dataset_business.json'))
attr <- business$attributes
names(attr)[20] <- "WiFi"

nrow(subset(attr, WiFi == "free"))/nrow(subset(attr, WiFi != "NA")) *100


** 40%


# Q8

How many lines are in the tip file?
About 1.5 million
About 55 million
About 60 thousand
About 500 thousand

** 500 thousand

# Q9

In the tips file on the 1,000th line, fill in the blank: "Consistently terrible ______"
atmosphere
desserts
service
food

** service


# Q10

What is the name of the user with over 10,000 compliment votes of type "funny"?
Ira
Roger
Jeff
Brian


library(jsonlite)
setwd("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset")

set.seed(1974)

user <- stream_in(file('yelp_academic_dataset_user.json'))
userflat <- flatten(user)
subset(userflat, compliments.funny >10000)

** Brian


## Q11

Create a 2 by 2 cross tabulation table of when a user has more than 1 fans to if the user has more than 1 compliment of type "funny". Treat missing values as 0 (fans or votes of that type). Pass the 2 by 2 table to fisher.test in R. What is the P-value for the test of independence?
less than .001
around 0.01
around 0.20
around 0.05



library(jsonlite)
setwd("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset")

set.seed(1974)

user <- stream_in(file('yelp_academic_dataset_user.json'))
userflat <- flatten(user)

