setwd("D:/UPGRAD/course 2/Uber assignment")

#### UBER ASSIGNMENT ####
#Loading the required packages
library(lubridate)
library(stringr)
library(ggplot2)
library(dplyr)


#Getting uber request data into R
Uber.Request<-read.csv("Uber Request Data.csv",stringsAsFactors = FALSE)

#Observing the structure of dataframe Uber.Requests                         
str(Uber.Request)
#or you can also have a glimpse of data frame using Uber.Requests
glimpse(Uber.Request)




####Handling data quality issues/Data Cleaning####

#checking for any duplicate rows
cat ('there are',(nrow(Uber.Request)-nrow(Uber.Request %>% unique)),'duplicate rows')
#there are 0 duplicate rows


# checking for any NA values in all columns, one after other

# checking for any NA values in column Request.id
anyNA(Uber.Request$Request.id)          # no NA's
# checking for any NA values in column 
anyNA(Uber.Request$Driver.id)           # NA's present
# checking for any NA values in column 
anyNA(Uber.Request$Pickup.point)        # no NA's
# checking for any NA values in column 
anyNA(Uber.Request$Status)              # no NA's
# checking for any NA values in column 
anyNA(Uber.Request$Request.timestamp)   # no NA's
# checking for any NA values in column 
anyNA(Uber.Request$Drop.timestamp)      # NA's present

# It looks appropriate to leave the NA's untouched as they 
# look valid in the columns Driver.id and Drop.timestamp the NA's
# in the respective columns are present when there is a value
# "no cars available" in column status

#checking for any spelling mistakes in categorical columns

#In column Pickup.point

unique(Uber.Request$Pickup.point)

# there are only two unique values "Airport" "City"  in column Pickup.point.There are no spelling mistakes

#In column Status
unique(Uber.Request$Status)

#there are only three  unique values Trip Completed,Cancelled,No Cars Available in column Status.There are no spelling mistakes


####Handling date and time columns Request.timestamp and Drop.timestamp which are read as type character####

##Request.timestamp##

#Parsing Request.timestamp and storing it in the column Request_Date

Uber.Request$Request_Date<- lubridate::parse_date_time(Uber.Request$Request.timestamp,orders = c("d/m/Y H:M","d-m-Y H-M-S"))

# checking if there are any NA's coerced because of invalid data values
(Uber.Request$Request.timestamp %>% is.na %>% sum) == (Uber.Request$Request_Date%>% is.na %>% sum)
#It gives TRUE means  NA's are not coerced.This also means there are no invalid data values in Request.timestamp

#spliting date fromm Request_Date and storing it in column Request.Date
Uber.Request$Request.Date<- as.Date(Uber.Request$Request_Date)

#spliting date form Request_Date and storing it in column Request.Time
Uber.Request$Request.Time<-format(Uber.Request$Request_Date,"%H:%M:%S")

#Extracting hours mins and sec from column Request.timestamp
Uber.Request$Request.hour<-lubridate::hour(Uber.Request$Request_Date)
Uber.Request$Request.minute<-lubridate::minute(Uber.Request$Request_Date)
Uber.Request$Request.second<-lubridate::second(Uber.Request$Request_Date)

#Dropping request_date column
Uber.Request$Request_Date<-NULL


#####Drop.timestamp#####

#Parsing Drop.timestamp and storing it in the column Drop_Date

Uber.Request$Drop_Date<- parse_date_time(Uber.Request$Drop.timestamp,orders = c("d/m/Y H:M","d-m-Y H-M-S"))

# checking if there are any NA's coerced because of invalid data values
(Uber.Request$Drop.timestamp %>% is.na %>% sum) == (Uber.Request$Drop_Date%>% is.na %>% sum)
#It gives TRUE means  NA's are not coerced. This also means there are no invalid data values in Drop.timestamp

#spliting date form Drop_Date and storing it in column Drop.Date
Uber.Request$Drop.Date<- as.Date(Uber.Request$Drop_Date)

#spliting date form Drop_Date and storing it in column Drop.Time
Uber.Request$Drop.Time<-format(Uber.Request$Drop_Date,"%T")

#Extracting hours mins and sec from column Drop.timestamp
Uber.Request$Drop.hour<-lubridate::hour(Uber.Request$Drop_Date)
Uber.Request$Drop.minute<-lubridate::minute(Uber.Request$Drop_Date)
Uber.Request$Drop.second<-lubridate::second(Uber.Request$Drop_Date)

#Dropping request_date column
Uber.Request$Drop_Date<-NULL

######DATA ANALYSIS#####

# Since Request.id and Driver.id are id or unique values there isn't much sense analysing them

#Analysing variable Pickup.point by plotting a bar chart on it (and looking for some insights)
ggplot(Uber.Request,aes(Uber.Request$Pickup.point))+geom_bar(fill="skyblue4")+annotate("text",x="Airport",y=3450,label="48%")+annotate("text",x="City",y=3700,label="51%")
#The above plot shows that ,there isn't much difference between Airport and city pickup requests

#Analysing variable Status by plotting a bar chart on it (and looking for some insights)
ggplot(Uber.Request,aes(Uber.Request$Status))+geom_bar(fill="skyblue4")+annotate("text",x="No Cars Available",y=2800,label="39%")+annotate("text",x="Cancelled",y=1400,label="19%")+annotate("text",x="Trip Completed",y=2950,label="41%")

#Analysing variable Request.hour by plotting a bar chart on it (and looking for some insights)
ggplot(Uber.Request,aes(Uber.Request$Request.hour))+geom_bar(fill="royalblue1")


#Analysing variable Drop.hour by plotting a bar chart on it (and looking for some insights)
ggplot(Uber.Request,aes(Uber.Request$Drop.hour))+geom_bar(fill="royalblue1")

#ploting uber requests at different hours of day for both airport and city pickups
ggplot(Uber.Request,aes(x=Request.hour))+geom_bar(fill="skyblue4")+theme_bw()+facet_wrap(~Pickup.point)

#The above plot clearly shows that most of city pickup request are from 4am to 10 am and 
#most of the airport pickup requests are from  5pm to 10 pm


#Drilling the same plot on another variable Status gives a lot of valuable information

ggplot(Uber.Request,aes(x=Request.hour))+geom_bar(fill="skyblue4")+theme_bw()+facet_wrap(Pickup.point~Status)


# the above plot clearly shows that most of the request gets cancelled for city pickups
#and cars are not available for airport pickups
 



