GettingAndCleaningDataCourseProject
===================================

Course Project: creating a tidy data set from raw data

This code assumes the data files from the (UCI Machine Learning Repository)[ https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip] have been downloaded and unzipped in the user's R working directory. The following code may be used to do so (this may take some time)
> fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
>
> download.file(fileUrl, destfile = "UCI HAR Dataset.zip", method = "curl")
>
> unzip("UCI HAR Dataset.zip")
	

The data set has many files of measurements based on having a user with a smartphone do various activities. The activity (walking, standing, etc), the subject_id (number given to each volunteer to identify them), the names of the measurements taken (called features), and the actual measurements for two groups of volunteers (the groups are called test and train) are contained in these files. For more information, see the README.txt within the download.

The purpose of the run_analysis.R script is to manipulate all of the data into a single data set with descriptive activity names (walking, standing, etc instead of an id number). Then a smaller data set containing only the measurements of mean and standard deviation is created, and each column name is expanded to be more readable (time instead of t, acceleration instead of acc, etc). Then, a data set is created with the average of each variable as it relates to both activity and subject. The last data set is written to a file, called tidyDataSL.txt, written to the R working directory.

