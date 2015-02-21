# Build a tidy dataset from the data.
# Load dataset
# merge datasets
# Reduce columns to mean and standard deviation
# lable dataset
# summarize dataset by mean on Subject and Activity

# Expect program to be run from data directory.  
setwd("C:/R Class/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
x_test <- read.table("./test/X_test.txt", quote="\"")
x_train <- read.table("./train/X_train.txt", quote="\"")
comp_set <-rbind(x_test,x_train)
y_test <- read.table("./test/y_test.txt", quote="\"")
y_train <- read.table("./train/y_train.txt", quote="\"")
activity_set<-rbind(y_test,y_train)
names(activity_set)<-'Activity_id'
features <- read.table("./features.txt", quote="\"")
# gather columns with mean and std in description.
# defined as -mean() and -std()
colset<-features[grepl('-mean()',features$V2,fixed=TRUE) | grepl('-std()',features$V2),]
std_mean_set<-comp_set[,unlist(colset[1])]
colnames<-data.frame(lapply(colset, as.character), stringsAsFactors=FALSE)
names(std_mean_set)<-colnames[,2]
#Pull in subject_test.txt for userid. 
subject_test <- read.table("./test/subject_test.txt", quote="\"")
subject_train <- read.table("./train/subject_train.txt", quote="\"")
activity_lable<- read.table("./activity_labels.txt", quote="\"")
sub<-rbind(subject_test,subject_train)
names(sub)<-'Subject_id'
labeled_set<-cbind(sub,activity_set,std_mean_set)

#################### Wide answer ####################################
Primary_Key <- c("Subject_id","Activity_id")
Cols_to_colapse <- names(labeled_set)[3:length(labeled_set)]
wide_set <-aggregate(labeled_set[Cols_to_colapse],by=labeled_set[Primary_Key],FUN=mean)
# Label activities with values not id's
wide_set$Activity_id<-activity_lable$V2[match(wide_set$Activity_id, activity_lable$V1)]
# Rename Activity_id to Activity
names(wide_set)[names(wide_set)=="Activity_id"] <- "Activity"
# sort by subject, activity
wide_set<-wide_set[with(wide_set, order(Subject_id,Activity)), ]
write.table(wide_set,file="Tidy_data.txt",row.name=FALSE)
# Read table back in and display
Tidy_data<-read.table("Tidy_data.txt",header=TRUE)
View(Tidy_data)
