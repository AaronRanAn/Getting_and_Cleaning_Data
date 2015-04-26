# Final Course Project

# Data Source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# This script performs the following tasks:

# 1. downlaod and unzip the file

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(url,destfile="Dataset.zip",method="curl")

unzip(zipfile="Dataset.zip")

path_rf <- file.path("UCI HAR Dataset")
files <- list.files(path_rf, recursive=TRUE)
files

# 2. Read all the table set

        subject_test <- read.table(file.path(path_rf, "test" , "subject_test.txt" ),header = FALSE)

        X_test <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)

        y_test <- read.table(file.path(path_rf, "test" , "y_test.txt" ),header = FALSE)

        subject_train<- read.table(file.path(path_rf, "train" , "subject_train.txt" ),header = FALSE)

        X_train <- read.table(file.path(path_rf, "train" , "X_train.txt" ),header = FALSE)

        y_train <- read.table(file.path(path_rf, "train" , "y_train.txt" ),header = FALSE)

# 3. Exploratory Check 

        str(subject_test)

        str(subject_train)        

        str(X_test)

        str(X_train)        

        str(y_test)

        str(y_train)

#4. Merge training and test set

        subject <- rbind(subject_test, subject_train)

        activity_y <- rbind(y_test, y_train)

        feature_x <- rbind(X_test, X_train)

#5.  Naming variables

names(subject) <- c("subject") # rename the nameless subject data 

names(activity_y) <- c("activity") #  rename the nameless activity data 

FeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)

names(feature_x)<- FeaturesNames$V2  # use feature's 2nd var to names the feature data set

#6. merge into the final data set

tempcomb <- cbind(subject, activity_y)

data <- cbind(tempcomb, feature_x)

#7. Extracts only the measurements on the mean and standard deviation for each measurement

subFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]

selectedNames<-c(as.character(subFeaturesNames), "subject", "activity" )

data<-subset(data,select=selectedNames)

str(data)

#8. Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

as.factor(data$activity)

data$activity[data$activity == 1] <- "Walking"
data$activity[data$activity == 2] <- "Walking Upstairs"
data$activity[data$activity == 3] <- "Walking Downstairs"
data$activity[data$activity == 4] <- "Sitting"
data$activity[data$activity == 5] <- "Standing"
data$activity[data$activity == 6] <- "Laying"

#9. Appropriately labels the data set with descriptive variable names

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

names(data)

#10. Creates a second,independent tidy data set and ouput it

library(plyr);

data2<-aggregate(. ~subject + activity, data, mean)
data2<-data2[order(data2$subject,data2$activity),]

write.table(data2, file = "tidydata.txt",row.name=FALSE)

#11. Produce a codebook

library(knitr)

knit2html("codebook.Rmd");

