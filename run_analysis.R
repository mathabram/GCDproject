  library(data.table)
  library(plyr)
  library(reshape2)
  
  # read the TEST files
  dataSubject <- read.table("./test/subject_test.txt", col.names = c("sKey"), 
                            colClasses = "integer", header = FALSE)
  dataY <- read.table("./test/y_test.txt", col.names = c("yKey"), colClasses = "factor", header = FALSE)
  dataX <- read.fwf("./test/X_test.txt", colClasses = "numeric", header = FALSE)
  dataTest <- cbind(dataSubject, dataY, dataX)
     
  # read the TRAINING files
  dataSubject <- read.table("./train/subject_train.txt", col.names = c("sKey"), 
                            colClasses = "integer", header = FALSE)
  dataY <- read.table("./train/y_train.txt", col.names = c("yKey"), colClasses = "factor", header = FALSE)
  dataX <- read.fwf("./train/X_train.txt", colClasses = "numeric", header = FALSE)
  dataTraining <- cbind(dataSubject, dataY, dataX)

  # Combine the test and training datasets
  dataFull <- rbind(dataTraining, dataTest)
  
  #################### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  
  # Read the list of 561 feature names from the features file
  dataFeatures <- read.table("./features.txt", col.names = c("fKey","fName"), 
                             colClasses = c("factor","character"), header = FALSE, sep = " ")
  # Label the 561 feature columns in the combined test+training dataset (total 563 columns) 
  # with these 561 feature names 
  dataXnames <- dataFeatures$fName
  colnames(dataFull) <- c("sKey", "yKey", dataXnames)
  
  # Search through the names for "mean" and "std" and build a list of only those names
  Names <- cbind(names(dataFull))
  dataNames <- data.frame(Names)
  dataNames$subset <- grepl("-mean", dataNames$Names) | grepl("-std", dataNames$Names)
  
  # Select only the "mean" and "std" feature columns (total 79) from the combined test+training dataset, 
  # but also include the subject (sKey) and activity (yKey) columns as well
  dataNames$subset[1:2] <- TRUE
  dataFull <- dataFull[,dataNames$subset]
  
  # Read the activity labels file to get the name of each activity 
  dataYnames <- read.table("./activity_labels.txt", col.names = c("yKey","yName"), colClasses = c("factor","factor"), header = FALSE, sep = " ")
  
  # Using merge, add the activity name along with the activity id for each row in the combined test+training dataset
  dataMerged <- merge(dataYnames, dataFull, all=TRUE)
  # Select the subject (skey), activity name (yName), and the 79 "mean" and "std" feature column measure values
  dataFinal <- dataMerged[, c(3,2,4:82)]

  # Reshape the data using MELT to store each of the 79 mean and std measures (columns 3 to 81) 
  # in separate records for every combination of subject + activity (columns 1 and 2)
  finalNames <- names(dataFinal)
  dataFinalMelted <- melt(dataFinal, id=finalNames[1:2], measure.vars=finalNames[3:81])
  
  # Calculate the average of each of the 79 measures (variables) for each subject (sKey) + activity (yName)
  dataReady <- dcast(dataFinalMelted, sKey + yName ~ variable, mean)
  dataReady <- arrange(dataReady, sKey, yName)
  
  # Write the data to a file
  write.table(dataReady, "dataReady.txt", row.names = FALSE, quote = FALSE, sep=",")
   