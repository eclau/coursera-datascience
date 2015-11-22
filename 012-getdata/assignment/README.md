# Introduction
The script run_analysis.R produces a result.txt file that contains the average of all mean gyrometer and gravitational acceleration measurements for each subject and each activity.
## Purpose
The purpose of this project is to prepare the raw set of data into a tidy data format which can be used later for analysis.
## Requirement
* Please download and unzip and accompanying 'UCI HAR Dataset.zip' before executing run_analysis.R
* R code requires the following libraries to be installed:
  * dplyr
  * plyr
## run_analysis.R Walk-through
1. Extract both feature and activity labels
2. Merge the test data with the extracted feature and activity labels
3. Subset the dataset from (2) to include columns that denotes the mean and standard deviation (along with the activity and subject ids)
4. Repeat 1-3 with the training data
5. rbind both test and training data sets
6. Use ddply to apply mean to each of the variable for each subject id and each activity
7. Sort the result data set by subject id and activty
6. Export the results into result.txt in the working directory
## Data Dictionary
* subject 1
  * Volunteer within an age bracket of 19-48 years, denoted by 1 - 6
* activity 18
  * Activities performed by the volunteer
    1. WALKING
    2. WALKING_UPSTAIRS
    3. WALKING_DOWNSTAIRS
    4. SITTING
    5. STANDING
    6. LAYING
* tBodyAcc.mean.X m/seg2
  * Average of body acceleration mean on X axis
* tBodyAcc.mean.Y m/seg2
  * Average of body acceleration mean on Y axis
* tBodyAcc.mean.Z m/seg2
  * Average of body acceleration mean on Z axis
* tBodyAcc.std.X m/seg2
  * Average of body acceleration standard deviation on X axis
* tBodyAcc.std.Y m/seg2
  * Average of body acceleration standard deviation on Y axis
* tBodyAcc.std.Z m/seg2
  * Average of body acceleration standard deviation on Z axis
* tGravityAcc.mean.X m/seg2
  * Average of bravity acceleration mean on X axis
* tGravityAcc.mean.Y m/seg2
  * Average of gravity acceleration mean on Y axis
* tGravityAcc.mean.Z m/seg2
  * Average of gravity acceleration mean on Z axis
* tGravityAcc.std.X m/seg2
  * Average of gravity acceleration standard deviation on X axis
* tGravityAcc.std.Y m/seg2
  * Average of gravity acceleration standard deviation on Y axis
* tGravityAcc.std.Z m/seg2
  * Average of gravity acceleration standard deviation on Z axis
* tBodyAccJerk.mean.X m/seg2
  * Average of body acceleration jerk mean on X axis
* tBodyAccJerk.mean.Y m/seg2
  * Average of body acceleration jerk mean on Y axis
* tBodyAccJerk.mean.Z m/seg2
  * Average of body acceleration jerk mean on Z axis
* tBodyAccJerk.std.X m/seg2
  * Average of body acceleration jerk standard deviation on X axis
* tBodyAccJerk.std.Y m/seg2
  * Average of body acceleration jerk standard deviation on Y axis
* tBodyAccJerk.std.Z m/seg2
  * Average of body acceleration jerk standard deviation on Z axis
* tBodyGyro.mean.X rad/seg
  * Average of body gyrometer mean on X axis
* tBodyGyro.mean.Y rad/seg
  * Average of body gyrometer mean on Y axis
* tBodyGyro.mean.Z rad/seg
  * Average of body gyrometer mean on Z axis
* tBodyGyro.std.X rad/seg
  * Average of body gyrometer standard deviation on X axis
* tBodyGyro.std.Y rad/seg
  * Average of body gyrometer standard deviation on Y axis
* tBodyGyro.std.Z rad/seg
  * Average of body jerk gyrometer standard deviation on Z axis
* tBodyGyroJerk.mean.X rad/seg
  * Average of Body jerk gyrometer mean on X axis
* tBodyGyroJerk.mean.Y rad/seg
  * Average of Body jerk gyrometer mean on Y axis
* tBodyGyroJerk.mean.Z rad/seg
  * Average of Body jerk gyrometer mean on Z axis
