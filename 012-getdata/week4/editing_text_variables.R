# Merging data
if (!file.exists("./data")) {
  dir.create("./data")
}
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/cameras.csv", method = "curl")
cameraData <- read.csv("./data/cameras.csv")
names(cameraData)

tolower(names(cameraData))
splitNames <- strsplit(names(cameraData), "\\.")
splitNames[[5]]
splitNames[[6]]
mylist <- list(letters = c("A", "b", "c"), numbers = 1:3, matrix(1:25, ncol = 5))
mylist
# $letters
# [1] "A" "b" "c"
# 
# $numbers
# [1] 1 2 3
# 
# [[3]]
# [,1] [,2] [,3] [,4] [,5]
# [1,]    1    6   11   16   21
# [2,]    2    7   12   17   22
# [3,]    3    8   13   18   23
# [4,]    4    9   14   19   24
# [5,]    5   10   15   20   25
mylist[1]
# $letters
# [1] "A" "b" "c"
mylist$letters
# [1] "A" "b" "c"
mylist[[1]]
# [1] "A" "b" "c"

# Fixing character vectors - sapply()
# Applies a function to each element in a vector or list
# Important parameters: X, FUN
splitNames[[6][1]]
