# data_cleaning_project
Repository for the final project on Getting and Cleaning Data Course
The only script that produces the clean data set with the average of each variable for each activity and each subject is runAnalysis.R

It reads the test and train data, as well as the labelmap files to establish relation between the ids and values for certain quantities (subjectID and activityID).

The test and train data is then merged within the script, grouped simultaneously by the subject id and the type of activity, and summarized in terms of mean values for each of the measurements within the group.

The summarized data is then written in a csv file tidy_ds_averaged_values.csv.
