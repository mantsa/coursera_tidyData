
##Please set your working directory before run the rest of the script
setwd("Put your path here")

####--------------------------------------------------------------------------------####
####1. Read and merges the training and the test data sets to create one data set.  ####
####--------------------------------------------------------------------------------####

##a) get the list of file in the train folder
trainfiles<-list.files("./train",pattern="*.txt",full.names=TRUE)
##read the feature names from the features.txt file
featurenames<-read.csv("features.txt",sep="",header=FALSE)
featurenames
##read and combine by column the train data 
##create a custom function to read csv files with set separator and without header line
my_dataRead<-function(x,...){read.csv(x,header=FALSE,sep="")}
tempTrain<-lapply(trainfiles,FUN=my_dataRead)
colnames(tempTrain[[1]])<-"subject"
colnames(tempTrain[[2]])<-featurenames[,2]
colnames(tempTrain[[3]])<-"activity"
trainData<-do.call(cbind,tempTrain)
##dim(trainData)	##7352  563

##get the list of file in the test folder
testfiles<-list.files("./test",pattern="*.txt",full.names=TRUE)
##read and combine by column the test data 
tempTest<-lapply(testfiles,FUN=my_dataRead)
colnames(tempTest[[1]])<-"subject"
colnames(tempTest[[2]])<-featurenames[,2]
colnames(tempTest[[3]])<-"activity"
testData<-do.call(cbind,tempTest)
##dim(testData) 	##2947  563

###combine both data sets and add a new column if there is a need later to 
###to obtain the information if the record is coming from the test or from the
###train data set
finData<-rbind(cbind(trainData,isTest=0),cbind(testData,isTest=1))
##dim(finData)		##10299   564

####---------------------------------------------------------------------------####
####2. Extracts only the measurements on the mean and standard deviation 	   ####
####   for each measurement.   												   ####
####---------------------------------------------------------------------------####
##get the indeces of the features which have 'mean' or 'std' as a substring in 
##names. The search is not case sensitive.
m_ids<-grep("mean",featurenames[,2],ignore.case=TRUE)
##length(m_ids)			#53
s_ids<-grep("std",featurenames[,2],ignore.case=TRUE)
length(s_ids)			#33
####create one vector with all relevant indixes:
rel_ids<-c(m_ids,s_ids)
##check the uniquenes of the indexes
length(rel_ids)				##86
length(unique(rel_ids))		##86
##get the order of the colnames of our data
colnames(finData)
##add to the vector with the relevan features (rel_ids) one (+1)
##this way the column number in the data will match the indexes in the 
##vector. ordering of the vector is only for better read
rel_ids<-sort(rel_ids+1)
rel_ids
##subset the data with the relevant columns(features):
##we are also keeping the following columns
#### column 1 	= subject
#### column 563 = activity	
#### column 564 = isTest
finDataRel<-finData[,c(1,rel_ids,563,564)]
##check the result
dim(finDataRel)			##10299    89
head(finDataRel)

####---------------------------------------------------------------------------####
####3. Uses descriptive activity names to name the activities in the data set  ####
####---------------------------------------------------------------------------####

##Load the activity names with their codes
act_lbls<-read.csv("activity_labels.txt",header=FALSE,sep="")
#set colnames
colnames(act_lbls)<-c("code","act_lbl")
###add new column to the final data, which includes the corresponding activity
###labels to the codes in the data 
finDataRelMerg<-merge(finDataRel,act_lbls,by.x="activity",by.y="code",sort=FALSE)
##create new data frame including only following columns:
## subject, activity=act_lbl, 86 the relevant features (mean & std)
finDataRelExt<-finDataRelMerg[,c(2,90,3:88)]
#head(finDataRelExt)

####---------------------------------------------------------------------------####
####4. Appropriately labels the data set with descriptive variable names. 	   ####
####   All features have already descriptive names, nevertheless some of the   ####
####   names includes 'bad' characters like '(),-'. These characters will be   ####
####   substituted for '_'
####---------------------------------------------------------------------------####
##get the colnames of the current data frame
c_names<-colnames(finDataRelExt)
##change the name of the activity lable (act_lbl)
c_names[2]<-"activity_label"
##replace the comma ','
c_names<-gsub(',','_',c_names)
##replace the minus '-'
c_names<-gsub('-','_',c_names)
##replace the combination of opening and closing parenthesis '()'
c_names<-gsub('\\()','',c_names)
##replace the left parenthesis '('
c_names<-gsub('\\(','_',c_names)
##replace the right parenthesis ')'
c_names<-gsub(')','_',c_names)
#c_names
colnames(finDataRelExt)<-c_names

####---------------------------------------------------------------------------####
####5. Creates a second, independent tidy data set with the average of each    ####
####   variable for each activity and each subject							   ####
####---------------------------------------------------------------------------####
library(reshape2)
##create melted data with id=subject + activity_label, using all features
meltData<-melt(finDataRelExt,id=c("subject","activity_label"))
tidyData<-dcast(meltData,subject+activity_label~variable,mean)

#export the data 
write.table(tidyData,file="tidyData.txt",row.names = FALSE,sep="|")

