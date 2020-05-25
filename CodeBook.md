---
title: "CodeBook.md"
author: "Johan"
date: "24/5/2020"
output: html_document
---

This is the CodeBook for the course project of the **Getting and Cleaning Data** course on Coursera.

## Data

The raw data set used for this project was retrieved from the *UCI Data Repository*, whose source is referenced.[^1] The tidying of the data described in the **Coding** section of this file was based on Hadley Wickham's *Tidy Data* paper.[^2]

The *run_analysis.R* script returns two data sets, the first one is called `data`, which is a data frame containing the measurements of the mean and standard deviation variables for each subject and each activity; the second data frame is called `summarized`, which summarizes the variables of `data` calculating their means for each subject and each activity.

For further information of the raw data, refer to the *README.txt* file within the *UCI HAR Dataset* directory, which is **different** from the *README.txt* file of the course project.

## Variables

The first column of both the final data set (called `data`) and the data set containing the means (called `summarized`, or the *MeansTidyData.txt* text file) is the subject number or ID, which go from 1 to 30. The second column of both data sets is the activity, which is a logical vector whose levels are *walking*, *walking upstairs*, *walking downstairs*, *sitting*, *standing* and *laying*.

For the data set called `data`, there are 79 variables, all of which are either a mean or standard deviation of some variable, whose units are described as follows.  
* **radians/seconds**, or **[rad/s]**, for the variables containing *Gyroscope* in its name, which represents the angular velocity vector measured by the gyroscope for each window sample.  
* **standard gravity units, g**, for the variables containing *Acceleration* in its name. The *Acceleration* variables with *Body* in their names refers to the body acceleration signal obtained by subtracting the gravity from the total acceleration.

The features containing *Magnitude* refer to the magnitude of the variable calculated as the Euclidean norm of the corresponding variable in each axis (X, Y and Z). **SD** means **standard deviation**.

## Coding

This section contains the *run_analysis.R* script description.

### Zip file download and unzipping

The first lines of code in the *run_analysis.R* script will download the zip file and unzip it if no directory named *UCI HAR Dataset* is found. This is done in lines **7** to **11**. Afterwards, the files within the new directory are listed by running line **13**.

**[7:11]** `if (!file.exists("UCI HAR Dataset")) {
download.file(url = "[omitted]", destfile = "files.zip");
unzip("files.zip")
}`
**[13]** `dir("./UCI HAR Dataset/")`

### Reading Features

The features, or variable names, are read in lines **16** to **17**. The function `read.table` is used to read the *features.txt* text file and return a data frame, whose columns are the feature numbers and feature names.

**[16:17]** `Features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE);
names(Features) <- c("Number", "FeatureName")`

### Reading Activities

The activities are read in lines **20** to **21**. Similarly, *the activity_labels.txt* text file is read into a data frame, whose columns are the activity numbers and activity names.

**[20:21]** `Activities <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE);
names(Activities) <- c("Number", "ActivityName")`

### Reading and merging Test files

The Test files are first listed running the code in line **24**, and then the *X_test.txt* test file is read into a big data frame, whose columns are the variables listed in *features.txt*, and its rows are the measurements for each subject and activity. The activities and subject numbers are in the files *y_test.txt* and *subject_test.txt*, respectively, which are read in lines **27** and **28**. The column names of the data frame `XTest` are changed into the variable names in line **26**.

**[24:26]** `dir("./UCI HAR Dataset/test/");
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE);
names(XTest) <- Features$FeatureName`
**[27:28]** `yTest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE);
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)`

A new data set from the read Test files is created, whose first column is the subject number, its second column the activity number, and the following columns are the variables. This is done in lines **30** to **31**.

**[30:31]** `mergedTest <- cbind(subjectTest, yTest, XTest);
names(mergedTest)[1:2] <- c("SubjectNumber", "ActivityNumber")`

### Reading and merging Training files

The Training files are first listed running the code in line **34**, and then the *X_train.txt* test file is read into a big data frame, whose columns are the variables listed in *features.txt*, and its rows are the measurements for each subject and activity. The activities and subject numbers are in the files *y_train.txt* and *subject_train.txt*, respectively, which are read in lines **37** and **38**. The column names of the data frame `XTraining` are changed into the variable names in line **36**.

**[34:36]** `dir("./UCI HAR Dataset/train/");
XTraining <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE);
names(XTraining) <- Features$FeatureName`
**[37:38]** `yTraining <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE);
subjectTraining <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)`

A new data set from the read Training files is created, whose first column is the subject number, its second column the activity number, and the following columns are the variables. This is done in lines **40** to **41**.

**[40:41]** `mergedTraining <- cbind(subjectTraining, yTraining, XTraining);
names(mergedTraining)[1:2] <- c("SubjectNumber", "ActivityNumber")`

### Merging both data sets

Afterwards, both data sets are merged into one by calling `rbind` in line **45**. The column names of this data set makes it difficult to arrange it, so they must be modified by calling `make.names`.

**[44:46]** `library(dplyr);
data <- rbind(mergedTest, mergedTraining);
names(data) <- make.names(names = names(data), unique = TRUE, allow_ = TRUE)`

