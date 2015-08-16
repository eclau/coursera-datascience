#install.packages("data.table")
#install.packages("openxlsx")
#install.packages("XML")
library(data.table)
library(openxlsx)
library(XML)

## Question 1

readfile <- function(filename) {
  df <- read.csv(filename)
  df
}

# read csv, find properties worth $1m or more (inspect column 'VAL')
# Val value of 14 or more = $1m+
df <- readfile("ss06hid.csv")
typeof(df)
sub.df2 <- subset(sub.df, !(is.na(VAL)), select = c(VAL))
length(sub.df2[sub.df2$VAL >= 14, ])

## Question 3

# read *.xlsx, rows 18-23, columns 7-15 into R and assign result to a variable called dat
dat <- read.xlsx(xlsxFile = "DATA.gov_NGAP.xlsx", sheet = 1, startRow = 1, skipEmptyRows = FALSE, colNames = TRUE, rows = c(18:23), cols = 7:15)
dat
sum(dat$Zip*dat$Ext,na.rm=T) # Find the value of

## Question 4

# Read getdata-data-restaurants.xml, how many restaurants have zipcode 21231
require(XML)
xmlfile <- xmlTreeParse("getdata-data-restaurants.xml")
class(xmlfile)
# use the xmlRoot-function to access the top node
xmltop = xmlRoot(xmlfile)
print(xmltop)[1:4]
zip_code <- as.list(xml_data[["row"]][["row"]][["zipcode"]])

## ???


## Question 5

# using fread() command load ss06pid.csv into an R object
