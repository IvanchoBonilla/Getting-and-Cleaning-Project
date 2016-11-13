library(plyr)
library(dplyr)
library(tidyr)

#Funcion para leer los archivos origen y fusionar los test y train sets
FusionSet<- function() {
        namesSet<-read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
        trainSet<-read.table("./UCI HAR Dataset/train/X_train.txt", col.names = t(namesSet[2]), stringsAsFactors = FALSE)
        trainSubject<-read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject", stringsAsFactors = FALSE)
        trainActivity<-read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "IdActivity", stringsAsFactors = FALSE)
        testSet<-read.table("./UCI HAR Dataset/test/X_test.txt", col.names = t(namesSet[2]), stringsAsFactors = FALSE)
        testSubject<-read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject", stringsAsFactors = FALSE)
        testActivity<-read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "IdActivity", stringsAsFactors = FALSE)
        
        train<-bind_cols(trainSubject, trainActivity, trainSet)
        test<-bind_cols(testSubject, testActivity, testSet)
        
        full  <- tbl_df(bind_rows(train, test))
        full
}

#Cambio los nobres de las variables
ChangeDescriptionVariables <- function(full) {
        colnames(full)[1] <- "body_acceleration_on_X_axis_in_time_domain"
        colnames(full)[2] <- "body_acceleration_on_Y_axis_in_time_domain"
        colnames(full)[3] <- "body_acceleration_on_Z_axis_in_time_domain"
        colnames(full)[4] <- "gravity_acceleration_on_X_axis_in_time_domain"
        colnames(full)[5] <- "gravity_acceleration_on_Y_axis_in_time_domain"
        colnames(full)[6] <- "gravity_acceleration_on_Z_axis_in_time_domain"
        colnames(full)[7] <- "jerk_of_the_body_acceleration_on_X_axis_in_time_domain"
        colnames(full)[8] <- "jerk_of_the_body_acceleration_on_Y_axis_in_time_domain"
        colnames(full)[9] <- "jerk_of_the_body_acceleration_on_Z_axis_in_time_domain"
        colnames(full)[10] <- "body_angular_velocity_on_X_axis_in_time_domain"
        colnames(full)[11] <- "body_angular_velocity_on_Y_axis_in_time_domain"
        colnames(full)[12] <- "body_angular_velocity_on_Z_axis_in_time_domain"
        colnames(full)[13] <- "jerk_of_the_body_angular_velocity_on_X_axis_in_time_domain"
        colnames(full)[14] <- "jerk_of_the_body_angular_velocity_on_Y_axis_in_time_domain"
        colnames(full)[15] <- "jerk_of_the_body_angular_velocity_on_Z_axis_in_time_domain"
        colnames(full)[16] <- "Euclidean_norm_to_body_acceleration_in_time_domain"
        colnames(full)[17] <- "Euclidean_norm_to_gravity_acceleration_in_time_domain"
        colnames(full)[18] <- "Euclidean_norm_to_jerk_of_the_body_acceleration_in_time_domain"
        colnames(full)[19] <- "Euclidean_norm_to_body_angular_velocity_in_time_domain"
        colnames(full)[20] <- "Euclidean_norm_to_jerk_of_the_body_angular_velocity_in_time_domain"
        colnames(full)[21] <- "body_acceleration_on_X_axis_in_frequency_domain"
        colnames(full)[22] <- "body_acceleration_on_Y_axis_in_frequency_domain"
        colnames(full)[23] <- "body_acceleration_on_Z_axis_in_frequency_domain"
        colnames(full)[24] <- "jerk_of_the_body_acceleration_on_X_axis_in_frequency_domain"
        colnames(full)[25] <- "jerk_of_the_body_acceleration_on_Y_axis_in_frequency_domain"
        colnames(full)[26] <- "jerk_of_the_body_acceleration_on_Z_axis_in_frequency_domain"
        colnames(full)[27] <- "body_angular_velocity_on_X_axis_in_frequency_domain"
        colnames(full)[28] <- "body_angular_velocity_on_Y_axis_in_frequency_domain"
        colnames(full)[29] <- "body_angular_velocity_on_Z_axis_in_frequency_domain"
        colnames(full)[30] <- "Euclidean_norm_to_body_acceleration_in_frequency_domain"
        colnames(full)[31] <- "Euclidean_norm_to_jerk_of_the_body_acceleration_in_frequency_domain"
        colnames(full)[32] <- "Euclidean_norm_to_body_angular_velocity_in_frequency_domain"
        colnames(full)[33] <- "Euclidean_norm_to_jerk_of_the_body_angular_velocity_in_frequency_domain"
        full
}

#Extraigo solo los datos de media y derivacion estandar para dejarlos listo
ExtractMeasurements <- function(full) {
        Activity <- full %>%
                select(contains("IdActivity"))

        Subject <- full %>%
                select(contains("Subject"))
        
        meandataset <- full %>%
                select(contains(".mean..")) %>%
                mutate(Measure="mean") %>%
                ChangeDescriptionVariables() %>%
                bind_cols(Activity, Subject) %>%
                gather(Variables, Values, body_acceleration_on_X_axis_in_time_domain:Euclidean_norm_to_jerk_of_the_body_angular_velocity_in_frequency_domain, na.rm = TRUE)
        
        stddataset<- full %>%
                select(contains(".std..")) %>%
                mutate(Measure="StandardDerivation") %>%
                ChangeDescriptionVariables() %>%
                bind_cols(Activity, Subject) %>%
                gather(Variables, Values, body_acceleration_on_X_axis_in_time_domain:Euclidean_norm_to_jerk_of_the_body_angular_velocity_in_frequency_domain, na.rm = TRUE)
        
        full<-tbl_df(bind_rows(meandataset,stddataset))
        full
}

#Cambio los nombres de las actividades
ChangeDescriptiveActivities <- function(full){
        activitiesNames<-read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("IdActivity", "Activity"), stringsAsFactors = FALSE)
        full<- full %>%
                join(activitiesNames) %>%
                select(Subject, Activity, Variables, Measure, Values) %>%
                tbl_df()
        full
}

#Creo y exporto la informacion limpia
CreateTidyData <- function(full) {
        full<- full %>%
                group_by(Subject, Activity, Variables, Measure) %>%
                summarize(Avg = mean(Values)) %>%
                spread(Measure, Avg)
        full
}

TidySet<-FusionSet() %>%
        ExtractMeasurements() %>%
        ChangeDescriptiveActivities() %>%
        CreateTidyData() %>%
        write.table("./tidy_Data.txt", row.names = FALSE) %>%
        rm()