### Converting activity numbers into strings using factor

By this point, unnecessary data like the first two data sets are removed by calling `gdata::keep`. The activity numbers of the data set, i.e. second column, are converted into strings using the `factor` function, whose labels are those listed in *activity_labels.txt*. This is done in lines **48** to **53**.

**[48:51]** `library(gdata);
keep(data, Activities, sure = TRUE);
data[ , 2] <- factor(data[ , 2]);
levels(data[ , 2]) <- Activities$ActivityName`
**[52:53]** `data <- arrange(data, SubjectNumber, ActivityNumber);
keep(data, sure = TRUE)`

### Extraction of the mean and standard deviation columns

This is performed on line **56** by calling the `select` function from the `dplyr` package.

**53** `data <- select(data, 1, 2, which(grepl("(mean)|(std)",names(data))))`

### Renaming the activities

The activities, although already correct, are converted into a more stylish string by calling `stringr::str_to_title`, which makes only the first letter uppercase. Lines **59** to **60** do this.

**[59:60]** `library(stringr);
levels(data[ , 2]) <- str_to_title(levels(data[ , 2]))`

### Renaming the variables

The variable names are made more descriptive using `gsub`. This is performed on lines **63** to **74**.

**[63:65]** `names(data)[1:2] <- c("Subject", "Activity");
names(data) <- gsub("mean", "Mean", names(data));
names(data) <- gsub("std", "SD", names(data))`
**[66:68]** `names(data) <- gsub("Freq", "Frequency", names(data));
names(data) <- gsub("^t", "Time.", names(data));
names(data) <- gsub("^f", "Frequency.", names(data))`
**[69:71]** `names(data) <- gsub("Acc", "Acceleration", names(data));
names(data) <- gsub("Gyro", "Gyroscope", names(data));
names(data) <- gsub("Mag", "Magnitude", names(data))`
**[62:74]** `names(data) <- gsub("\\.\\.\\.", "\\.", names(data));
names(data) <- gsub("\\.\\.", "", names(data));
names(data) <- gsub("\\.$", "", names(data))`

The data set called `data` is tidy, for each column corresponds to a variable or attribute, and each row corresponds to a measurement. The first column is the subject number (or ID), the second column is the activity, and the following columns are the features.

### Creating independent tidy data set

Now, to create the requested independent data set, the `data` data set is melted by subject number and activity, which is done in line **78** by calling `melt` from the `reshape` package, and stored into a data frame called `summarized`. Then, this data frame (`summarized`) is casted into a data frame, which contains the mean of each variable for each subject and each activity by calling the `dcast` function from the same package in line **79**.

**[77:79]** `library(reshape2);
summarized <- melt(data, id.vars = c("Subject", "Activity"));
summarized <- dcast(summarized, Subject + Activity ~ variable, mean)`

Finally, the text file is written in line **81** calling `write.table`. This data set is named as *MeansTidyData.txt*.

**81** `write.table(summarized, "MeansTidyData.txt", row.names = FALSE)`

## Session Info

R version 4.0.0 (2020-04-24)  
Platform: x86_64-w64-mingw32/x64 (64-bit)  
Running under: Windows 10 x64 (build 18362)  

Matrix products: default

locale:  
[1] LC_COLLATE=Spanish_Colombia.1252 &nbsp; LC_CTYPE=Spanish_Colombia.1252 &nbsp; LC_MONETARY=Spanish_Colombia.1252  
[4] LC_NUMERIC=C &nbsp; LC_TIME=Spanish_Colombia.1252    

attached base packages:  
[1] stats &nbsp; graphics &nbsp; grDevices &nbsp; utils &nbsp; datasets &nbsp; methods &nbsp; base  

other attached packages:  
[1] reshape2_1.4.4 &nbsp; stringr_1.4.0 &nbsp; gdata_2.18.0 &nbsp; dplyr_0.8.5  

loaded via a namespace (and not attached):  
[1] Rcpp_1.0.4.6 &nbsp; gtools_3.8.2 &nbsp; crayon_1.3.4 &nbsp; assertthat_0.2.1 &nbsp; plyr_1.8.6 &nbsp; R6_2.4.1 &nbsp; lifecycle_0.2.0  
[8] magrittr_1.5 &nbsp; pillar_1.4.4 &nbsp; stringi_1.4.6 &nbsp; rlang_0.4.6 &nbsp; rstudioapi_0.11 &nbsp; vctrs_0.3.0 &nbsp; ellipsis_0.3.1    
[15] tools_4.0.0 &nbsp; glue_1.4.1 &nbsp; purrr_0.3.4 &nbsp; compiler_4.0.0 &nbsp; pkgconfig_2.0.3 &nbsp; tidyselect_1.1.0 &nbsp; tibble_3.0.1  

## References

[^1]: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

[^2]: Wickham, H. (2014). Tidy Data. Journal of Statistical Software, 59(10), 1 - 23. doi:<http://dx.doi.org/10.18637/jss.v059.i10>
