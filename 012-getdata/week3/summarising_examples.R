## Summarising examples

setwd("~/Documents/Development/Coursera/coursera-datascience/012-getdata/week3")

if (!file.exists("./data")) {
  dir.create("./data")
}

## Downlaod raw
fileURL <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile="./data/restaurants.csv", method="curl")
restData <- read.csv("./data/restaurants.csv")

## Peek
head(restData, n=3)
tail(restData, n=3)

# Summarise
summary(restData)
str(restData)
quantile(restData$councilDistrict, na.rm=TRUE)
quantile(restData$councilDistrict, probs=c(0.5, 0.75, 0.9))

# Make table
table(restData$zipCode, useNA = "ifany")

# Pivot
table(restData$zipCode, restData$councilDistrict)

# Check for missing values
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode > 0)

# Row and column sums
colSums(is.na(restData))
all(colSums(is.na(restData)) == 0)

# Values with specific characteristics
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212", "21213"))
restData[restData$zipCode %in% c("21212", "21213"), ]

# Cross tabs
data("UCBAdmissions")
DF = as.data.frame((UCBAdmissions))
summary(DF)
xt <- xtabs(Freq ~ Gender + Admit, data=DF)
xt

# Flat tables
warpbreaks$replicate <- rep(1:9, len = 54)
xt <- xtabs(breaks ~ ., data=warpbreaks)
ftable(xt)

# Size of a dataset
fakeData <- rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData), units="Mb")
