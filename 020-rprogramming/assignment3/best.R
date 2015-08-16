library(data.table)

cacheOutcome <- function() {
  outcome <- NULL
  setOutcome <- function() {
    outcome <<- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  }
  getOutcome <- function() {
    outcome
  }
  list(setOutcome = setOutcome, getOutcome = getOutcome)
}

best <- function(state = "", outcome = "") {
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
   # sort the columns, get the top row, find the hospital name
   head(sub.hospitalOutcome[with(sub.hospitalOutcome, order(Mortality.Rate, Name)), ], 1)[, 1]
}