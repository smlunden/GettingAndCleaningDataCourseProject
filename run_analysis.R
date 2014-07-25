# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# the outline of events for making a tidy data set
makeTidyData <- function() {
	library(plyr)
	
	# extract data and combine it
	wholeSet <- readAndCombineData()

	# set column names using activity, subject_id, and features
	# features = measurement's column names (first row of data set)
	features <- read.table("UCI HAR Dataset/features.txt", sep = " ") 
	columnNames <- c("activity", "subject_id", paste(features[ , 2], sep = ", "))
	names(wholeSet) <- columnNames
	
	# substitute activity names for ids
	wholeSet <- substituteActivityNames(wholeSet)

	# extract only mean and stddev columns
	partialSet <- extractMeanAndStdDev(features, wholeSet)

	# make column names more human readable
	partialSet <- renameColumns(partialSet)

	# create second tidy set with averages	
	tidyDataSet <- ddply(partialSet, .(activity, subjectid), numcolwise(mean))
	
	# write tidyDataSet to file
	write.table(tidyDataSet, "tidyDataSL.txt", row.names=FALSE)
}

## extract data and combine it to one data frame
	# X_test = each measurement in test group (subsequent rows of data set)
	# X_train = each measurement in train group (even more rows of data set)
	# y_test = activity code for each measurement in test group (first column of data set)
	# y_train = activity code for each measurement in train group (more first column of data set)
	# subject_test = subject code for each measurement (second column of data set)
##
readAndCombineData <- function() {
	# combine y_train and y_test 
	y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
	y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
	y_data <- c(y_test[ , 1], y_train[ , 1])
	
	# combine subject_test and subject_train
	subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
	subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
	subject_data <- c(subject_test[ , 1], subject_train[ , 1])
	
	# combine x_test and x_train
	x_test <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "")
	x_train <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "")
	x_data <- rbind(x_test, x_train)
	
	# set data into data frame
	wholeSet <- cbind(y_data, subject_data, x_data)
	
	#return wholeSet
	wholeSet
}

# substitute human readable activity names for activity ids
substituteActivityNames <- function(wholeSet) {
	# extract activity id and name data
	activity_substitution <- read.table("UCI HAR Dataset/activity_labels.txt")

	# relabel activity id to activity name
	for (id in activity_substitution[ , 1]) {
		wholeSet$activity[wholeSet$activity == id] <- as.character(activity_substitution[id, 2])
	}
	
	# return wholeSet
	wholeSet
}

# extract mean and standard deviation columns
extractMeanAndStdDev <- function(features, wholeSet) {
	# set colnames on features data
	names(features) <- c("id", "feature")
	# find column ids for any column taking a mean
	meanColumns <- features[grep("mean", features$feature), 1]
	# find column ids for any column taking a standard deviation
	stdColumns <- features[grep("std", features$feature), 1]
	# add both mean and standard deviation columns to one vector
	keepColumns <- c(meanColumns, stdColumns)
	# add 2 to each column id, there are 2 columns before the features columns begin
	keepColumns <- keepColumns + 2
	# keep the activity and subjectid columns
	keepColumns <- c(1, 2, keepColumns)
	# subset the entire data frame using column ids
	partialSet <- wholeSet[, sort(keepColumns)]

	# return partialSet
	partialSet
}	

# make column names (features) readable
renameColumns <- function(partialSet) {
	# turn all abbreviations into words
	names(partialSet) <- gsub("tBody", "timeBody", names(partialSet))
	names(partialSet) <- gsub("tGravity", "timeGravity", names(partialSet))
	names(partialSet) <- gsub("fGravity", "frequencyGravity", names(partialSet))
	names(partialSet) <- gsub("fBodyBody", "frequencyBody", names(partialSet))
	names(partialSet) <- gsub("fBody", "frequencyBody", names(partialSet))
	names(partialSet) <- gsub("Acc", "Acceleration", names(partialSet))
	names(partialSet) <- gsub("Gyro", "Gyroscope", names(partialSet))
	names(partialSet) <- gsub("Mag", "Magnitude", names(partialSet))
	names(partialSet) <- gsub("mean", "Mean", names(partialSet))
	names(partialSet) <- gsub("std", "StandardDeviation", names(partialSet))
	names(partialSet) <- gsub("Freq", "Frequency", names(partialSet))
	
	# remove punctuation from column names
	names(partialSet) <- gsub("[[:punct:]]", "", names(partialSet))
	
	# return partialSet
	partialSet
}

## download and unzip files, for reference only, not required to turn in
# openFiles <- function() {
# 	# download zip file
# 		fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# 		download.file(fileUrl, destfile = "UCI HAR Dataset.zip", method = "curl")
# 	
# 	# unzip file
# 		unzip("UCI HAR Dataset.zip")
# }