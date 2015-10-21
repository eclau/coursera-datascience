library(data.table)

## Source File
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
## Code Book
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Set working dir
setwd("/Users/elau/Documents/Development/Coursera/coursera-datascience/012-getdata/week1b")

# Read file
readFile <- function(fileName) {
  data <- read.table(fileName, sep = ",", header = TRUE)
  data
}

# Execute

myData <- readFile("getdata-data-ss06hid.csv")
typeof(myData)

# Q1: How many properties are worth $1,000,000 or more?
# VAL is the column that represents the property value
# VAL >= 14 means that the property is valued at $1M or more

myProperty <- subset(myData, !(is.na(VAL)) & VAL == 24, select = c(VAL))

# A1: No. of properties >= $1M are 53

nrow(myProperty)

# Q2: Use the dasta you loaded from Q1, consider the FES variable in the code book.
# A2: It violated the rule that tidy data has one observation per row

## Source File
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx

# Q3: Read rows 18-23 and columns 7 -15 into R and assign the result to a variable called 'dat'
#     What is the value of sum(dat$Zip * dat$Ext , na.rm = T)?

# A3:
dat <- read.xlsx(xlsxFile = "getdata-data-DATA.gov_NGAP.xlsx", sheet = 1, startRow = 1, skipEmptyRows = FALSE, colNames = TRUE, rows = c(18:23), cols = 7:15)
sum(dat$Zip * dat$Ext , na.rm = T) # 36,534,720

## Read the XML data on https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
## Contents
# <response>
#   <row>
#     <row _id="1" _uuid="93CACF6F-C8C2-4B87-95A8-8177806D5A6F" _position="1" _address="http://data.baltimorecity.gov/resource/k5ry-ef3g/1">
#     <name>410</name>
#     <zipcode>21206</zipcode>
#     <neighborhood>Frankford</neighborhood>
#     <councildistrict>2</councildistrict>
#     <policedistrict>NORTHEASTERN</policedistrict>
#     <location_1 human_address="{"address":"4509 BELAIR ROAD","city":"Baltimore","state":"MD","zip":""}" needs_recoding="true"/>
#     </row>
#     <row _id="2" _uuid="44F06325-01EF-4430-A292-1F7F0271D902" _position="2" _address="http://data.baltimorecity.gov/resource/k5ry-ef3g/2">
#     <name>1919</name>
#     <zipcode>21231</zipcode>
#     <neighborhood>Fells Point</neighborhood>
#     <councildistrict>1</councildistrict>
#     <policedistrict>SOUTHEASTERN</policedistrict>
#     <location_1 human_address="{"address":"1919 FLEET ST","city":"Baltimore","state":"MD","zip":""}" needs_recoding="true"/>
#     </row>

xmlFile <- "getdata-data-restaurants.xml"
if (!file.exists(xmlFile)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
  download.file(fileURL, destfile = xmlFile, method = "curl")
}

library(XML)
myRestaurant <- xmlTreeParse(xmlFile, useInternal = TRUE)

# Q4: How many restaurants have zipcode 21231?

rootNode <- xmlRoot(myRestaurant)
zipCode <- data.frame("zipCode" = xpathSApply(rootNode, "//zipcode", xmlValue))

# A4:
length(zipCode[zipCode$zipCode == 21231, ]) # 27

## Source File 
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

csvFile <- "getdata-data-ss06pid.csv"
if (!file.exists(csvFile)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
  download.file(fileURL, destfile = csvFile, method = "curl")
}

# Q5: Use the fread() command to load the data into an R object 'DT'
#     Which of the following is the fastest way to calculate the average value of the variable 'pwgtp15'?

DT <- fread(csvFile)

system.time(tapply(DT$pwgtp15, DT$SEX, mean))         # user 0.001 system 0.000 elapsed 0.002
system.time(sapply(split(DT$pwgtp15, DT$SEX), mean))  # user 0.001 system 0.000 elapsed 0.001
system.time(DT[, mean(pwgtp15), by = SEX])            # user 0.000 system 0.000 elapsed 0.001
system.time(expression)
system.time(mean(DT$pwgtp15, by = DT$SEX))            # user 0.002 system 0.000 elapsed 0.000
system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})         # user 0.027 system 0.001 elapsed 0.028

