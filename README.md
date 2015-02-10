# Getting-and-Cleaning-Data-Project

The R-script run_analysis.R creates the tidy dataset required for the "Getting and Cleaning Data" course project.

The program requires loading the library dplyr, and placing the R-script in the same directory as the following files:

*X_test.txt
*subject_test.txt
*y_test.txt
*X_train.txt
*subject_train.txt
*y_train.txt
*features.txt



The first three files are used to construct the test data set, and the fourth to sixth files to construct the train data set.
The corresponding instructions in the R-script are:

test.xdata<-read.table("X_test.txt")
test.subject<-read.table("subject_test.txt")
test.ydata<-read.table("y_test.txt")

test.data<-cbind(test.subject,test.ydata,test.xdata)

train.xdata<-read.table("X_train.txt")
train.subject<-read.table("subject_train.txt")
train.ydata<-read.table("y_train.txt")

train.data<-cbind(train.subject,train.ydata,train.xdata)

After the test and train datasets are constructed, they are merged into one data set, all.data

all.data<-rbind(test.data,train.data)

The columns in the data

## add labels to data frame

col.names<-read.table("features.txt")
col.names<-as.character(col.names[,2])
col.names<-c("subject", "activity", col.names)

colnames(all.data)<-col.names

## replace activity codes with activity description
activity.label<-read.table("activity_labels.txt")

for (i in 1:nrow(all.data)){
  all.data$activity[i]<-as.character(activity.label[all.data$activity[i],2])
}

## keep only observations mean and std observations

data.select<-all.data[,grep(("mean\\(\\)|std\\(\\)"),col.names)]
data.select<-cbind(all.data[,1:2], data.select)


# group data
library(dplyr)
data.subject.activity<-group_by(data.select,subject,activity)
mean.subject.activity<-summarise_each(data.subject.activity,funs(mean))

out.file <- "tidydata_project.txt"

if (file.exists(out.file)) file.remove(out.file)
write.table(mean.subject.activity,file="tidydata_project.txt",row.names=F)

