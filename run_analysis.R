require(plyr)
library(dplyr)
library(lubridate)
library(tidyr)

# Reading the activity String-Integer map:
activity_list <- tbl_df(read.table("../UCI HAR Dataset/activity_labels.txt",
                                   col.names=c("activityID","activityTitle"), stringsAsFactors=FALSE))
# Make a function that converts the ID of activity to its label
map_activity <- function(x) {activity_list$activityTitle[x == activity_list$activityID] }


# Reading the feature list and grep the -mean() and -std() only;
# We find the indices of the columns, so that we read only those columns
feature_list <- tbl_df(read.table("../UCI HAR Dataset/features.txt",col.names=c("featureID","featureTitle")))
inds_feature <- grep("*-(mean|std)\\(",feature_list$featureTitle)
 ########### ############### ################# ################## ##################### #################### ##
# Reading training set, only the columns with mean or std
#train_set <- tbl_df(read.table("../UCI HAR Dataset/train/x_train_small.txt")[,inds_feature])
train_set <- tbl_df(read.table("../UCI HAR Dataset/train/X_train.txt")[,inds_feature])
# Set the column names to the measured values: delete dashes and brackets, sub "_" instead
colnames(train_set) <- gsub("-|\\(|\\)","_",feature_list$featureTitle[inds_feature])
# Check for double "__"
colnames(train_set) <- gsub("__","",colnames(train_set))
# Read the training set and label values; the nrow(train_set) argument is used for debugging
# Debugging was done on a small subsets of test and train sets
train_set_label <- read.table("../UCI HAR Dataset/train/y_train.txt")
train_set_subject <- read.table("../UCI HAR Dataset/train/subject_train.txt")
# Add the activity label and subjectID columns to the dataset, bring them to the left
train_set<- train_set %>% 
  mutate(activityDesc = sapply(train_set_label$V1,map_activity)) %>%
  mutate(subjectID = train_set_subject$V1) %>%
  select(activityDesc,subjectID,everything())
print(" Training set has been processed successfully, moving on to test set...")
########### ############### ################# ################## ##################### #################### ##
# Reading test set, only columns with mean and std values
#set.seed(120)
#tmp_ids = sample(1:500,40);
#test_set <- tbl_df(read.table("../UCI HAR Dataset/test/X_test.txt")[tmp_ids,inds_feature])
test_set <- tbl_df(read.table("../UCI HAR Dataset/test/X_test.txt")[,inds_feature])
# Set the column names to the measured values, delete unnecessary dashes and brackets
colnames(test_set) <- gsub("-|\\(|\\)","_",feature_list$featureTitle[inds_feature])
colnames(test_set) <- gsub("__","",colnames(test_set))

test_set_label <- read.table("../UCI HAR Dataset/test/y_test.txt")
test_set_subject <- read.table("../UCI HAR Dataset/test/subject_test.txt")

#test_set_label <- read.csv("../UCI HAR Dataset/test/y_test.txt")[tmp_ids,]
#test_set_subject <- read.csv("../UCI HAR Dataset/test/subject_test.txt")[tmp_ids,]
# Add the activity label and subjectID columns to the dataset, bring them to the left
test_set<- test_set %>% 
  mutate(activityDesc = sapply(test_set_label$V1,map_activity)) %>%
  mutate(subjectID = test_set_subject$V1) %>%
  select(activityDesc,subjectID,everything())

print(" Test set has been processed successfully, moving on to merging...")

########### ############### ################# ################## ##################### #################### ##
# Merge datasets by binding one to the bottom of the other:
total_set <- rbind(train_set,test_set)
#rm("test_set","train_set","train_set_subject","train_set_label","test_set_subject","test_set_label")
# Group by activity and the subject ID
avg_per_group <-total_set %>% group_by(subjectID,activityDesc) %>%
   mutate(n_obs = n())  %>%  # Calculate how many observations are in each group
   select(n_obs,everything())  %>% # Move that column to the left for clarity
   summarise_each(funs(mean))  %>% # Average each column for each group
   arrange(subjectID)# Sort by the subjectID for clarity

write.table(avg_per_group, file = "./tidy_ds_average_values.txt", row.name=FALSE)
print(" Tidy dataset has been written on HDD...")
