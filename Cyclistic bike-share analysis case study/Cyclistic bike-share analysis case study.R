install.packages("tidyverse")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("plyr")   
install.packages("readr") 


library("tidyverse")
library("ggplot2")
library("lubridate")
library("plyr")   
library("dplyr")
library("readr")
 


Jan_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202101-divvy-tripdata.csv")
Feb_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202102-divvy-tripdata.csv")
Mar_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202103-divvy-tripdata.csv")
Apr_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202104-divvy-tripdata.csv")
May_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202105-divvy-tripdata.csv")
Jun_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202106-divvy-tripdata.csv")
Jul_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202107-divvy-tripdata.csv")
Aug_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202108-divvy-tripdata.csv")
Sep_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202109-divvy-tripdata.csv")
Oct_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202110-divvy-tripdata.csv")
Nov_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202111-divvy-tripdata.csv")
Dec_2021 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202112-divvy-tripdata.csv")
Jan_2022 <- read.csv("C:\\Users\\ferna\\OneDrive\\Documents\\Case Study Coursera\\divvy-tripdata\\202201-divvy-tripdata.csv")


#### Combine data into single file

colnames(Jan_2021)
colnames(Feb_2021)
colnames(Mar_2021)
colnames(Apr_2021)
colnames(May_2021)
colnames(Jun_2021)
colnames(Jul_2021)
colnames(Aug_2021)
colnames(Sep_2021)
colnames(Oct_2021)
colnames(Nov_2021)
colnames(Dec_2021)
colnames(Jan_2022)


#### Looking for the data type for each files
#### Make sure the data tye for each files are same. 
#### That's help to change the data type together if it needed

str(Jan_2021)
str(Feb_2021)
str(Mar_2021)
str(Apr_2021)
str(May_2021)
str(Jun_2021)
str(Jul_2021)
str(Aug_2021)
str(Sep_2021)
str(Oct_2021)
str(Nov_2021)
str(Dec_2021)
str(Jan_2022)

#### Data type looks same for all file

all_trips_data <- rbind(Jan_2021, Feb_2021, Mar_2021, Apr_2021, May_2021, Jun_2021, Jul_2021, Aug_2021, Sep_2021, Oct_2021, Nov_2021, Dec_2021, Jan_2022)

head(all_trips_data)


#### Look the data type
str(all_trips_data)


#### Change the data type
#### started_at to date, ended_at to date

all_trips_data <- mutate(all_trips_data,
                         started_at = as.POSIXct(started_at),
                         ended_at = as.POSIXct(ended_at)
                         )

#### Look the data type after convert
str(all_trips_data)



summary(all_trips_data)





#### Add New Column for Date, month, day, day_of_week, hours:minute

all_trips_data$date <- as.Date(all_trips_data$started_at)
all_trips_data$month <- format(as.Date(all_trips_data$started_at), "%m")
all_trips_data$trip_hour <- (format(all_trips_data$started_at, "%H"))
all_trips_data$day <- format(as.Date(all_trips_data$started_at), "%w")
all_trips_data$day_of_Week <- format(as.Date(all_trips_data$started_at), "%A")
all_trips_data$datetime <- (format(all_trips_data$started_at, "%H:%M:%S"))




all_trips_data$ride_length <- difftime(all_trips_data$ended_at, all_trips_data$started_at)

head(all_trips_data)
str(all_trips_data)


#### To convert ride_length from dateiff to numeric value
is.numeric(all_trips_data$ride_length)

all_trips_data$ride_length <- as.numeric(as.character(all_trips_data$ride_length))
is.numeric(all_trips_data$ride_length)


#### Make a data frame, to know ride_length is negative, lat and long has null values, and stations that n/a
all_trips_data_ride_length_negative <- all_trips_data[(all_trips_data$ride_length<0),]
all_trips_na_lat_long <- all_trips_data[(all_trips_data$start_lat == "" | is.na(all_trips_data$start_lat) | all_trips_data$start_lng == "" | is.na(all_trips_data$start_lng) | all_trips_data$end_lat == "" | is.na(all_trips_data$end_lat) |  all_trips_data$end_lng == "" | is.na(all_trips_data$end_lng)),]
all_trips_na_stations <- all_trips_data [(all_trips_data$start_station_name == ""| is.na(all_trips_data$start_station_name) | all_trips_data$end_station_name == "" | is.na(all_trips_data$end_station_name)),]


