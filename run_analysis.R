#This will be a quick script to merge data sets for the GCD Class Project

#Load the plyr package
library(plyr)

#1. Merge the training and test sets
XtestSet <- read.table("./UCI HAR Dataset/test/X_test.txt")
XtrainSet <- read.table("./UCI HAR Dataset/train/X_train.txt")
YtestSet <- read.table("./UCI HAR Dataset/test/Y_test.txt")
YtrainSet <- read.table("./UCI HAR Dataset/train/Y_train.txt")
SubjectTest <-  read.table("./UCI HAR Dataset/test/subject_test.txt")
SubjectTrain <-  read.table("./UCI HAR Dataset/train/subject_train.txt")

#Combine above data sets
X_Data <- rbind(XtestSet, XtrainSet)
Y_Data <- rbind(YtestSet, YtrainSet)
Subject_Data <- rbind(SubjectTest, SubjectTrain)

##
Features <- read.table("./UCI HAR Dataset/features.txt")

mean_std <- grep("-(mean|std)\\(\\)", Features[,2])

##
X_Data <- X_Data[, mean_std]
names(X_Data) <- Features[mean_std, 2]

##
Activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
Y_Data[,1] <- Activities[Y_Data[,1], 2]
names(Y_Data) <- "activity"
names(Subject_Data) <- "subject"

##
combined_data <- cbind(X_Data, Y_Data, Subject_Data)

##
average_data <- ddply(combined_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

##
write.table(average_data, "average_data.txt", row.name=FALSE)
