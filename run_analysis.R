##### Libraries #####
library(dplyr)
library(tidyr)

##### Working Directory #####
setwd('~/Documents/Coursera/Getting and Cleaning Data')

##### Folder Initialization and File Download #####
if(!file.exists('./data')){dir.create('./data')}
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if(!file.exists('./data/Dataset.zip')) { download.file(
  fileUrl, destfile = './data/Dataset.zip', method = 'curl')
}
unzipped <- unzip('./data/Dataset.zip')
# cleanup
rm(fileUrl)

##### Dataframe Initialization #####
train_index <- grep('X_train', unzipped); test_index <- grep('X_test', unzipped)
train <- read.table(unzipped[train_index]); test <- read.table(unzipped[test_index])
train <- tbl_df(train); test <- tbl_df(test)
# cleanup
rm(train_index, test_index)

##### 1. Merging the training and the test sets #####
# Test that all names are in the same order and match: sum(!(names(test) == names(train)) gives 0
merged <- rbind_list(train, test)
# cleanup
rm(train, test)
merged <- tbl_df(merged)
head(merged)

##### 2. Extract only mean and standard deviation from each observation ##### AND
##### 4. Appropriately label the data set with descriptive variable names.  #####
# Roadmap
# 1. Open file features.txt to check how "mean" and "standard deviation" are coded
# 2. Load features into a dataframe
# 3. Keep only feature names that contain "mean" or "standard deviation" (as coded in 1.)
# 4. Keep the corresponding columns of the dataframe
keep_names <- 'mean()|std()'
features_index <- grep('features.txt', unzipped)
features <- read.table(unzipped[features_index]); features <- tbl_df(features)
features <- filter(features, grepl(keep_names, features$V2))

names(merged) <- extract_numeric(names(merged))
merged <- select(merged, features$V1)
names(merged) <- features$V2
head(names(merged))

##### 3. Use descriptive activity names to name the activities in the data set #####
# 1. Gather labels
# 2. Replace numbers with activity labels 
# 3. Insert activity labels into the dataset
activity_train_file <- grep('/y_train', unzipped); activity_test_file <- grep('/y_test', unzipped)
activity_train <- read.table(unzipped[activity_train_file]); activity_test <- read.table(unzipped[activity_test_file])
activities <- rbind_list(activity_train, activity_test);  activities <- tbl_df(activities)
colnames(activities) <- "Activity"
activity_labels <- read.table(unzipped[grep('activity_labels',unzipped)]); activity_labels <- tbl_df(activity_labels)
colnames(activity_labels)[1] <- "Activity"
merged <- bind_cols(merged, activities)
merged <- tbl_df(merged)
merged <- left_join(merged, activity_labels)
merged$Activity <- NULL
merged <- rename(merged, Activity = V2)
rm(activity_train_file, activity_test_file)
head(merged$Activity)

##### 5. From the data set in step 4, create a second, 
##### independent tidy data set with the average of each variable for each activity and each subject. #####
# First, gather the subjects and add them to the merged dataframe
subject_train_idx <- grep('/subject_train', unzipped); subject_test_idx <- grep('/subject_test', unzipped)
subject_train <- read.table(unzipped[subject_train_idx]); subject_test <- read.table(unzipped[subject_test_idx])
subjects <- rbind_list(subject_train, subject_test); subjects <- tbl_df(subjects)
colnames(subjects) <- 'SubjectID'
merged <- bind_cols(merged, subjects)
# make the new dataframe with summary statistics
grouped_data <- group_by(merged, Activity, SubjectID)
tidy_data <- summarise_each(grouped_data, funs(mean)) # <-- final clean dataset
head(tidy_data)
write.csv(tidy_data, './tidy_data.csv')
write.csv(merged, './merged.csv')
