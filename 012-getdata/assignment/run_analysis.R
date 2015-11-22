library(dplyr)
library(plyr)

featureLabel <- read.table("./UCI HAR Dataset/features.txt", sep = "", header = FALSE, col.names = c("featureId", "feature"))
activityLabel <- read.table("./UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE, col.names = c("activityId", "activity"))

## Prep test data
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE, col.names = "subject")
activityTest <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE, col.names = "activityId")
activityTest <- merge(activityLabel, activityTest, by.x = "activityId", by.y = "activityId", all = TRUE)
activityTest <- activityTest['activity']
dataTest <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE, col.names = featureLabel[,2])
## Subset test data (mean and std only)
sub.dataTest <- dataTest[,grepl("\\.mean\\.\\.|\\.std\\.\\.", colnames(dataTest))]
## Clean column names
colnames(sub.dataTest) <- gsub("\\.\\.", "", colnames(sub.dataTest))
## Merge test data
testDF <- cbind(subjectTest, activityTest, sub.dataTest)

## Prep train data
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE, col.names = "subject")
activityTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE, col.names = "activityId")
activityTrain <- merge(activityLabel, activityTrain, by.x = "activityId", by.y = "activityId", all = TRUE)
activityTrain <- activityTrain['activity']
dataTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE, col.names = featureLabel[,2])
## Subset train data (mean and std only)
sub.dataTrain <- dataTrain[,grepl("\\.mean\\.\\.|\\.std\\.\\.", colnames(dataTrain))]
## Clean column names
colnames(sub.dataTrain) <- gsub("\\.\\.", "", colnames(sub.dataTrain))
## Merge train data
trainDF <- cbind(subjectTrain, activityTrain, sub.dataTrain)

## Bind test and train
bindedDF <- rbind(testDF, trainDF)

## Summarise bindedDF to gvie the average of each variable for each activity and each subject
bySubjectActivity <- ddply(bindedDF, c("subject", "activity"), numcolwise(mean))
bySubjectActivity <- arrange(bySubjectActivity, subject, activity)
write.table(bySubjectActivity, file = "result.txt", row.names = FALSE)
