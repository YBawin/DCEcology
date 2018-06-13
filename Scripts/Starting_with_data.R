#R script Data carpentry workshop

library(tidyverse)

download.file("https://ndownloader.figshare.com/files/2292169",             
              "Data/portal_data_joined.csv")

setwd("C:/Users/ybawin/Documents/DCEcology/Data")
surveys <- read.csv("portal_data_joined.csv")
View(surveys)
head(surveys)
dim(surveys) #Counts the number of rows and columns
nrow(surveys)#Counts the number of rows
ncol(surveys)#Counts the number of columns
head(surveys)#Prints the first 6 rows of the document
tail(surveys)#Prints the last 6 lines of the document
names(surveys)#Print all column names in the file   
rownames(surveys) #print all row names in the file
str(surveys) #Shows different variables and their data types
summary(surveys) #Calculate summary statistics (mean, first qu, third qu, ...)

#Challenge


#Based on the output of str(surveys), can you answer the following questions?
#What is the class of the object surveys? data.frame
  #How many rows and how many columns are in this object? 34786
  #How many species have been recorded during these surveys?
str(surveys)

#Factor = categorical data
sex <- factor(c("male","female","female","male"))

#Factors have different levels (categorised):
levels(sex)
#Number of levels
nlevels(sex)

lvls <- factor(c("high","medium","low"))
levels(lvls) #levels are sorted alphabetically (which is not very logical in this case)

#change order of factors
lvls <- factor(c("high","medium","low"), levels = c("low", "medium", "high"))
levels(lvls)

#Change factors to characters
as.character(lvls)

#does not work for a factor of integers

year_fct <- factor(c(1990, 1983, 1998, 1991))
as.numeric(year_fct) #gives indexes of years

#How to deal with this?

year_fct <- factor(c(1990, 1983, 1998, 1991))
as.numeric(as.character(year_fct))

#OR (more recommended)

as.numeric(levels(year_fct))

as.numeric(levels(year_fct))[year_fct] #show it as the original list

#Make a simple plot for data exploration

plot(surveys$sex)
#Also plotting empty values
levels(surveys$sex)

#Change the name of the empty values variable to "undetermined"

 #Create a new dataobject to not change anything in the original dataframe
sex <- surveys$sex
levels(sex)

#Change the first object
levels(sex)[1] <- "undetermined"
levels(sex)

plot(sex)

#Challenge: rename F and M to female and male

levels(sex)[2] <- "Female"
levels(sex)[3] <- "Male"
levels(sex)

#Change the order of the factors
lvls <- factor(sex, levels = c("Female", "Male", "undetermined"))
plot(lvls)

#Read all strings as factors
surveys <- read.csv("portal_data_joined.csv", stringsAsFactors=TRUE)
str(surveys)

#Read all strings as characters
surveys <- read.csv("portal_data_joined.csv", stringsAsFactors=FALSE)
str(surveys)

#Change character to factor
surveys$genus <- factor(surveys$genus)
str(surveys)

#Working with dates
library(lubridate)

my_date <- ymd("2015-01-01")

#my_date is in date format
str(my_date)

#Alternative command
my_date <- ymd(paste("2015","1","1", sep="-"))
str(my_date)

#Convert years, months and days to date notation via function paste
paste(surveys$year, surveys$month, surveys$day, sep="-")

#Adding extra zeros to make the date notation more conform the international standards
ymd(paste(surveys$year, surveys$month, surveys$day, sep="-"))

surveys$date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep="-"))
str(surveys)

#Something is wrong with the 129 data (stored in the columns as NA?)

#create new object for missing data

is_missing_date <- is.na(surveys$date)
is_missing_date #You get a big list of booleans
#Create a list of the columns that must be extracted
date_columns <- c("year", "month", "day")
missing_dates <- surveys[is_missing_date, date_columns]
head(missing_dates)

#The data are not missing, but the data do not exist in real life (e.g. 31st of september, september only has 30 days)


#Data visualisation

download.file("https://ndownloader.figshare.com/files/11930600?private_link=fe0cd1848e06456e6f38","surveys_complete.csv")

#Load file in R
#read_csv = specific method from the tidyverse package; it does not read characters by default as characters
surveys_complete <- read_csv("surveys_complete.csv")

#Basic ggplot2 template
#Maybe a bit confusing: first ggplot command and then additional commands to visualise
ggplot(data = surveys_complete)
#Looks like nothing happened, but this is normal
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length))
#Gives a little bit more, but still no information what kind of plot I want
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) + 
  geom_point()
#Scatterplot is made!!!

ggplot(data = surveys_complete, aes(x = weight)) + 
  geom_bar()

#Barplot is made!!!

#Scatterplot lijkt niet echt mooi (veel data overlap in het midden)

ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) + 
  geom_point(alpha = 0.1)

  #Alpha verandert transparantie van punt

ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) + 
  geom_point(alpha = 0.1, color="springgreen4")

  #Change the color to a different color
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) + 
  geom_point(alpha = 0.1, aes(color=species_id))

  #If you want to add a trend line with separate aesthetics: add the aes within the geom_point (otherswise it will 
  #use this option for all plots in the command (e.g. trend line))
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) + 
  geom_point(alpha = 0.1, aes(color=species_id))



