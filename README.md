Analysis of Samsung Galaxy S Accelerometer Dataset
========================================================

The R script run_analysis.R takes as input the following files:
* Training data set
    * X_train.txt - rows are vectors of measured and calculated sensor data for a subject conducting an activity
    * y_train.txt - Activity codes for the rows of X_train.txt
    * subject_train.txt - Subject ids for the rows of X_train.txt
* Test data set
    * X_test.txt - rows are vectors of measured and calculated sensor data for a subject conducting an activity
    * y_test.txt - Activity codes for the rows of X_train.txt
    * subject_test.txt - Subject ids for the rows of X_train.txt
* Files with labels and keys
    * features.txt - names of the variables in the columns of X_train.txt and X_test.txt
    * activity_labels.txt - text descriptions of th activity codes in y_train.txt and y_test.txt
    
The R script carries out the following analysis
* Loads x_train.txt and x_test.txt into data frames
    * Loads features.txt; results used to label data set with descriptive variable names
    * Loads y_train.txt and subject_train.txt (or train analogs) to add columns for subject and activity codes
* Subsets to only keep measurements associated with mean and standard deviation for a condition
    * I.e., only keeps feature names with "_mean_" or "_std_" in the name string
* Merges training and test data into one tidy data frame
    * Written out as data file named "AllSensorData.txt"
* Generates a second summary tidy data frame
    * Each row provides the mean of each variable for each combination of subjectID and ActivityID
    * Written out as data file named "AllSensorData_Summarized.txt"
    
The R script output is the following two files:
* AllSensorData.txt - the full tidy data set
* AllSensorData_Summarized.txt - a tidy data set where variables are averaged by Activity and Subject codes
