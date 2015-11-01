## Creating variables examples

setwd("~/Documents/Development/Coursera/coursera-datascience/012-getdata/week3")

if (!file.exists("./data")) {
  dir.create("./data")
}

## Downlaod raw
fileURL <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile="./data/restaurants.csv", method="curl")
restData <- read.csv("./data/restaurants.csv")

## Creating sequences
## Somes you need an index for your data set
s1 <- seq(1, 10, by=2)
s1
s2 <- seq(1, 10, length=3)
s2
x <- c(1, 3, 8, 25, 100)
seq(along = x)

## Subsetting variables
restData$nearMe <- restData$neighborhood %in% c("Rolank Park", "Homeland")
table(restData$nearMe)

## Creating binary variables
restData$zipWrong <- ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode < 0)

## Creating categorical variables
restData$zipGroups <- cut(restData$zipCode, breaks=quantile(restData$zipCode))
table(restData$zipGroups)
table(restData$zipGroups, restData$zipCode)

## Easier cutting
install.packages("Hmisc")
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode, g=4)
table(restData$zipGroups)

## Creating factor variables
restData$zcf <- factor(restData$zipCode)
table(restData$zcf)
restData$zcf[1:10]
class(restData$zcf)
levels(restData$zcf)

# Levels of factor variables
yesno <- sample(c("yes", "no"), size=10, replace=TRUE)
yesnofac <- factor(yesno, levels=c("yes", "no"))
relevel(yesnofac, ref="yes")
as.numeric(yesnofac)

# Using the mutate function
library(Hmisc)
library(plyr)
restData2 <- mutate(restData, zipGroups=cut2(zipCode, g=4))
table(restData2$zipGroups)

# Common Transforms
# abs(x)
# sqrt(x)
# ceiling(x)
# floor(x)
# round(x, digits=n)
# signif(x, digits=n)
# cos(x), sin(x)
# log(x)
# log2(x), log10(x)
# exp(x)