#install.packages("data.table")
source("complete.R")
library(data.table)

readfile <- function(filename) {
  df <- read.csv(filename)
  df
}

readAllFile <- function(directory) {
  filenames <- list.files(directory, pattern="*.csv", full.names=TRUE)
  dataframes <- lapply(filenames, readfile)
  binded <- rbindlist(dataframes)
  sub.binded <- complete.cases(binded$sulfate, binded$nitrate)
  binded[sub.binded,]
}

corr <- function(directory, threshold = 0)
{
   allNobs <- complete("specdata", 1:332)
   threshold <- allNobs[allNobs$nobs >= threshold,]
   ids <- threshold[is.na(threshold$id) == 0, "id"]
   binded <- readAllFile(directory)
   vcor <- vector(mode="numeric", length=0)
   for (id in ids) {
     sub.binded <- binded[binded$ID %in% id,]
     vcor <- c(vcor, round(cor(sub.binded$sulfate, sub.binded$nitrate), 5))
   }
   vcor
}