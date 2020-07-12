# uses package reshape2 to  melt and cast the data variables
library(reshape2) 
# uses dplyr to write table
library(dplyr)

#test and train files locations used, using relative paths

testfile <- "./UCI HAR Dataset/test/x_test.txt"
testactivitiesfile <- "./UCI HAR Dataset/test/y_test.txt"
testsubjectsfile <- "./UCI HAR Dataset/test/subject_test.txt"
trainfile <- "./UCI HAR Dataset/train/x_train.txt"
trainactivitiesfile <- "./UCI HAR Dataset/train/y_train.txt"
trainsubjectsfile <- "./UCI HAR Dataset/train/subject_train.txt"

#general files locations used, using relative paths

activitylabelsfile <- "./UCI HAR Dataset/activity_labels.txt"
featuresfile <- "./UCI HAR Dataset/features.txt"
outputfile <- "./tidyResult.txt"



# function that is used to get both test and train tables, with respective 
# subjects ans activities, with proper names

sub_createtable <- function (datafile,activitiesfile,subjectsfile){
        
        #read the data table, subjects table and activities table (from test or train)
        #also reads the general features file
        
        data <- read.table(datafile)  
        subjects <- read.table(subjectsfile)
        activities <- read.table(activitiesfile)
        features <- read.table(featuresfile)
        
        
        #use the features table to name the data table
        #also names the subjects and activities table for future bind
        
        names(data) <- features$V2
        names(subjects) <- c("subject")
        names(activities) <- c("activity")
        
        #binds all tables
        
        data <- cbind(data,subjects,activities)
        
        #return named and binded table
        data
        
}


# STEP 1 (exactly as suggested on Project Instructions )
# Merges the training and the test sets to create one data set

mergetrainingtestfiles <- function (test, train){
        
        #binds test and train tables
        rbind (test, train)
}


# STEP 2 (exactly as suggested on Project Instructions )
# Extracts only the measurements on the mean and standard deviation for each measurement

extractmeanstandart <- function (data){
        
        # uses a grep to get the table names that contains the words 'mean' or 'std'
        # preserving activity and subject columns
        # note that meanFreq will not be considered intentionally 
        
        data[,grep("(mean\\(\\))|(std\\(\\))|(activity)|(subject)",names(data))]  
}


# STEP 3 (exactly as suggested on Project Instructions )
# Uses descriptive activity names to name the activities in the data set

renameactivities <- function (data){
        activitieslabel <- read.table(activitylabelsfile)
        
        #create a factor to the variable activity
        data$activity <- factor(data$activity,levels=activitieslabel$V1,labels = activitieslabel$V2)      
        
        #return data
        data
}

# STEP 4 (exactly as suggested on Project Instructions )
# Appropriately labels the data set with descriptive variable names

renamevariables <- function (data){
        
        #some modifications, treating names to make them more readable
        
        names(data) <- sub("^f","fourier",names(data))     
        names(data) <- sub("^t","time",names(data)) 
        names(data) <- sub("Acc","Acceleration",names(data)) 
        names(data) <- gsub("[\\(\\)\\-]","",names(data)) 
        names(data) <- sub("mean","Mean",names(data)) 
        names(data) <- sub("std","STD",names(data)) 
        
        
        # return data
        data
}

# STEP 5 (exactly as suggested on Project Instructions )
# From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable
#for each activity and each subject.

createtidymean <- function(data){
        
        #RESHAPING TABLE
        
        #melts data table 
        
        data <- melt(data, id.vars=c("subject","activity"))
        
        
        #casts the melted data by subject and activity  
        
        data <- dcast(data, subject+activity ~ variable , mean)
        
        
        data
}


# writes data into the output file

writetidydata <- function (data){
       
        #write data into the output file
        write.table(data, file=outputfile, row.name=FALSE)
}


# main function, executes all steps as a pipeline, the result is a file
# containing a tidy data set with the average of each variable for each 
# activity and each subject. 

createtidy <- function (){
       
        #creates test and train data from files
        testdata <- sub_createtable(testfile,testactivitiesfile,testsubjectsfile)
        traindata <- sub_createtable(trainfile,trainactivitiesfile,trainsubjectsfile)
        
        #creates a pipeline using the steps suggested on the instructions
        #using train and test data
        mergetrainingtestfiles(traindata,testdata) %>%
                extractmeanstandart() %>%
                        renameactivities() %>%
                                renamevariables() %>%
                                        createtidymean() %>%
                                                writetidydata()     
}
