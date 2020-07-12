# Getting and Cleaning Data Course Project

Description of the R file that contains scripts that follows the Data Course Project instructions to create a tidy dataset from raw data

# Functions on run_analysis.R

### Files
All files are first defined as variables, using relative paths to the directory UCI HAR Dataset. They are:

* testfile            -  Test files
* testactivitiesfile
* testsubjectsfile
* trainfile           -  Train files 
* trainactivitiesfile
* trainsubjectsfile

* activitylabelsfile  - general file containing the activity labels
* featuresfile        - general file containing all features 
* outputfile          - The tidy dataset result file (tidyResult.txt)


### createtidy() - Main function

Creates test and train data from files using function sub_createtable(datafile,activitiesfile,subjectsfile). This function uses read.table to read the data table, subjects table and activities table from test or train files. Also reads the general features file. 

Then it mounts a pipeline using the steps suggested on the instructions, 
using train and test data loaded from files. A function for each step, following the pipeline:

     **STEP1 %>% STEP2 %>% STEP3 %>% STEP4 %>% STEP5 %>% write output file**

### STEP 1 - mergetrainingtestfiles(traindata,testdata)

Merges the training and the test sets to create one data set, using rbind function

### STEP 2 - extractmeanstandart(data)

Extracts only the measurements on the mean and standard deviation for each measurement.

Uses a grep to get the table names that contains the words 'mean' or 'std' preserving activity and subject columns.

Note that meanFreq will not be considered intentionally 

### STEP 3 - renameactivities(data) 
Uses descriptive activity names to name the activities in the data set.
Creates a factor from activitylabelsfile to the column activity.


### STEP 4 - renamevariables(data)
Appropriately labels the data set with descriptive variable names.

Perform some modifications, treating column names to make them more readable


### STEP 5 - createtidymean(data)
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Using reshape2 package, reshapes table. First melts data using as ids columns subject and activity, other columns are considered variables.

Then casts the melted data by subject and activity.  

### writetidydata()  
Writes txt file with dplyr write.table (using row.name=FALSE, as instructed)