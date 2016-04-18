setwd("~/Desktop/R")

#train
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
View(X_train)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
View(y_train)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
View(subject_train)

#test
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
View(X_test)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
View(y_test)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
View(subject_test)

#combine train and test
X_total <- rbind(X_train,X_test)
y_total <- rbind(y_train,y_test)
subject_total <- rbind(subject_train,subject_test)

#put the variable name on
var_name <- read.table("./UCI HAR Dataset/features.txt")
colnames(var_name) <- c("num","name")
colnames(X_total) <- var_name$name
colnames(y_total) <- "label"
colnames(subject_total) <- "subject"

#merge
bind1 <- cbind(subject_total,y_total)
bind2 <- cbind(bind1,X_total)
label_name <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(label_name) <- c("label","name")
merge1 <- merge(bind2,label_name,by="label")

#Extract mean and std variables
merge_meanstd <- merge1[,c(grepl("subject|name|.*Mean.*|.*Std.*", names(merge1), ignore.case=TRUE))]

#arrange the variables order and rename
merge_meanstd <- merge_meanstd[c(1,88,2:87)]
names(merge_meanstd)
names(merge_meanstd) <- gsub("Acc", "Accelerometer", names(merge_meanstd))
names(merge_meanstd) <- gsub("Gyro", "Gyroscope", names(merge_meanstd))

#create independent tidy data set with the average of each variable for each activity and each subject
library(plyr)
tidy_data <- aggregate(. ~subject + name, data=merge_meanstd, mean)
tidy_data <- tidy_data[order(tidy_data$subject,tidy_data$name),]
write.table(tidy_data, file = "tidydata.txt",row.name=FALSE)










