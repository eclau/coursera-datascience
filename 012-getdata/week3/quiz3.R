library(httr)
library(dplyr)

setwd("~/Documents/Development/Coursera/coursera-datascience/012-getdata/week3")

## Q1.
## The American Community Survey distributes downloadable data about United States communities. 
## Download the 2006 microdata survey about housing for the state fo Idaho using download.file() from here:
## Source: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
## Code Book: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
## Create a logical vector that identifies the households on greanter than 10 acres who sold more than $10K worth of agriculture products
## Assign that logial vector to the variable agricultureLogical
## Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE, which(agricultureLogical). 
## What are the 3 values that result?

sourceURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
sourceCodeBookURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
if (!file.exists("./data")) {
  dir.create("./data")
}
if (!file.exists("./data/ss06hid.csv")) {
  download.file(sourceURL, destfile = "./data/ss06hid.csv", method = "curl")
}
if (!file.exists("./data/PUMSDataDict06.pdf")) {
  download.file(sourceCodeBookURL, destfile = "./data/PUMSDataDict06.pdf", method = "curl")
}
idahoHousing <- read.csv("./data/ss06hid.csv")
head(idahoHousing, 10)
names(idahoHousing)
# add new logical vector agricultureLogical
idahoHousing <- transform(idahoHousing, VAL = ACR == 3 & AGS == 6)
head(idahoHousing[, c("SERIALNO", "ACR", "AGS", "VAL")], 3)
agricultureLogical <- idahoHousing[, c("VAL")]
agricultureLogical

## A1.
which(agricultureLogical == TRUE, arr.ind = TRUE)[c(1:3)]
## [1] 125 238 262

## Q2.
## Usin the jpeg package read in the following picture of your instructor into R
## https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg 
## Using the parameter native=TRUE, What are the 30th and 80th quantiles of the resulting data? 
## (some Linux systems may produce an answer 638 different for the 30th quantile)
install.packages("jpeg")
library(jpeg)
if (!file.exists("./data/jeff.jpg")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", destfile = "./data/jeff.jpg", method = "curl")
}

jeff <- readJPEG("./data/jeff.jpg", native = TRUE)
str(jeff)
## 'nativeRaster' int [1:180, 1:180] -11494710 -11494710 -11494710 -11494710 -11494710 -11494710 -11494710 -11494710 -11494710 -11494710 ...
## - attr(*, "channels")= int 3
## A2.
quantileResult <- quantile(jeff, c(0.3, 0.8))
unname(quantileResult)
## [1] -15259150 -10575416

## Q3.
## Load the Gross Domestic Product data for the 190 ranked countries in this data set:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
## Load the educational data from this data set:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
## Match the data based on the country shortcode.
## How many of the IDs match?
## Sort the data frame in descending order by GDP rank (so United States is last)
## What is the 13th country in the resulting data frame?

## Original data sources: 
## http://data.worldbank.org/data-catalog/GDP-ranking-table 
## http://data.worldbank.org/data-catalog/ed-stats
if (!file.exists("./data/GDP.csv")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", destfile = "./data/GDP.csv", method = "curl")
}
if (!file.exists("./data/FEDSTATS_Country.csv")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", destfile = "./data/FEDSTATS_Country.csv", method = "curl")
}
gdp <- read.csv("./data/GDP.csv", header = FALSE, skip = 5, col.names = c("Country", "Ranking", "Ignore1", "Economy", "MillionsOfUSD", "Ignore2", "Ignore3", "Ignore4", "Ignore5", "Ignore6"), nrows = 190)
fedStatsCountry <- read.csv("./data/FEDSTATS_Country.csv")
head(gdp, n = 3)
tail(gdp, n = 3)
head(fedStatsCountry, n = 3)
## Check internals for columns used for joining
str(gdp$Country)
str(fedStatsCountry$CountryCode)
mergeData <- merge(gdp, fedStatsCountry, by.x = "Country", by.y = "CountryCode", all = TRUE)
## A3.
## The thirteenth ranked (by descending order) country by GDP is:
mergeData[with(mergeData, order(-Ranking)),][13,]
## Kitts and Nevis
## The no. of IDs matched are:
mappedCountry <- subset(mergeData[, c("Country", "Ranking")], !is.na(Ranking))
nrow(mappedCountry)
library(plyr)
## Get distinct count of mapped countries
mappedCountry <- ddply(mappedCountry, ~Country, summarise, distinctCount = length(unique(Country)))
##     Country distinctCount
## 1       ABW             1
## 2       AFG             1
## 3       AGO             1
sum(mappedCountry$distinctCount)
## [1] 190

## Q4.
## What is the average GDP ranking for the "High Income: OECD" and "High Income: nonOECD" group?
library(sqldf)
names(mergeData)

## A4.
sqldf("select avg(Ranking) from mergeData where [Income.Group] = 'High income: OECD'")
## avg(Ranking)
## 1     32.96667
sqldf("select avg(Ranking) from mergeData where [Income.Group] = 'High income: nonOECD'")
## avg(Ranking)
## 1     91.91304

## Q5.
## Cut the GDP ranking into 5 separate quantile groups. 
## Make a table versus Income.Group. 
## How many countries are Lower middle income but among the 38 nations with highest GDP?

## A5.
names(mergeData)
## Add new column called quantile
mergeDataByQuantile <- within(mergeData, quantile <- as.integer(cut(Ranking, quantile(Ranking, probs = 0:5/5, na.rm = TRUE), include.lowest = TRUE)))
## All countries with highest GDP quantile
highestGDP <- mergeDataByQuantile[!is.na(mergeDataByQuantile$quantile) & mergeDataByQuantile$quantile == 1, c("Country", "Ranking", "quantile")]
nrow(highestGDP)
## [1] 38
sqldf("select Country from mergeData inner join highestGDP using(Country) where [Income.Group] = 'Lower middle income'")
##   Country
## 1     CHN
## 2     EGY
## 3     IDN
## 4     IND
## 5     THA