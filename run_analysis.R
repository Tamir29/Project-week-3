#Seting the current working directory
#currentDir<-getwd()
#setwd(paste(currentDir,"/ProjectWeek3",sep=""))
setwd("C:\\Users\\Tamir\\Google Drive\\Getting and Cleaning Data\\project\\UCI HAR Dataset")

#Calling the 'test' files into a data frame each 
xTest<-read.table("./test//X_test.txt", sep="")
subjectsTest<-read.table("./test//subject_test.txt", sep="")
activitiesTest<-read.table("./test//y_test.txt", sep="")
names(subjectsTest) <- "Subjects"	
names(activitiesTest) <- "Activity"

#test<-cbind(subjectsTest,activitiesTest,xTest)

#Calling the 'train' files into a data frame each 
xTrain<-read.table("./train//X_train.txt", sep="")
subjectsTrain<-read.table("./train//subject_train.txt", sep="")
activitiesTrain<-read.table("./train//y_train.txt", sep="")
names(subjectsTrain) <- "Subjects"	
names(activitiesTrain) <- "Activity"	


#train<-cbind(subjectsTrain,activitiesTrain,xTrain)

#Binding the 'test' and 'train' sets
xData<-rbind(xTrain,xTest)
allSubjects<-rbind(subjectsTrain,subjectsTest)
allActivities<-rbind(activitiesTrain,activitiesTest)


#preparing the titles for the header row for xData
features<-read.table("features.txt", sep="")
features<-features[,-1] #removing the first column (1,2,3,...)
featureHeader<-as.character(features) #Converting the data frame into a character vector

#Assigning the names to the combined xData frame
names(xData) <- featureHeader	

#Extracting only the measurements on the mean and standard deviation for each measurement
onlyMeanStd<-xData[,grepl("mean|std",names(xData))]


#Adding the two columns of 'Subjects' and 'Activities'
data<-cbind(allSubjects,allActivities,onlyMeanStd)


#Creating the descriptive activities character vector
activities<-read.table("activity_labels.txt", sep="")
activities<-activities[,-1]	#removing the first column (1,2,3,...)
activitiesLabels<-as.character(activities) #Converting the data frame into a character vector

#Use descriptive activity names to name the activities in the data set.
#Changing the numeric values with the descriptive names respectively
data$Activity[data$Activity==1]<-activitiesLabels[1]
data$Activity[data$Activity==2]<-activitiesLabels[2]
data$Activity[data$Activity==3]<-activitiesLabels[3]
data$Activity[data$Activity==4]<-activitiesLabels[4]
data$Activity[data$Activity==5]<-activitiesLabels[5]
data$Activity[data$Activity==6]<-activitiesLabels[6]

#Appropriately labels the data set with descriptive variable names. 
#Replacing unclear accronyms with meaningful names
names(data) <- gsub("Acc", "Accelerator", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))


#creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject
library(data.table)
dt <- data.table(data)
tidyData <- dt[, lapply(.SD, mean), by = 'Subjects,Activity']
write.table(tidyData, file = "tidyDataSet.txt", row.names = FALSE)