#### Create a new data.frame version 2 for clean data.frame
all_trips_data_v2 <- all_trips_data[!(all_trips_data$ride_length<0),]
all_trips_data_v2 <- all_trips_data_v2[!(all_trips_data_v2$start_lat == "" | is.na(all_trips_data_v2$start_lat) | all_trips_data_v2$start_lng == "" | is.na(all_trips_data_v2$start_lng) | all_trips_data_v2$end_lat == "" | is.na(all_trips_data_v2$end_lat) |  all_trips_data_v2$end_lng == "" | is.na(all_trips_data_v2$end_lng)),]
all_trips_data_v2 <- all_trips_data_v2 [!((all_trips_data_v2$start_station_name == "WATSON TESTING - DIVVY" & !is.na(all_trips_data_v2$start_station_name)) | (all_trips_data_v2$start_station_name == "HUBBARD BIKE-CHECKING (LBS-WH-TEST)" & !is.na(all_trips_data_v2$start_station_name)) | (all_trips_data_v2$start_station_name == "Base - 2132 W Hubbard Warehouse" & !is.na(all_trips_data_v2$start_station_name)) | (all_trips_data_v2$start_station_name == "Hubbard Bike-checking (LBS-WH-TEST)" & !is.na(all_trips_data_v2$start_station_name)) | (all_trips_data_v2$start_station_id == "Hubbard Bike-checking (LBS-WH-TEST)" & !is.na(all_trips_data_v2$start_station_id))),]


all_trips_data_v2 <- all_trips_data_v2 %>% 
  mutate(start_end_same_station = case_when(
    all_trips_data_v2$start_station_name == all_trips_data_v2$end_station_name ~ "Yes",
    all_trips_data_v2$start_station_name != all_trips_data_v2$end_station_name ~ "No"))



str(all_trips_data_v2)

summary(all_trips_data_v2)


#### Change the ride_length from second to minute, and round it just minute, not minute.second
all_trips_data_v2$ride_length_min <- all_trips_data_v2$ride_length/60
all_trips_data_v2$ride_length_min <- round(all_trips_data_v2$ride_length_min, digits=0)


head(all_trips_data_v2)


all_trips_data_v2 %>%
  group_by(member_casual) %>%
  dplyr::summarise(count=n())

summary(all_trips_data_v2$ride_length_min)



aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$member_casual, FUN = mean)
aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$member_casual, FUN = median)
aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$member_casual, FUN = max)
aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$member_casual, FUN = min)


aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$member_casual + all_trips_data_v2$day_of_Week, FUN = mean)


all_trips_data_v2$day_of_Week <- ordered(all_trips_data_v2$day_of_Week, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))


aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$member_casual + all_trips_data_v2$day_of_Week, FUN = mean)



aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$member_casual, FUN = length)


aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$rideable_type + all_trips_data_v2$member_casual, FUN = length)


aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$member_casual + all_trips_data_v2$day_of_Week, FUN = length)


aggregate(all_trips_data_v2$ride_length_min ~ all_trips_data_v2$member_casual + all_trips_data_v2$start_end_same_station, FUN = length)






# DATA VISUALIZATION




