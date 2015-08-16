library(data.table)

rankall <- function(outcome = "", num = "best") {
  hospitalOutcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  
  # statics
  expectedOutcome = c("heart attack", "heart failure", "pneumonia")
  expectedOutcomeColIndex = c(11, 17, 23)
  expectedOutcomeDf = data.frame(expectedOutcome, expectedOutcomeColIndex)
  
  # validate params
  colIndex = expectedOutcomeDf[expectedOutcomeDf$expectedOutcome %in% outcome,][,2]

  # setup data frame
   sub.hospitalOutcome <- NULL
  # pick the associated outcome column, get unique states
  sub.hospitalOutcome <- hospitalOutcome[, c(2, 7, colIndex)]
  colnames(sub.hospitalOutcome) <- c("hospital", "state", "mortality.rate")
  unique.state <- unique(sub.hospitalOutcome$state)
  sub.hospitalOutcome <- sub.hospitalOutcome[!(sub.hospitalOutcome$mortality.rate %in% "Not Available"), ]
  # change the mortality rate to numeric
  sub.hospitalOutcome[, 3] <- as.numeric(sub.hospitalOutcome[, 3])
  # sort the columns
  sub.hospitalOutcome <- sub.hospitalOutcome[with(sub.hospitalOutcome, order(state, mortality.rate, hospital)), ]
  # add rank
  sub.hospitalOutcomeDT <- as.data.table(sub.hospitalOutcome)
  sub.hospitalOutcomeDT <- sub.hospitalOutcomeDT[, Rank:=rank(mortality.rate, na.last = TRUE, ties.method = "first"), by=state]
  # convert to DF, create an empty result DF
  sub.hospitalOutcomeDF <- as.data.frame(sub.hospitalOutcomeDT)
  resultDF <- sub.hospitalOutcomeDF[0, ]
  # loop each unique state, test to see if state returns data, if not, create NA case for that state
  for (this.state in unique.state) {
    if (num == "best") {
      tempDF <- sub.hospitalOutcomeDF[sub.hospitalOutcomeDF$state %in% this.state & sub.hospitalOutcomeDF$Rank == 1, c('hospital', 'state', 'mortality.rate', 'Rank')]
    }
    else if (num == "worst") {
      tempDF <- tail(sub.hospitalOutcomeDF[sub.hospitalOutcomeDF$state %in% this.state, c('hospital', 'state', 'mortality.rate', 'Rank')], 1)
    }
    else {
      tempDF <- sub.hospitalOutcomeDF[sub.hospitalOutcomeDF$state %in% this.state & sub.hospitalOutcomeDF$Rank == num, c('hospital', 'state', 'mortality.rate', 'Rank')] 
    }
    # check for empty DFs
    if (NROW(tempDF) == 0) {
      tempDF <- data.frame(c(NA), c(this.state), -1, -1)
      colnames(tempDF) <- c("hospital", "state", "mortality.rate", "Rank")
    }
    resultDF <- rbind(resultDF, tempDF)
  }
  rownames(resultDF) <- resultDF[, c("state")]
  resultDF[with(resultDF, order(state)), c("hospital", "state")]
}