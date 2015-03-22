# Getting and Cleaning Data Course Project
# Matt Henn

# get and unzip data
library(plyr)
library(dplyr)
library(data.table)

address <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
address <- sub("^https", "http", address)
if(!file.exists("tempdir")) {
  dir.create("tempdir") }
download.file(address, destfile = "./tempdir/datfile.zip",  method = "curl")
dat <- unzip("./tempdir/datfile.zip", exdir = "./tempdir")

# get the data of interest to this assignment
test <- list.files("./tempdir/UCI HAR Dataset/test",
                   pattern = "*.txt", 
                   full.names = TRUE)
testdat <- lapply(test, read.table)

train <- list.files("./tempdir/UCI HAR Dataset/train",
                    pattern = "*.txt",
                    full.names = TRUE)
traindat <- lapply(train, read.table)


# start combining the data

alltestdat <- cbind.data.frame(subject_test = testdat[1], test_label = testdat[3], testdat[2])                               
alltraindata <- cbind.data.frame(traindat[1], traindat[3], traindat[2])

ldat <- list(alltestdat, alltraindata)
            
alldat <- as.data.frame(rbindlist(ldat, use.names = FALSE, fill = FALSE))

# read in features.txt to get list of features to use as colnames
label <- read.table(
  "./tempdir/UCI HAR Dataset/features.txt", 
  colClasses = "character")

labels <- rbind("subject_test", "test_label", label)
names(alldat) <- c(labels$V2)
labs <- grep("mean|std", labels$V2, value = TRUE)

# extract only measurements that are measuring a mean or stdev. 
alldat1 <- cbind.data.frame(alldat[1], alldat[2], alldat[grep("mean|std", labels$V2, value = TRUE)])


# replace test_label with activity name
actdat <- alldat1$test_label

a1 <- replace(actdat, actdat == 1, "WALKING")
a2 <- replace(a1, a1 ==2, "WALKING_UPSTAIRS")
a3 <- replace(a2, a2 == 3, "WALKING_DOWNSTAIRS")
a4 <- replace(a3, a3 == 4, "SITTING")
a5 <- replace(a4, a4 == 5, "STANDING")
a6 <- replace(a5, a5 == 6, "LAYING")

alldat1$test_label <- a6 # yep, it's ghetto but it worked. easier way to do this?


# last step
# table of means of each test by each subject by each activity

fd <- as.data.frame(aggregate(alldat1, list(alldat1[,1], alldat1[,2]), mean))

#clean it up a bit
fd$test_label <- fd$Group.2
fd <- fd[,3:83]

write.table(fd, "tidydat.txt", row.name = FALSE)

# done. fd is a tidy dataset. 


