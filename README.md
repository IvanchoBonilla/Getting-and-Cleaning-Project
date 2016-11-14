#Readme



##The Script Code

The script have been carried on with four functions which allows transform the messy data to tidy data as well as . 

###Libraries

First one, libraries like `plyr`, `dplyr` and `tidyr` must be installed to run the script. This packages are needed to manipulate, split, combain, merge, and join a set data which we want.

###Function 1 - Merge the test and training data

In this function, all information described in the "readme.txt" to determine the information needed to upload for the task that was asked. In the folder "UCI HAR Dataset' are located the test and train dataset as well as the names of every variable, subject, activity and names of each activity set and for each dataset.

This files are named like this:

	1. test dataset - `X_test.txt`
	2. subject test dataset - `subject_test.txt`
	3. activity test dataset - `y_test.txt`
	4. train data set - `X_train.txt`
	5. subject train dataset - `subject_train.txt`
	6. activity train dataset - `y_train.txt`
	7. variables name - `features.txt`
	8. activities description - `activity_labels.txt`

These information were upload to R through the `read.table()` function due to the information are in txt extencion. Next, it was merged the test and train dataset by means of `bind_col()` function to creating just one dataset.

###Function 2 - Extracts only the measurements mean and standard derivation

By means of dataset created on the step above is where the '`dplyr`'s package functions begins to be used. In this fuction all measurements where the mean() and std() was calculed, was filtered through the `select()` and `contains()` function. 

In this step, from 581 initial measurements that had the data set just 33 columns were filtered through this function. Here, to disting this filtered parameter the function `mutate()` was used to insert a new column.



###Function 3 - Descriptive activity names

In this step, the fuction `join()` was used which the `id Activity` was the commun variable to join the data set created before and the variables name file that was upload initially.

###Function 4 - Descriptive variable names

As the column names are exactly in the same order, it can be changed in this way by means of fuction `colnames()`

###Function 5 - Independent tidy data set

