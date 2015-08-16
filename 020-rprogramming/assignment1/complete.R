#install.packages("data.table")
library(data.table)

readfile <- function(filename) {
  df <- read.csv(filename)
  df
}

complete <- function(directory, id = 1:332)
{
  filenames <- list.files(directory, pattern="*.csv", full.names=TRUE)
  dataframes <- lapply(filenames, readfile)
  binded <- rbindlist(dataframes)
  sub.binded <- complete.cases(binded$sulfate, binded$nitrate)
  nobcount <- as.data.frame(table(binded$ID[sub.binded]))
  ans <- nobcount
  colnames(ans) <- c("id", "nobs")
  ans <- ans[match(id, ans$id),]
  rownames(ans) <- seq(length=nrow(ans))
  ans
}