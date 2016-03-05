# Cookbook for the final project in Getting and Cleaning Data Course

Here I describe the succession of steps leading to the clean dataset .
The workflow implemented in run_analysis.R is as follows:


1. Load the activity label(char) -- id(int) map (activity_label.txt)

2. Create a temporary function "map_activity" that assigns the activity label as a char to the given number if found in the id-s list

3. Read the feature list with their ids, corresponding to a column number in the training/test dataset.

4. Select only those features that describe SD or mean of data measurements for measured quantities.

5. Read the training dataset, keep only the columns that correspond to the selected features.

6. Read the training activity and subject labels ("trainsetlabel" and "trainsetsubject"), put labels on the activity and add both columns to the train_set (subjectID and activityDesc, respectively).

7. Repeat 5-6 applied to the test set data.

8. Combine "testset" and "trainset" into "totalset".

9. Group the total_set by unique values in "subjectID" and "activityDesc"

10. Add n_obs column showing the number of observations in each column

11. Using summarize_each function from dplyr I find mean values for each of the quantities for each of the groups.

