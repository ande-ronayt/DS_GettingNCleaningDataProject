##my help function
my_grep<- function(regex) {
  grepl(regex, dt$feature)
}

library(data.table)

path <- getwd()
pathData <- file.path(path, "UCI HAR Dataset")

#read files
dt_subject_train <- fread(file.path(pathData, "train", "subject_train.txt"))
dt_subject_test <- fread(file.path(pathData, "test", "subject_test.txt"))

dt_activity_train <- fread(file.path(pathData, "train", "Y_train.txt"))
dt_activity_test <- fread(file.path(pathData, "test", "Y_test.txt"))

dt_test <- fread(file.path(pathData, "test", "X_test.txt"))
dt_train <- fread(file.path(pathData, "train", "X_train.txt"))


#merge the training and the test sets
dt_subject <- rbind(dt_subject_train, dt_subject_test)
setnames(dt_subject, "V1", "subject")
dt_activity <- rbind(dt_activity_train, dt_activity_test)
setnames(dt_activity, "V1", "activityNum")
dt <- rbind(dt_train, dt_test)

dt_subject <- cbind(dt_subject, dt_activity)
dt <- cbind(dt_subject, dt)

setkey(dt, subject, activityNum)


#take only SD and Mean
dt_features <- fread(file.path(pathData, "features.txt"))
setnames(dt_features, names(dt_features), c("featureNum", "featureName"))

dt_features <- dt_features[grepl("mean\\(\\)|std\\(\\)", featureName)]
dt_features$featureCode <- dt_features[, paste0("V", featureNum)]


dt <- dt[, c(key(dt), dt_features$featureCode), with = FALSE]

#descriptive activity names
dt_activity_names <- fread(file.path(pathData, "activity_labels.txt"))
setnames(dt_activity_names, names(dt_activity_names), c("activityNum", "activityName"))


#label with descriptive activity names
dt <- merge(dt, dt_activity_names, by = "activityNum", all.x = TRUE)
setkey(dt, subject, activityNum, activityName)

##melt data
dt <- data.table(melt(dt, key(dt), variable.name = "featureCode"))


dt <- merge(dt, dt_features[, list(featureNum, featureCode, featureName)], by = "featureCode", all.x = TRUE)

dt$activity <- factor(dt$activityName)
dt$feature <- factor(dt$featureName)

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


##tidy data
setkey(dt, subject, activity, domain_signal, acceleration_signal, 
       tool_signal, jerk_signal, magnitude_signal, variable, axis_signal)
dt_tidy <- dt[, list(count = .N, average = mean(value)), by = key(dt)]

##save tidy data
fn <- file.path(path, "MyTidyData.csv")
write.csv(dt_tidy, fn)