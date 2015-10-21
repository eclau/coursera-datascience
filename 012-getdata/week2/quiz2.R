#install.packages(c("httr", "httpuv", "jsonlite")
library(httr)
library(httpuv)
library(jsonlite)

## Tutorial https://datatweet.wordpress.com/2014/05/14/reading-data-from-github-api-using-r/
## Register https://api.github.com/users/jtleek/repos on https://github.com/settings/applications
## Example code: https://github.com/hadley/httr/blob/master/demo/oauth2-github.r

## Application Name: eclau_week2
## Homepage URL: https://api.github.com/users/jtleek/repos
## Authorization callback URL: http://localhost:1410
## ClientId: 95fe0ce9a2605c7f2a5e
## ClientSecret: 7644cff7a0b67c9c86c07cdbf8b8ec15c0a6d87f

## 1. Find OAuth settings for github
oauth_endpoints("github")

## 2. To make your own application, register at at
##    https://github.com/settings/applications. Use https://api.github.com/repos/jtleek/datasharing for the homepage URL
##    and http://localhost:1410 as the callback url
##
##    Replace your key and secret below.
myAPI <- oauth_app("datasharing", key="00a70ae6f507e74b3eb7", secret="415831281f52fdba9e2be343cd820bb5673da3be")

## 3. Get OAuth credentials
githubToken <- oauth2.0_token(oauth_endpoints("github"), myAPI)

## 4. Use API
myRequest <- GET("https://api.github.com/repos/jtleek/datasharing", config(token = githubToken))
myJSON <- content(myRequest)
myJSONParsed <- jsonlite::fromJSON((toJSON(myJSON)))

## Q1: What time was it created? 
myJSONParsed$created_at
stop_for_status(myRequest)

## Q2: The sqldf package allows for execution of SQL commands on R data frames. 
##     We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL. 
##     Download the American Community Survey data and load it into an R object called 'acs'
##     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

#install.packages("sqldf")
#install.packages("data.table")
library(data.table)
library(sqldf)
csvFile <- "ss06pid.csv"
acs <- fread(csvFile)

## Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?
sqldf("select pwgtp1 from acs where AGEP < 50")

## Q3. Using the same data frame you created in the previous problem, what is the equivalent function to unique(acs$AGEP)
sqldf("select distinct AGEP from acs")

## Q4. How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page: http://biostat.jhsph.edu/~jleek/contact.html 
con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con)
close(con)
lapply(c(htmlCode[10], htmlCode[20], htmlCode[30], htmlCode[100]), nchar) 

# NB: readLine() returns a vector of characters

## Q5. Read this data set into R and report the sum of the numbers in the fourth of the nine columns. 
##     https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
##     (Hint this is a fixed width file format)

## Using this method http://stackoverflow.com/questions/24715894/faster-way-to-read-fixed-width-files-in-r

install.packages("LaF")
library(LaF)
columnWidths <- c(1, 14, 4, 9, 4, 9, 4, 9, 4, 4)
columnNames <- c("Ignore", "Week", "SST1+2", "SSTA1+2", "SST3", "SSTA3", "SST34", "SSTA34", "SST4", "SSTA4")
columnTypes <- c("string", "string", "double", "double", "double", "double", "double", "double", "double", "double")
#myFixedWidth <- laf_open_fwf("getdata-wksst8110.for", column_widths = columnWidths, column_types = columnTypes, column_names = columnNames, trim = TRUE)
DF <- read.fwf("getdata-wksst8110.for", widths=columnWidths, skip=4, col.names = columnNames)
sum(DF[,5])