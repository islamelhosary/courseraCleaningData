# Global variables
parentPath <- "UCI_HARDataset/"
trainPath <- "train/"
testPath <- "test/"

# Loading Dependancies
if(!require(reshape2)){
  install.packages("reshape2")
}
library(reshape2)

# Start Reading Data #

# Read features
featruesDF <- read.table(file = paste(parentPath,"features.txt",sep = ""))

# Read X Data
x.train <- read.table(file = paste(parentPath,trainPath,"X_train.txt",sep = ""))
x.test <- read.table(file = paste(parentPath,testPath,"X_test.txt",sep = ""))

# Read Y Data
y.train <- read.table(file = paste(parentPath,trainPath,"y_train.txt",sep = ""))
y.test <- read.table(file = paste(parentPath,testPath,"y_test.txt",sep = ""))

# Read Subject Data
subject.train <- read.table(file = paste(parentPath,trainPath,"subject_train.txt",sep = ""))
subject.test <- read.table(file = paste(parentPath,testPath,"subject_test.txt",sep = ""))

#  End Reading Data  #

# Set the dataframes columns' names to match them when merging
colnames(x.train)<- featruesDF$V2
colnames(x.test)<- featruesDF$V2

# Merge the train and test data apart
trainDF <- cbind(subject.train, y.train, x.train)
testDF <- cbind(subject.test, y.test, x.test)

# Set names for sucject and y vars as they are not listed in features file
colnames(trainDF)[1] <- "subject"
colnames(testDF)[1] <- "subject"
colnames(trainDF)[2] <- "activity"
colnames(testDF)[2] <- "activity"

# Merge Train and Test Data into one Dataframe
data.all <- rbind(trainDF, testDF)

# Get the columns that contain mean() and std() data
data.mean <- data.all[, grep("mean()", colnames(data.all))]
data.std <- data.all[, grep("std()", colnames(data.all))]

# Get the columns that contain subject variable
data.subject <- data.all[, 1]
	
# Factoring the activities and set levels
activityTbl <- read.table(paste(parentPath,"activity_labels.txt",sep = ""))
data.activites <- factor(data.all$activity, labels=activityTbl$V2)
data.wanted <- cbind(data.subject, data.activites, data.mean, data.std)

# Set columns' names of subject and activity
colnames(data.wanted)[1:2] <- c("subject", "activity")

# Restructuring the wanted data 
data.melted <- melt(data.wanted, id = c("subject", "activity"), na.rm = TRUE,measure.vars = names(data.wanted)[3:81])
data.tidy <- dcast(data.melted, formula = activity + subject ~ variable, mean)

#writing the tidy data as txt
write.table(data.tidy, file = "data_tidy.txt",row.names = FALSE)