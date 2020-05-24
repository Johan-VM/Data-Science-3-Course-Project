## Johan Vásquez Mazo
## Universidad Nacional de Colombia - Sede Medellín

## 0. Preliminaries

# Zip file download
if (!file.exists("UCI HAR Dataset")) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                  destfile = "files.zip")
    unzip("files.zip")
}

dir("./UCI HAR Dataset/")

# Features
Features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
names(Features) <- c("Number", "FeatureName")

# Activity labels
Activities <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
names(Activities) <- c("Number", "ActivityName")

# Test files
dir("./UCI HAR Dataset/test/")
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
names(XTest) <- Features$FeatureName
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

mergedTest <- cbind(subjectTest, yTest, XTest)
names(mergedTest)[1:2] <- c("SubjectNumber", "ActivityNumber")

# Training files
dir("./UCI HAR Dataset/train/")
XTraining <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
names(XTraining) <- Features$FeatureName
yTraining <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subjectTraining <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

mergedTraining <- cbind(subjectTraining, yTraining, XTraining)
names(mergedTraining)[1:2] <- c("SubjectNumber", "ActivityNumber")

## 1. Merging both Test and Training data sets into one data set
library(dplyr)
data <- rbind(mergedTest, mergedTraining)
names(data) <- make.names(names = names(data), unique = TRUE, allow_ = TRUE)

library(gdata)
keep(data, Activities, sure = TRUE)
data[ , 2] <- factor(data[ , 2])
levels(data[ , 2]) <- Activities$ActivityName
data <- arrange(data, SubjectNumber, ActivityNumber)
keep(data, sure = TRUE)

## 2. Extraction of all mean and standard deviation variables
data <- select(data, 1, 2, which(grepl("(mean)|(std)",names(data))))

## 3. Renaming activity names appropriately
library(stringr)
levels(data[ , 2]) <- str_to_title(levels(data[ , 2]))

## 4. Renaming variable names appropriately
names(data)[1:2] <- c("Subject", "Activity")
names(data) <- gsub("mean", "Mean", names(data))
names(data) <- gsub("std", "SD", names(data))
names(data) <- gsub("Freq", "Frequency", names(data))
names(data) <- gsub("^t", "Time.", names(data))
names(data) <- gsub("^f", "Frequency.", names(data))
names(data) <- gsub("Acc", "Acceleration", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("\\.\\.\\.", "\\.", names(data))
names(data) <- gsub("\\.\\.", "", names(data))
names(data) <- gsub("\\.$", "", names(data))

## 5. Independent tidy data set
library(reshape2)
summarized <- melt(data, id.vars = c("Subject", "Activity"))
summarized <- dcast(summarized, Subject + Activity ~ variable, mean)

write.csv(summarized, "TidyData.csv", row.names = FALSE)
