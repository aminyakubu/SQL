##################################
# READING CSV FILES FROM THE WEB #
##################################

#Add the URL inside the quotes
url <- "https://data.chhs.ca.gov/dataset/3205b420-3f62-4a02-8d2e-9a9ed34c49f4/resource/6ef33c1b-9f54-49f2-a92e-51a1b78f0a06/download/wnv_human_cases.csv"

#Assign the csv data to a data frame
west_nile <- read.csv(url)

#Show the column names in the data frame
colnames(west_nile)

#Show the first few rows of the data frame
head(west_nile)

####################### SQL #######################

install.packages("sqldf")
library(sqldf)

##### To refer to variables with a period in the name, surround the variable name in [ ] #####

#QUESTION 1 - Which years had the fewest and most outbreaks across all of California?
sqldf("SELECT Year, COUNT([Positive.Cases]) AS total_num
      FROM west_nile
      GROUP BY Year
      ORDER BY total_num") 

### 2009 had the fewest outbreaks - 71. And 2014 had the most outbreaks. 

#QUESTION 2 - Report the total number of positive cases per county each year.  Display in alphabetical county order, and in year order.

sqldf("SELECT County, Year, SUM([Positive.Cases]) AS total_num
      FROM west_nile
      GROUP BY County, Year
      ORDER BY County, Year")

#QUESTION 3 - Give the county or counties with the most positive cases across all years (account for possible ties).  
#Show the number of cases with the resulting county or counties.

sqldf("SELECT County, SUM([Positive.Cases]) AS total_num
      FROM west_nile
      GROUP BY County
    HAVING total_num = (SELECT SUM([Positive.Cases]) AS total_num
      FROM west_nile
      GROUP BY County
      ORDER BY total_num DESC
      LIMIT 2)")

sqldf("SELECT County, SUM([Positive.Cases]) AS total_num
      FROM west_nile
      GROUP BY County
      WHERE total_num IN (SELECT SUM([Positive.Cases]) AS total_num
      FROM west_nile
      GROUP BY County
      ORDER BY total_num DESC
      LIMIT 1)")

sqldf("SELECT SUM([Positive.Cases]) AS total_num
      FROM west_nile
      GROUP BY County
      ORDER BY total_num DESC
      LIMIT 2")
###Los Angeles is the county with the most positive cases across all years

###################################################################
# PULLING JSON DATA FROM THE WEB USING HTTR AND JSONLITE PACKAGES #
###################################################################

install.packages("httr")
library(httr)

install.packages("jsonlite")  #This package will help convert JSON data to a data frame
library(jsonlite)


#Pull restaurant violations data
inspect <- GET("https://data.cityofnewyork.us/resource/9w7m-hzhe.json")
new <- content(inspect, "text")

#Create data frame from JSON data
inspect_df <- fromJSON(new) #NOTE: this will be limited to 1000 records

#Show variable names for new data frame
colnames(inspect_df)


####################### SQL #######################

install.packages("sqldf")
library(sqldf)

#QUESTION 4 - Based on this dataset, rank the boroughs in order of most to fewest violations
sqldf("SELECT boro, COUNT(violation_code) AS num_viol
      FROM inspect_df
      GROUP BY boro
      ORDER BY num_viol DESC")

### The boroughs in manhattan, brooklyn, queens, bronx and staten island

#QUESTION 5 - Which borough has the most A grades?  
sqldf("SELECT boro, COUNT(grade) AS grade_a_num
      FROM inspect_df
      WHERE grade = 'A'
      GROUP BY boro
      ORDER BY grade_a_num DESC
      LIMIT 1")

### Manhattan has the most A grade

#QUESTION 6 - Restrict this data only to ZIP code 10032 and use SQL to provide an insight about restaurant violations in the campus neighborhood.

  #Pull restaurant violations data from 10032
  wahi <- GET("https://data.cityofnewyork.us/resource/9w7m-hzhe.json", query = list(zipcode = 10032))
  new2 <- content(wahi, "text")
  
  #Create data frame from JSON data
  wahi_df <- fromJSON(new2) #NOTE: this will be limited to 1000 records
  
  #Show variable names for new data frame
  colnames(wahi_df)

  #### SELECTING THE WORST RESTAURANT
  
  sqldf("SELECT score, boro, dba, cuisine_description, street, building, violation_code, violation_description, inspection_date
        FROM wahi_df
        WHERE score = (
        SELECT MAX(CAST(score AS INTEGER)) AS worst
        FROM wahi_df)")
  
  #### Best restaurant
  sqldf("SELECT score, boro, dba, cuisine_description, street, building, violation_code, violation_description, inspection_date
        FROM wahi_df
        WHERE score = (
        SELECT MIN(CAST(score AS INTEGER)) AS best
        FROM wahi_df)")
  
