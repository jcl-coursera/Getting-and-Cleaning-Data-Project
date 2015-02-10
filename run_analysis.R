## run_analysis.R

## read test data
#   create data frame where:
#      first column: subject id
#      second column: activity
#      third column and so on: features


test.xdata<-read.table("X_test.txt")
test.subject<-read.table("subject_test.txt")
test.ydata<-read.table("y_test.txt")

test.data<-cbind(test.subject,test.ydata,test.xdata)
rm(test.xdata,test.subject,test.ydata)

## read train data
#   create data frame where:
#      first column: subject id
#      second column: activity
#      third column and so on: features

train.xdata<-read.table("X_train.txt")
train.subject<-read.table("subject_train.txt")
train.ydata<-read.table("y_train.txt")

train.data<-cbind(train.subject,train.ydata,train.xdata)
rm(train.xdata,train.subject,train.ydata)



## bind test.data and train.data data frames

all.data<-rbind(test.data,train.data)

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

