#install.packages("data.table")
library(data.table)

readfile <- function(filename) {
  df <- read.csv(filename)
  df
}

pollutantmean <- function(directory, pollutant, id = 1:332) 
{
  filenames <- list.files(directory, pattern="*.csv", full.names=TRUE)
  dataframes <- lapply(filenames, readfile)
  binded <- rbindlist(dataframes)
  sub.binded <- binded[binded$ID %in% id,]
  pv <- sub.binded[[pollutant]]
  round(mean(pv[is.na(pv) == 0]), 3)
}