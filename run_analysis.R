## Johan Vásquez Mazo
## Universidad Nacional de Colombia - Sede Medellín

if (!file.exists("UCI HAR Dataset")) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                  destfile = "files.zip")
    unzip("files.zip")
}

library(readtext)
dir("./UCI HAR Dataset/")

# Features
Features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
names(Features) <- c("Number", "FeatureName")
# Activity Labels
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

# Merging both Test and Training data frames
library(dplyr)
data <- rbind(mergedTest, mergedTraining)
names(data) <- gsub("()", "", names(data))
