library(data.table)

rankhospital <- function(state = "", outcome = "", num) {
  hospitalOutcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  # statics
  expectedOutcome = c("heart attack", "heart failure", "pneumonia")
  expectedOutcomeColIndex = c(11, 17, 23)
  expectedOutcomeDf = data.frame(expectedOutcome, expectedOutcomeColIndex)
  
  # validate params
  if (!state %in% hospitalOutcome[, 7]) {
    stop("invalid state")
  }
  if (!outcome %in% expectedOutcome) {
    stop("invalid outcome")
  }
  else {
    colIndex = expectedOutcomeDf[expectedOutcomeDf$expectedOutcome %in% outcome,][,2]
  }
  # setup data frame
  sub.hospitalOutcome <- NULL
  # pick the associated outcome column
  sub.hospitalOutcome <- subset(hospitalOutcome, hospitalOutcome$State %in% state, select = c(Hospital.Name, colIndex))
  colnames(sub.hospitalOutcome) <- c("Name", "Mortality.Rate")
  sub.hospitalOutcome <- sub.hospitalOutcome[!(sub.hospitalOutcome$Mortality.Rate %in% "Not Available"), ]
  # change the mortality rate to numeric
  sub.hospitalOutcome[, 2] <- as.numeric(sub.hospitalOutcome[, 2])
  # sort the columns
  sub.hospitalOutcome <- sub.hospitalOutcome[with(sub.hospitalOutcome, order(Mortality.Rate, Name)), ]
  # add rank
  sub.hospitalOutcomeDT <- as.data.table(sub.hospitalOutcome)
  sub.hospitalOutcomeDT <- sub.hospitalOutcomeDT[, Rank:=rank(Mortality.Rate, na.last = TRUE, ties.method = "first")]
  # check param 'num'
  maxRank <- max(sub.hospitalOutcomeDT$Rank, na.rm = TRUE)
  if (num == "best") {
    head(sub.hospitalOutcomeDT[, sub.hospitalOutcomeDT$Name], 1)
  }
  else if (num == "worst") {
    worst <- head(sub.hospitalOutcomeDT[sub.hospitalOutcomeDT$Rank %in% maxRank, ], 1)
    worst[, worst$Name]
  }
  else if (num <= maxRank) {
    worst <- head(sub.hospitalOutcomeDT[sub.hospitalOutcomeDT$Rank %in% num, ], 1)
    worst[, worst$Name]
  }
  else {
    NA
  }
}