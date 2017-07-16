

# get all activity labels and features
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
actLabels[,2] <- as.character(actLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# get only the data on mean and sd
featuresReq <- grep(".*mean.*|.*std.*", features[,2])
featuresReq.names <- features[featuresReq,2]
featuresReq.names = gsub('-mean', 'Mean', featuresReq.names)
featuresReq.names = gsub('-std', 'Std', featuresReq.names)
featuresReq.names <- gsub('[-()]', '', featuresReq.names)



# get the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresReq]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)


test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresReq]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# combine ds and add labels
fullData <- rbind(train, test)
colnames(fullData) <- c("subject", "activity", featuresReq.names)

# turn activities & subjects into factors
fullData$activity <- factor(fullData$activity, levels = actLabels[,1], labels = actLabels[,2])
fullData$subject <- as.factor(fullData$subject)

fullData.melted <- melt(fullData, id = c("subject", "activity"))
fullData.mean <- dcast(fullData.melted, subject + activity ~ variable, mean)

write.table(fullData.mean, "tidydata.txt", row.names = FALSE, quote = FALSE)