#### Looking for number of rides and member_cassual
all_trips_data_v2 %>% 
  group_by(member_casual) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>% 
  arrange(member_casual) %>% 
  ggplot(aes(x = member_casual, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")


#### number_of_rides has exponential number.
#### Change the exponential number to number
options(scipen = 999) 


##### Run the data visualization of number_of_rides - member_casual
all_trips_data_v2 %>% 
  group_by(member_casual) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>% 
  arrange(member_casual) %>% 
  ggplot(aes(x = member_casual, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")
  

#### Count the exact number of member_casual
all_trips_data_v2 %>%
  group_by(member_casual) %>%
  dplyr::summarise(count=n())




##### Run the data visualization of average_durations - member_casual
all_trips_data_v2 %>% 
  group_by(member_casual) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>% 
  arrange(member_casual) %>% 
  ggplot(aes(x = member_casual, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")


#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual) %>% 
  dplyr::summarize(ride_length_min = mean(ride_length_min))







##### Run the data visualization of number_of_rides by rideable_type- member_casual
all_trips_data_v2 %>% 
  group_by(member_casual, rideable_type) %>% 
  dplyr::summarize(number_of_rides = n()) %>% 
  arrange(member_casual) %>% 
  ggplot(aes(x = member_casual, y = number_of_rides, fill = rideable_type)) +
  geom_col(position = "dodge")


#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, rideable_type) %>% 
  dplyr::summarize(count=n())




##### Run the data visualization of average_durations  by rideable_type - member_casual
all_trips_data_v2 %>% 
  group_by(member_casual, rideable_type) %>% 
  dplyr::summarize(average_duration = mean(ride_length_min)) %>% 
  arrange(member_casual) %>% 
  ggplot(aes(x = member_casual, y = average_duration, fill = rideable_type)) +
  geom_col(position = "dodge")


#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, rideable_type) %>% 
  dplyr::summarize(ride_length_min = mean(ride_length_min))







###day_of_Week

##### Run the data visualization of number_of_rides by day_of_Week- member_casual
all_trips_data_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>%  
  arrange(member_casual, weekday) %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") 


#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, day_of_Week) %>% 
  dplyr::summarize(count=n())



##### Run the data visualization of average_durations - member_casual
all_trips_data_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>%  
  arrange(member_casual, weekday) %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") 

#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, day_of_Week) %>% 
  dplyr::summarize(ride_length_min = mean(ride_length_min))







#### HOUR


##### Run the data visualization of number_of_rides by day_of_Week- member_casual
all_trips_data_v2 %>% 
  group_by(member_casual, trip_hour) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>%  
  arrange(member_casual, trip_hour) %>% 
  ggplot(aes(x = trip_hour, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  theme(axis.text.x = element_text(angle=90))


#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, trip_hour) %>% 
  dplyr::summarize(count=n())







##### Run the data visualization of average_durations - member_casual
all_trips_data_v2 %>% 
  group_by(member_casual, trip_hour) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>%  
  arrange(member_casual, trip_hour) %>% 
  ggplot(aes(x = trip_hour, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  theme(axis.text.x = element_text(angle=90))

#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, trip_hour) %>% 
  dplyr::summarize(ride_length_min = mean(ride_length_min))








#### HOUR per Days (FACET)


##### Run the data visualization of number_of_rides by day_of_Week- member_casual
all_trips_data_v2 %>% 
  group_by(member_casual, day_of_Week, trip_hour) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>%  
  arrange(member_casual, trip_hour) %>% 
  ggplot(aes(x = trip_hour, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  facet_wrap(~day_of_Week) 


#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, day_of_Week, trip_hour) %>% 
  dplyr::summarize(count=n())




##### Run the data visualization of average_durations - member_casual
all_trips_data_v2 %>% 
  group_by(member_casual, day_of_Week, trip_hour) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>%  
  arrange(member_casual, trip_hour) %>% 
  ggplot(aes(x = trip_hour, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  facet_wrap(~day_of_Week)

#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, day_of_Week, trip_hour) %>% 
  dplyr::summarize(ride_length_min = mean(ride_length_min))






#### Number_of_rides that has start and end bike in same station


##### Run the data visualization of number_of_rides by day_of_Week- member_casual
all_trips_data_v2 %>% 
  group_by(member_casual, start_end_same_station) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>%  
  arrange(member_casual, start_end_same_station) %>% 
  ggplot(aes(x = start_end_same_station, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")


#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, start_end_same_station) %>% 
  dplyr::summarize(count=n())










#### Number_of_rides that has start and end bike in same station per days


##### Run the data visualization of number_of_rides by day_of_Week- member_casual
all_trips_data_v2 %>% 
  group_by(member_casual, day_of_Week, start_end_same_station) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>%  
  arrange(member_casual, start_end_same_station) %>% 
  ggplot(aes(x = start_end_same_station, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  facet_grid(cols = vars(day_of_Week))


#### Count the exact number of average_durations
all_trips_data_v2 %>% 
  group_by(member_casual, start_end_same_station) %>% 
  dplyr::summarize(count=n())














## MONTH

### Rides by month by month and member type

#### Number of rides by trip_hour - member type

all_trips_data_v2 %>% 
  group_by(member_casual, month) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)) %>%  
  arrange(member_casual, month) %>% 
  ggplot(aes(x = month, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") 



#### Count the exact number of rides by month and member type
all_trips_data_v2 %>% 
  group_by(member_casual, month) %>% 
  dplyr::summarize(count=n())


#### total duration of rides by month and member type
all_trips_data_v2 %>% 
  group_by(member_casual, month) %>% 
  dplyr::summarize(number_of_rides = n()
                   ,average_duration = mean(ride_length_min)
                   ,total_duration = sum(ride_length_min)) %>%  
  arrange(member_casual, month) %>% 
  ggplot(aes(x = month, y = total_duration, fill = member_casual)) +
  geom_col(position = "dodge") 


#### Count the exact number of average_durations by month and member type
all_trips_data_v2 %>% 
  group_by(member_casual, month) %>% 
  dplyr::summarize(total_duration = sum(ride_length_min))
