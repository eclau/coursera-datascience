if (!file.exists("./data")) {
  dir.create("./data")
}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "./data/survey.csv", method = "curl")
survey <- read.csv("./data/survey.csv")
summary(survey)

# Q1: Apply strsplit() to split all the names of the data frame on the characters 'wgtp'. 
#     What is the value of the 123 element of the resulting list?
splitNames <- strsplit(names(survey), "wgtp")
splitNames[[123]]

# Q2: Load data on GDP for the 190 ranked countries
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#     Remove the commas from the GDP numbers in millions of dollars and average them. What is the average? 
#     Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table
library(dplyr)
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileURL, destfile = "./data/gdp.csv", method = "curl")
library(data.table)
gdp <- fread("./data/gdp.csv", sep = ",", header = FALSE, skip = 5, nrow = 190, drop = c(3, 6))
head(gdp, n=10)
setnames(gdp, "V1", "country")
setnames(gdp, "V2", "rank")
setnames(gdp, "V4", "countryname")
setnames(gdp, "V5", "gdp")
head(gdp, n=10)
gdp <- select(gdp, country:gdp)
gdp2 <- mutate(gdp, gdpInt = as.integer(gsub(",", "", gdp)))
mean(gdp2$gdpInt)

## Q3: In the data set from Q2, what is the regex that would allow you you to count the number of countries whose name begins with "United"? 
##     Assume that the variable with the country names in it is named countryNames. How many countries begin with United?
table(grepl("^United", gdp2$countryname))
# Ans: 3


## Q4: Download the educational data set https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
##     Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, how many end in June? 

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileURL, destfile = "./data/educational.csv", method = "curl")
educational <- fread("./data/educational.csv", sep = ",", header = TRUE)
head(educational)
names(educational)
mergeData <- merge(gdp2, educational, by.x = "country", by.y = "CountryCode", all = TRUE)
head(mergeData)
mergeData[grepl("Fiscal year end: June 30", mergeData$`Special Notes`),]
# Ans: 13

## Q5: You can use the quantmod (http://www.quantmod.com/) package package to get historical stock prices for publicly traded companies on the NASDAQ and NYSE. 
##     Use the following code to download data on Amazon's stock price and get the times the data was sampled.
##     How many values were collected in 2012? How many values were collected on Mondays in 2012?
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN", auto.assign=FALSE)
library(dplyr)
sampleTimes <- index(amzn)
df <- as.data.frame(sampleTimes)
df2 <- mutate(df, year = format(sampleTimes, "%Y"))
yeargroup <- group_by(df2, year)
count(df2, year)
# 2012 occurs 250 times