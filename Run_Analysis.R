#1.Merges the training and the test sets to ceate one data set.
setwd("set your own work directory")
library(dplyr)
#Read data
train_data=read.table("train/X_train.txt")
train_label=read.table("train/y_train.txt")
train_subject=read.table("train/subject_train.txt")
test_data=read.table("test/X_test.txt")
test_label=read.table("test/y_test.txt")
test_subject=read.table("test/subject_test.txt")

bind_data=rbind(train_data,test_data)
bind_label=rbind(train_label,test_label)
bind_subject=rbind(train_subject,test_subject)
#Haha
#2.Extracts only the measurements on the mean and standard deviation
#for each measurement.
data_feature=read.table("features.txt")
pattern="mean\\(\\)|std\\(\\)"
indices=grep(pattern,data_feature[,2])
bind_data=bind_data[,indices]
#The following is relevant to step 4, for convenicne, we did it here
names(bind_data)=gsub("\\(\\)","",data_feature[indices,2])

#3.Use descriptive activity names to name the activities in the data set
act=read.table("activity_labels.txt")
bind_label[,1]=act[bind_label[,1],2]
bind_label = bind_label %>% rename(Activity = V1)

#4.Appropriately labels the data set with descriptive variable names.
bind_subject = bind_subject %>% rename(Subject = V1)
clean_data=cbind(bind_subject,bind_label,bind_data)
write.table(clean_data,"clean_data.txt", row.names = FALSE)
#print(object.size(clean_data),units = "Mb")

#5.From the data set in step 4, create a second independent tidy data 
#set with the average of each variable for each activity and each
#subject.
mean_data = clean_data %>% group_by(Subject,Activity) %>% summarize_all(funs(mean(., na.rm = TRUE)))
write.table(mean_data,"mean_data.txt", row.names = FALSE)
#print(object.size(test_data),units = "Mb")