#Packages used

install.packages("tidyverse")
install.packages("janitor")
install.packages("lubridate")
install.packages("here")
install.packages("skimr")

library(tidyverse)
library(here)
library(janitor)
library(lubridate)
library(skimr)

#set the file which will be worked in
setwd("E:/Case Study/CaseStudy2/Unmodified")
#Importing Datasets
hourlyCal <- read_csv("hourlyCalories_merged.csv")
hourlyInt <- read_csv("hourlyIntensities_merged.csv")
hourlyStep <- read_csv("hourlySteps_merged.csv")
dailyAct <- read_csv("dailyActivity_merged.csv")

#Merge all three hourly factors into a single file. 
hourlyCalInt <- merge(hourlyCal, hourlyInt, by = c("Id","ActivityHour"))
hourlyFull <- merge(hourlyCalInt, hourlyStep, by = c("Id","ActivityHour"))

#Checking the number of unique participant 
n_distinct(dailyAct$Id)
n_distinct(hourlyFull$Id)

#Cleaning cols names and making all of them standardized
clean_names(dailyAct)
dailyAct <- rename_with(dailyAct,tolower)

clean_names(hourlyFull)
hourlyFull <- rename_with(hourlyFull,tolower)

#Checking duplicates
sum(duplicated(dailyAct))
sum(duplicated(hourlyFull))

#Converting date & time format
dailyAct$activitydate <- mdy(dailyAct$activitydate)
hourlyFull$activityhour <- mdy_hms(hourlyFull$activityhour)

#Adding a day_of_week col to daily_activity
dailyAct$day_of_week <- wday(dailyAct$activitydate)

#Adding a total_active_hours column to daily_activity
dailyAct$total_active_hours = 
  (dailyAct$fairlyactiveminutes 
   + dailyAct$lightlyactiveminutes + dailyAct$sedentaryminutes + dailyAct$veryactiveminutes)/60
dailyAct$total_active_hours <- round(dailyAct$total_active_hours,2)

# Converting number of the day_of_week column to name of the day
dailyAct <- dailyAct %>% 
  mutate(day_of_week = recode(day_of_week
                              ,"1" = "Sunday"
                              ,"2" = "Monday"
                              ,"3" = "Tuesday"
                              ,"4" = "Wednesday"
                              ,"5" = "Thursday"
                              ,"6" = "Friday"
                              ,"7" = "Saturday"))

# Ordering days of weeks from Monday to Sunday 
dailyAct$day_of_week <-
  ordered(dailyAct$day_of_week, 
          levels=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))

write.csv(hourlyFull,"C:/Users/Asher/Downloads/hourlyFull_merged.csv")
write.csv(dailyAct,"C:/Users/Asher/Downloads/dailyActivity_merged.csv")