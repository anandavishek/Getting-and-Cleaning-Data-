## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")


# set working directory to the place where the files are stored  
setwd(".......") 

#load test data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

#load train data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

#load activity names
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")


#load feature names
features <- read.table("./UCI HAR Dataset/features.txt")
headers <- features[,2]

#name columns of test and train features
names(X_test) <- headers
names(X_train) <- headers

#Extracts only the Mean and Standard Deviation Headers 
mean_and_std <- grepl("mean\\(\\)|std\\(\\)", headers)

# Select only the mean and std columns on test and train
X_test_mean_and_std <- X_test[,mean_and_std]
X_train_mean_and_std <- X_train[,mean_and_std]

# Merge all test and train rows
subject_all <- rbind(subject_test, subject_train)
X_all <- rbind(X_test_mean_and_std, X_train_mean_and_std)
y_all <- rbind(y_test, y_train)

#combine all vectors/data.frames into one data.frame
merged <- cbind(subject_all, y_all, X_all)
names(merged)[1] <- "SubjectID"
names(merged)[2] <- "Activity"

#aggregate by subjectid and activity
agg <- aggregate(. ~ SubjectID + Activity, data=merged, FUN = mean)

#give activities better names
agg$Activity <- factor(agg$Activity, labels=activity_labels[,2])

write.table(agg, file="./Tidy_Data.txt", sep="\t", row.names=FALSE)


