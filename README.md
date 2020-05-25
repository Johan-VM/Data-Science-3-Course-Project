---
title: "README.md"
author: "Johan"
date: "24/5/2020"
output: html_document
---

## Data Science: Getting and Cleaning Data - Course Project

The GitHub repository *Data-Science-3-Course-Project* was created to store the course project for the **Getting and Cleaning Data** course on Coursera.

### Files

There are four major files in the repository, which are:  
1. **run_analysis.R**, the R script used to tidy the data, all the way from the zip file download up until the final independent data set creation.  
2. **CodeBook.md**, the MarkDown file describing the variables, the data, and every transformation performed to clean up the data.  
3. **README.md**, this file, listing and describing each file.  
4. **MeansTidyData.txt**, the independent tidy data set with the average of each variable for each activity and each subject as requested.

Additionally, there should be noted that there are other files accompanying these four major files, namely those within the *UCI HAR Dataset* folder. Although the *run_analysis.R* script downloads the zip file, i.e. raw data, the reader should check the *README.txt* file, and the *activity_labels.txt*, *features.txt* and *features_info.txt* files as well, all of which are within the unzipped folder.

The raw data set used to complete this course project was retrieved from the *UCI Data Repository*, whose source is referenced.[^1] Furthermore, the tidying of the data was based on Hadley Wickham's *Tidy Data* paper.[^2]

### References

[^1]: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

[^2]: Wickham, H. (2014). Tidy Data. Journal of Statistical Software, 59(10), 1 - 23. doi:<http://dx.doi.org/10.18637/jss.v059.i10>
