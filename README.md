courseraCleaningData
====================

This is the solution of Getting & Cleaning Data Course Project introduced from Johns Hopkins University
by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD.

The Repo contains run_anlysis.R script which make a tidy dataframe from Human Activity Recognition Using Smart phones Data Set http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

Lets start with the code book of the output
##Code Book of the Output Data Set
activity : "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
subject : identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
the rest variables are the variations of mean() and std() functions for more information please revisit the features_info.txt in original the data set.

Here are the main snippets of code with documentation:

##Reading raw files

```{r}
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
```

##Set the dataframes columns' names to match them when merging

```{r}
colnames(x.train)<- featruesDF$V2
colnames(x.test)<- featruesDF$V2
```

##Merge the train and test data apart and Set names for sucject and y vars

```{r}
# Merge the train and test data apart
trainDF <- cbind(subject.train, y.train, x.train)
testDF <- cbind(subject.test, y.test, x.test)

# Set names for sucject and y vars as they are not listed in features file
colnames(trainDF)[1] <- "subject"
colnames(testDF)[1] <- "subject"
colnames(trainDF)[2] <- "activity"
colnames(testDF)[2] <- "activity"
```

##Merge Train and Test Data and Get the columns that contain mean() and std()

```{r}
data.all <- rbind(trainDF, testDF)

# Get the columns that contain mean() and std() data
data.mean <- data.all[, grep("mean()", colnames(data.all))]
data.std <- data.all[, grep("std()", colnames(data.all))]

# Get the columns that contain subject variable
data.subject <- data.all[, 1]
```

##Restructuring the wanted data and saving it

```{r}
# Restructuring the wanted data 
data.melted <- melt(data.wanted, id = c("subject", "activity"), na.rm = TRUE)
data.tidy <- dcast(data.melted, formula = activity + subject ~ variable)

#writing the tidy data as txt
write.table(data.tidy, file = "data_tidy.txt",row.names = FALSE)
```