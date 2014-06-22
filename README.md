

-repository: coursera_tidyData

-=================

--Description: Getting and Cleaning Data: course project

--Files included:
--->README.md - describes all files uploaded to this repository
--->codeBook.md - describes the selected featurelist for the result tidy data
--->run_analysis.R - includes the r-code to load, clean and extract a tidy data set from the given source data
--->tidyData.txt - the result after running the r script


-==================
-R code steps description
-==================
1. Read and merges the training and the test data sets to create one data set. 
1.1 get the list of file in the train folder
1.2 read the feature names from the features.txt file <-- preparation for step 4
1.3 read and combine by column the train data 
1.4 read and combine by column the test data 
1.5 combine both data sets and add a new column if there is a need later to 
	to obtain the information if the record is coming from the test or from the
	train data set
2. Extracts only the measurements on the mean and standard deviation for each measurement.
2.1 get the indeces of the features which have 'mean' or 'std' as a substring in 
    the columnnames. The search is not case sensitive.
2.2 subset the data with the relevant columns(features)
3. Uses descriptive activity names to name the activities in the data set
3.1 Load the activity names with their codes
3.2 add new column to the final data, which includes the corresponding activity
	labels to the codes in the data 
3.3 create new data frame including only following columns:
	subject, activity=act_lbl, 86 the relevant features (mean & std)
4. Appropriately labels the data set with descriptive variable names. 	  
   All features have already descriptive names, nevertheless some of the   
   names includes 'bad' characters like '(),-'. These characters will be   
   substituted for '_'
5. Creates a second, independent tidy data set with the average of each    
   variable for each activity and each subject
5.1 reshape the data using melt() and dcast()
5.2 export the tidy data to a pipe-separated-file

###HOW-TO-READ the exported tidy data back into R: 
read.csv("tidyData.txt",header=TRUE,sep="|")
