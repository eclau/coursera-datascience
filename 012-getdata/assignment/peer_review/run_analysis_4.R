#1. Merges the training and the test sets to create one data set.

    #Load training data 
    y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
    X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
    subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
    
    #Combine traing data
    traindata <- cbind(y_train,subject_train,X_train)
    
    #Load test data
    y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
    X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
    subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
    
    #Combine test data
    testdata <- cbind(y_test,subject_test,X_test)
    
    #Combine test and training data
    comData <- rbind(traindata,testdata)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
    features <- read.table("UCI HAR Dataset/features.txt")
    
    #Collect mean and std index and Labels
    selFeat<-features[grepl("mean\\(\\)", features$V2) | grepl("std\\(\\)", features$V2), ]
    
    #Remove un-wanted columns from table
    comData<-comData[, c(1,2,selFeat$V1+2)]

#3. Uses descriptive activity names to name the activities in the data set
    
    #Load activity labels file
    activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
    
    #Merge data table and activity labels matching on the activityid
    comData<-merge(activity_labels,comData,by="V1")
    
    #Delete old activityid column
    comData$V1 <- NULL
    
    #Rename activity name column
    colnames(comData)[1] <- "activityName"
    colnames(comData)[2] <- "subjectid"

#4. Appropriately labels the data set with descriptive variable names.
    
    selFeat$V1 <- NULL
    
    for (i in 1:nrow(selFeat)) 
    {
        col <- as.character(selFeat[i,])
        colnames(comData)[i+2] <- col
    }
    
    
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
    tidydata<-aggregate(comData[, 2:ncol(comData)], list(comData$activityName,comData$subjectid), mean)
    
    #remove group 2 column
    tidydata$Group.2 <- NULL
    
    #rename activity column
    colnames(tidydata)[1]<-"activityname"

    #Create output file
    write.table(tidydata, "submit.txt", row.name=FALSE) 