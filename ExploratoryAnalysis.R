load("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/yelpdata.rda")

colSums(is.na(joined))

unique(joined$stars)

# Useful!!! https://www.yelp.com/developers/documentation/v2/all_category_list

z <- data.frame(table(unlist(head(joined$categories,n=1000000))))    # Count categories
topCats <- head(z[order(z$Freq, decreasing=T), ], n = 20)               # List cats in order
