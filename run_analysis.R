library(dplyr)
library(lubridate)
library(tidyr)
train_set <- read.table("../UCI HAR Dataset/train/x_train_small.txt")
train_set_label <- read.csv("../UCI HAR Dataset/train/y_train.txt")[1:nrow(train_set),]

test_set <- read.table("../UCI HAR Dataset/test/x_test_small.txt")
test_set_label <- read.csv("../UCI HAR Dataset/test/y_test.txt")[1:nrow(test_set),]

