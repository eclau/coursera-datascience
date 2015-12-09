library(plyr)
library(data.table)

#############################################
## 0. Download and store smartphone data set.
#############################################

## If the data hasn't already been downloaded, download and unzip.
dataset_dir <- "UCI\ HAR\ Dataset"
if (!file.exists(dataset_dir)){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, destfile = "data.zip")
        unzip("data.zip")
}


## Set filenames and load data
activity_labels_file <- paste(dataset_dir, "/activity_labels.txt", sep = "")
features_file <- paste(dataset_dir, "/features.txt", sep = "")
subject_train_file <- paste(dataset_dir, "/train/subject_train.txt", sep = "")
x_train_file <- paste(dataset_dir, "/train/X_train.txt", sep = "")
y_train_file <- paste(dataset_dir, "/train/y_train.txt", sep = "")
subject_test_file <- paste(dataset_dir, "/test/subject_test.txt", sep = "")
x_test_file <- paste(dataset_dir, "/test/X_test.txt", sep = "")
y_test_file <- paste(dataset_dir, "/test/y_test.txt", sep = "")

activity_labels <- read.table(activity_labels_file, col.names = c("ActivityId", "Activity"))
features <- read.table(features_file, colClasses = c("character")) ##List of all features
subject_train <- read.table(subject_train_file)
x_train <- read.table(x_train_file) ## Training Set
y_train <- read.table(y_train_file) ## Training Labels
subject_test <- read.table(subject_test_file) 
x_test <- read.table(x_test_file) ## Test Set
y_test <- read.table(y_test_file) ## Test Labels

        
##########################################################        
## 1. Merge training and test sets to create one data set.
##########################################################
train_data <- cbind(cbind(x_train, subject_train), y_train)
test_data <- cbind(cbind(x_test, subject_test), y_test)

merged_data <- rbind(train_data, test_data)

#label columns
column_labels <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(merged_data) <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]

############################################################
## 2. Extract the measurements on the mean & stdev for each. 
############################################################
        
##mean_std_data <- merged_data[, grep(".*Mean.*|.*Std.*", names(merged_data), ignore.case = TRUE)]
mean_std_data <- merged_data[, grepl("mean|std|Subject|ActivityId", names(merged_data), ignore.case = TRUE)]

####################################################################
## 3. Use descriptive activity names to name activities in data set.
####################################################################

## Attempted to use plyr, resulted in an rfill data.frame error
        ##mean_std_data <- join(mean_std_data, column_labels, by = "ActivityId", match = "first")
        ##mean_std_data <- mean_std_data[,-1]

## Used for() loop to re-label ActivityId as description instead of integer
mean_std_data$ActivityId <- as.character(mean_std_data$ActivityId)
for (i in 1:6) {
        mean_std_data$ActivityId[mean_std_data$ActivityId == i] <- as.character(activity_labels[i,2])
}
mean_std_data$ActivityId <- as.factor(mean_std_data$ActivityId)

#####################################################
## 4. Label data set with descriptive variable names.
#####################################################

names(mean_std_data)<-gsub("Acc", "Accelerometer", names(mean_std_data))
names(mean_std_data)<-gsub("Gyro", "Gyroscope", names(mean_std_data))
names(mean_std_data)<-gsub("BodyBody", "Body", names(mean_std_data))
names(mean_std_data)<-gsub("Mag", "Magnitude", names(mean_std_data))
names(mean_std_data)<-gsub("^t", "Time", names(mean_std_data))
names(mean_std_data)<-gsub("^f", "Frequency", names(mean_std_data))
names(mean_std_data)<-gsub("tBody", "TimeBody", names(mean_std_data))
names(mean_std_data)<-gsub("-mean()", "Mean", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("-std()", "STD", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("-freq()", "Frequency", names(mean_std_data), ignore.case = TRUE)
names(mean_std_data)<-gsub("angle", "Angle", names(mean_std_data))
names(mean_std_data)<-gsub("gravity", "Gravity", names(mean_std_data))

#############################################################
## 5. Create separate, independent tidy data set with
##    average of each variable for each activity and subject.
#############################################################

##factorize the Subject variable data type
mean_std_data$Subject <- as.factor(mean_std_data$Subject)
mean_std_data_1 <- data.table(mean_std_data)

## create tidy data with mean for each subject and activity
tidy_data <- aggregate(. ~Subject + ActivityId, mean_std_data_1, mean)
## order by subject, then activity
tidy_data <- tidy_data[order(tidy_data$Subject, tidy_data$ActivityId),]
## write the tidy data set to a text file
write.table(tidy_data, file = "tidy.txt", row.names = FALSE)