# GCDproject

## Variables 

* sKey  Identifies each subject
* yKey  Identifies each activity 


## Datasets

* dataTraining Training dataset consisting of subjects, activities, and feature data
* dataTest Test dataset consisting of subjects, activities, and feature data
* dataFull Combined training and test dataset consisting of subjects, activities, and feature data
* dataFeatures List of feature names from features.txt
* dataNames Column names of the dataFull dataset
* dataYnames List of activity names from activity_labels.txt
* dataMerged Merged dataset containing activity name along with the dataFull dataset
* dataFinal Dataset with only the 79 mean and std names, the subject, and the activity
* finalNames Column names of the dataFinal dataset

## Summarized and Transformed Datasets

* dataFinalMelted Transformed dataset that stores each observation of each mean and std feature measure variable as a separate row
* dataTidy Transformed dataset containing the average of observations of each mean and std feature measure variable for a given subject + activity

## Transformations applied

* Combined the subject file, activity file, and main data using CBIND.
* Combined the test and training datasets using RBIND.
* Selected only the mean and standard deviation columns by applying subsetting operations.
* Merged the actiivity names into the dataset using MERGE.
* Reshaped the data into a key-value-pair format using MELT.
* Reshaped the data back into each measure variable as a column after finding the average values using DCAST with MEAN. 
  