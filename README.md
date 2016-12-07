# DS_GettingNCleaningDataProject
For a final project.

Requirements:

>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
>
>One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
>
>http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
>
>Here are the data for the project:
>
>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
>
>You should create one R script called run_analysis.R that does the following.
>
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names.
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
>
>Good luck!

Steps in a run_analysis.R:
---------

* create a function my_grep that will help in the future. 
```
##my help function
my_grep<- function(regex) {
  grepl(regex, dt$feature)
}
```


* load library
```
library(data.table)
```


* read all neccesary files

```
#read files
dt_subject_train <- fread(file.path(pathData, "train", "subject_train.txt"))
dt_subject_test <- fread(file.path(pathData, "test", "subject_test.txt"))

dt_activity_train <- fread(file.path(pathData, "train", "Y_train.txt"))
dt_activity_test <- fread(file.path(pathData, "test", "Y_test.txt"))

dt_test <- fread(file.path(pathData, "test", "X_test.txt"))
dt_train <- fread(file.path(pathData, "train", "X_train.txt"))
```


4. #merge the training and the test sets and set key
```
#merge the training and the test sets
dt_subject <- rbind(dt_subject_train, dt_subject_test)
setnames(dt_subject, "V1", "subject")
dt_activity <- rbind(dt_activity_train, dt_activity_test)
setnames(dt_activity, "V1", "activityNum")
dt <- rbind(dt_train, dt_test)

dt_subject <- cbind(dt_subject, dt_activity)
dt <- cbind(dt_subject, dt)

setkey(dt, subject, activityNum)
```


5. Take SD and Mean
```
#take only SD and Mean
dt_features <- fread(file.path(pathData, "features.txt"))
setnames(dt_features, names(dt_features), c("featureNum", "featureName"))

dt_features <- dt_features[grepl("mean\\(\\)|std\\(\\)", featureName)]
dt_features$featureCode <- dt_features[, paste0("V", featureNum)]


dt <- dt[, c(key(dt), dt_features$featureCode), with = FALSE]
```


6. use descriptive acrtivity name file
```
#descriptive activity names
dt_activity_names <- fread(file.path(pathData, "activity_labels.txt"))
setnames(dt_activity_names, names(dt_activity_names), c("activityNum", "activityName"))
```

7. label with descriptive activity names
```
#label with descriptive activity names
dt <- merge(dt, dt_activity_names, by = "activityNum", all.x = TRUE)
setkey(dt, subject, activityNum, activityName)
```


8. Melt data
```
dt <- data.table(melt(dt, key(dt), variable.name = "featureCode"))
```

After this we have:
```
> dt
        subject activityNum activityName featureCode      value
     1:       1           1      WALKING          V1  0.2820216
     2:       1           1      WALKING          V1  0.2558408
     3:       1           1      WALKING          V1  0.2548672
     4:       1           1      WALKING          V1  0.3433705
     5:       1           1      WALKING          V1  0.2762397
    ---                                                        
679730:      30           6       LAYING        V543 -0.9979687
679731:      30           6       LAYING        V543 -0.9990995
679732:      30           6       LAYING        V543 -0.9991540
679733:      30           6       LAYING        V543 -0.9985502
679734:      30           6       LAYING        V543 -0.9988617
```

9. Merge with feature names
```
dt <- merge(dt, dt_features[, list(featureNum, featureCode, featureName)], by = "featureCode", all.x = TRUE)
```


10. Add factor variables:
```
dt$activity <- factor(dt$activityName)
dt$feature <- factor(dt$featureName)
```

11. Adding new factor variable:
```
n <- 2
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(my_grep("^t"), my_grep("^f")), ncol = nrow(y))
dt$domain_signal <- factor(x %*% y, labels = c("Time", "Freq"))

x <- matrix(c(my_grep("Acc"), my_grep("Gyro")), ncol = nrow(y))
dt$tool_signal <- factor(x %*% y, labels = c("Accelerometer", "Gyroscope"))

x <- matrix(c(my_grep("BodyAcc"), my_grep("GravityAcc")), ncol = nrow(y))
dt$acceleration_signal <- factor(x %*% y, labels = c(NA, "Body", "Gravity"))

x <- matrix(c(my_grep("mean()"), my_grep("std()")), ncol = nrow(y))
dt$variable <- factor(x %*% y, labels = c("Mean", "SD"))

dt$jerk_signal <- factor(my_grep("Jerk"), labels = c(NA, "Jerk"))
dt$magnitude_signal <- factor(my_grep("Mag"), labels = c(NA, "Magnitude"))

n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(my_grep("-X"), my_grep("-Y"), my_grep("-Z")), ncol = nrow(y))
dt$axis_signal <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))
```


12. Tidy data
```
##tidy data
setkey(dt, subject, activity, domain_signal, acceleration_signal, 
       tool_signal, jerk_signal, magnitude_signal, variable, axis_signal)
dt_tidy <- dt[, list(count = .N, average = mean(value)), by = key(dt)]
```


13. Save data
```
##save tidy data
fn <- file.path(path, "MyTidyData.csv")
write.csv(dt_tidy, fn)
```