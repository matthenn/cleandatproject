# Getting and Cleaning Data Course Project
# Matt Henn

# get and unzip data
library(plyr)
library(dplyr)
library(data.table)

address <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
address <- sub("^https", "http", address)
td <- dir.create("td")

dat <- download.file(address, destfile = "./td",  method = "curl")

list.files(dat)




datfile <- "/Users/Matt/current classes/coursera dssp/cleaning data/project/getdata_projectfiles_UCI HAR Dataset.zip"
dat <- unzip(datfile)

# read in the test and train data files
setwd("/Users/Matt/current classes/coursera dssp/cleaning data/project/UCI HAR Dataset/test")

testdat <- list.files(path = 
         "/Users/Matt/current classes/coursera dssp/cleaning data/project/UCI HAR Dataset/test")

testdata <- lapply(testdat[2:4], read.table)

alltestdat <- cbind.data.frame(subject_test = testdata[1], test_label = testdata[3], testdata[2])
                               


setwd("/Users/Matt/current classes/coursera dssp/cleaning data/project/UCI HAR Dataset/train")

traindat <- list.files(path = 
      "/Users/Matt/current classes/coursera dssp/cleaning data/project/UCI HAR Dataset/train")

traindata <- sapply(traindat[2:4], read.table)

alltraindata <- cbind.data.frame(traindata[1], traindata[3], traindata[2])

ldat <- list(alltestdat, alltraindata)
            
alldat <- as.data.frame(rbindlist(ldat, use.names = FALSE, fill = FALSE))

# read in features.txt to get list of features to use as colnames

label <- read.table(
  "/Users/Matt/current classes/coursera dssp/cleaning data/project/UCI HAR Dataset/features.txt", 
  colClasses = "character")

labels <- rbind("subject_test", "test_label", label)

names(alldat) <- c(labels$V2)

labs <- grep("mean|std", labels$V2, value = TRUE)

# extract only measurements that are measuring a mean or stdev. 
alldat1 <- cbind.data.frame(alldat[1], alldat[2], alldat[grep("mean|std", labels$V2, value = TRUE)])



# replace test_label with activity name
# yep, it's ghetto but it worked. easier way to do this?
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
write.table(fd, "tidydat", row.name = FALSE)

# done. fd is a tidy dataset. 


