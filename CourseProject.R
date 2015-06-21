###################################################################################
#             Getting and Cleaning Data (Johns Hopkins University)                # 
#                             Course Project                                      #
###################################################################################

#Setting Working Directory
setwd("E:/MOOC/Coursera - Getting and Cleaning Data (Johns Hopkins University)/Course Project/wd")

#Loading all Data from text (train, test and references)

#References
features <- read.table("features.txt", quote="\"", stringsAsFactors=FALSE)
activity_labels <- read.table("activity_labels.txt", quote="\"")

#Training
subject_train <- read.table("subject_train.txt", quote="\"")
X_train <- read.table("X_train.txt", quote="\"")
y_train <- read.table("y_train.txt", quote="\"")

#Testing
subject_test <- read.table("subject_test.txt", quote="\"")
X_test <- read.table("X_test.txt", quote="\"")
y_test <- read.table("y_test.txt", quote="\"")


#Mergind Test and Train and removing not necessary dataframe
subject = rbind(subject_train,subject_test)
rm(subject_train)
rm(subject_test)
measures = rbind(X_train,X_test)
rm(X_train)
rm(X_test)
activity = rbind(y_train,y_test)
rm(y_train)
rm(y_test)

#Filtering Variable for mean and standard deviation
meanStdRef = features[grepl("mean",features$V2)|grepl("std",features$V2), ]

#Filter for variable
meanStd=measures[meanStdRef$V1]

#Rename columns
names(meanStd)[names(meanStd)==paste0("V",meanStdRef$V1)] <- meanStdRef$V2

#Putting it all together
names(subject)[1] <- "Subject"
names(activity)[1] <- "Activity"
AllData=cbind(subject,activity)

AllData = merge(AllData,activity_labels, by.x="Activity", by.y="V1", all.x=TRUE)
names(AllData)[3] <- "ActivityLabel"

AllData = cbind(AllData,meanStd)

#Makes names a R standard
colnames(AllData) = make.names(colnames(AllData))

#Make it more pretty
colnames(AllData) = gsub("\\.+",".",colnames(AllData))



#Question 5 ... mean of all variable

meanAllData = aggregate(. ~ Activity+Subject+ActivityLabel, AllData, mean)


write.table(meanAllData,"meanAllData",row.names=FALSE)
