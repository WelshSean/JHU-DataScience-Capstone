# JHU-DataScience-Capstone
October 2015 Capstone from the Johns Hopkins University Data Science Specialisation on Coursera

## Instructions 

### Process data files and create .rda file containing object

**Note:** The code assumes that you have extracted the Yelp data files to /Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/1pct_samples, you can override this by supplied the sourceDir=path argument to the function

1. Source the code, in R or RStudio run
		source RawDataAnalysis.R
2. Execute the code, in R or RStudio run
		process_data()

You should now have an .rda file in the same directory as your yelp dataset, this can be loaded using load
		load("/Users/Sean/Coursera_DataScience/JHU-DataScience-Capstone/yelp_dataset_challenge_academic_dataset/yelpdata.rda")
		
