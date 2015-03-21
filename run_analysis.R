library("reshape2")

## Get descriptive names and labels for data set
## Features.txt provides descriptive labels for vector of sensor measurements
##   Replace characters in features that can't be used as R names with "_"
##   Create feature subset of measured means and standard deviations
##      i.e., feature string contains "mean" or "std"
## activity_labels.txt provides activity descriptions for activity codes 1-6

features <- read.table("./UCI HAR Dataset/features.txt", 
                       header=FALSE, sep="", 
                       col.names=c("FeatureNo", "Feature"))
features$Feature <- gsub("[[:punct:]]", "_", features$Feature)
features_mean_std <- features[grepl("_mean_|_std_", features$Feature), ]

activities <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                       header=FALSE, sep="",
                       col.names=c("ActivityID", "Activity"))


## Get train data - each row is a measurement of a subject doing an activity
##   X_train.txt rows are vector of sensor data for a measurement
##   y_train.txt is a the ActivityID for each X_train.txt row
##   subject_train.txt is the subjectID for each X_train.txt row
## Note: using features_mean_std to subset columns of data set

trainData <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                        header=FALSE, sep="",
                        col.names=features$Feature)
trainData <- trainData[, names(trainData) %in% features_mean_std$Feature]
trainData$ActivityID <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                            header=FALSE, sep="")[, 1]
trainData$SubjectID <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                            header=FALSE, sep="")[, 1]

# Add column with activity descriptions based on activities data frame
trainData$Activity <- sapply(trainData$ActivityID, 
                             function(x) activities$Activity[x])
# Create vector of indicator variable names
indicator_names <- c("SubjectID", "ActivityID", "Activity")
# Resort columns to put the indicator variables at the left
trainData <- trainData[, c(indicator_names, features_mean_std$Feature)]

## Get test data - each row is a measurement of a subject doing an activity
##   X_test.txt rows are vector of sensor data for a measurement
##   y_test.txt is a the ActivityID for each X_test.txt row
##   subject_test.txt is the subjectID for each X_test.txt row
## Note: using features_mean_std to subset columns of data set

testData <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                        header=FALSE, sep="",
                        col.names=features$Feature)
testData <- testData[, names(testData) %in% features_mean_std$Feature]
testData$ActivityID <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                                   header=FALSE, sep="")[, 1]
testData$SubjectID <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                                  header=FALSE, sep="")[, 1]

# Add column with activity descriptions based on activities data frame
testData$Activity <- sapply(testData$ActivityID, 
                             function(x) activities$Activity[x])

# Create vector of indicator variable names
indicator_names <- c("SubjectID", "ActivityID", "Activity")
# Resort columns to put the indicator variables at the left
testData <- testData[, c(indicator_names, features_mean_std$Feature)]

## Combine rows in testData with rows in trainData
allData <- rbind(trainData, testData)

## Create a second data set that provides the average value for each variable
##   for each user for each activity

# Melt data to get all measurement values in one column
meltData <- melt(allData, id=indicator_names, 
                 measure=features_mean_std$Feature)
# Recast all different measurement types into columns, but aggregated
#   as means for each combination of indicator conditions
summaryData <- dcast(meltData, SubjectID + ActivityID + Activity ~ ..., mean)


                                    
## Write tidy data frames to files
write.table(allData, "AllSensorData.txt", row.names=FALSE)
write.table(summaryData, "AllSensorData_Summarized.txt", row.names=FALSE)