* tBodyGyroJerk.std.X rad/seg
  * Average of body gyrometer jerk standard deviation on X axis
* tBodyGyroJerk.std.Y rad/seg
  * Average of body gyrometer jerk standard deviation on Y axis
* tBodyGyroJerk.std.Z rad/seg
  * Average of body gyrometer jerk standard deviation on Z axis
* tBodyAccMag.mean m/seg2
  * Average of body accelerometer magnitude mean
* tBodyAccMag.std m/seg2
  * Average of body accelerometer magnitude standard deviation
* tGravityAccMag.mean m/seg2
  * Average of gravity accelerometer magnitude mean
* tGravityAccMag.std m/seg2
  * Average of gravity accelerometer magnitude standard deviation
* tBodyAccJerkMag.mean m/seg2
  * Average of body accelerometer jerk magnitude mean
* tBodyAccJerkMag.std m/seg2
  * Average of body accelerometer jerk magnitude standard deviation
* tBodyGyroMag.mean rad/seg
  * Average of body gyrometer magnitude mean
* tBodyGyroMag.std rad/seg
  * Average of body gyrometer magnitude standard deviation
* tBodyGyroJerkMag.mean rad/seg
  * Average of body gyrometer jerk magnitude mean
* tBodyGyroJerkMag.std rad/seg
  * Average of body gyrometer jerk magnitude standard deviation
* fBodyAcc.mean.X m/seg2
  * Average of body acceleration mean on X axis
* fBodyAcc.mean.Y m/seg2
  * Average of body acceleration mean on Y axis
* fBodyAcc.mean.Z m/seg2
  * Average of body acceleration mean on Z axis
* fBodyAcc.std.X m/seg2
  * Average of body acceleration standard deviation on X axis
* fBodyAcc.std.Y m/seg2
  * Average of body acceleration standard deviation on Y axis
* fBodyAcc.std.Z m/seg2
  * Average of body acceleration standard deviation on Z axis
* fBodyAccJerk.mean.X m/seg2
  * Average of body acceleration jerk mean on X axis
* fBodyAccJerk.mean.Y m/seg2
  * Average of body acceleration jerk mean on Y axis
* fBodyAccJerk.mean.Z m/seg2
  * Average of body acceleration jerk mean on Z axis
* fBodyAccJerk.std.X m/seg2
  * Average of body acceleration jerk standard deviation on X axis
* fBodyAccJerk.std.Y m/seg2
  * Average of body acceleration jerk standard deviation on Y axis
* fBodyAccJerk.std.Z m/seg2
  * Average of body acceleration jerk standard deviation on Z axis
* fBodyGyro.mean.X rad/seg
  * Average of body gyrometer mean on X axis
* fBodyGyro.mean.Y rad/seg
  * Average of body gyrometer mean on Y axis
* fBodyGyro.mean.Z rad/seg
  * Average of body gyrometer mean on Z axis
* fBodyGyro.std.X rad/seg
  * Average of body gyrometer standard deviation on X axis
* fBodyGyro.std.Y rad/seg
  * Average of body gyrometer standard deviation on Y axis
* fBodyGyro.std.Z rad/seg
  * Average of body gyrometer standard deviation on Z axis
* fBodyAccMag.mean rad/seg
  * Average of body accelerometer magnitude mean
* fBodyAccMag.std  rad/seg
  * Average of body accelerometer magnitude standard deviation
* fBodyBodyAccJerkMag.mean rad/seg
  * Average of body accelerometer jerk mean
* fBodyBodyAccJerkMag.std rad/seg
  * Average of body accelerometer jerk standard deviation
* fBodyBodyGyroMag.mean m/seg2
  * Average of body gyrometer magnitude mean
* fBodyBodyGyroMag.std m/seg2
  * Average of body gyrometer magnitude standard deviation
* fBodyBodyGyroJerkMag.mean m/seg2
  * Average of body gyrometer jerk magnitude mean
* fBodyBodyGyroJerkMag.std m/seg2
  * Average of body gyrometer jerk standard deviation
