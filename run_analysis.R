
args <- commandArgs(TRUE)
outFile <- args[1]

## reading in training and testing data:
x_train <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\Y_train.txt")
subject_train <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt")

x_test <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\Y_test.txt")
subject_test <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")

## concatenate training and testing data into one:
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
names(y) <- "activityCode"
subject <- rbind(subject_train, subject_test)
names(subject) <- "subject"

## get feature number for the mean() and std() values:
features <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt")
mean_std_index <- which(apply(features, 1, function(x) any(grep("mean\\(\\)|std\\(\\)", x))))
x <- x[,mean_std_index]
names(x) <- features[mean_std_index,"V2"]

## combine x,y,subject into one dataframe:
df <- cbind(subject, y, x)

## convert activity codes to activity names:
activity <- read.table("getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt", col.names=c("code","activity"))
df1 <- merge(df, activity, by.x = "activityCode", by.y = "code")
df2 <- df1[,c(2,69,3:68)]

## group by "subject" and "activity":
out <- aggregate(. ~ subject + activity, df2, mean)
write.table(out, file = outFile, quote=F, sep="\t", row.names=F)
