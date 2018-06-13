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
#Challenge: a good plot?
ggplot(data = surveys_complete, aes(x = species_id, y = weight)) + 
  geom_point(alpha = 0.1, aes(color=plot_id))

#No, better way to show these data is a boxplot
ggplot(data = surveys_complete, aes(x = species_id, y = weight)) + 
  geom_boxplot()

#Add multiple geoms to the ggplot command: add points behind the boxplots to have an idea about the number of observations
ggplot(data = surveys_complete, aes(x = species_id, y = weight)) + 
  geom_jitter(alpha=0.3, aes(color=plot_id)) + geom_boxplot()

surveys_complete$plot_id <- factor(surveys_complete$plot_id)

ggplot(data = surveys_complete, aes(x = species_id, y = weight)) + 
  geom_jitter(alpha=0.3, aes(color=plot_id)) + geom_boxplot()

#Challenge:
 #violin plots
ggplot(data = surveys_complete, aes(x = species_id, y = weight)) + 
  geom_violin()
 #Change scale
ggplot(data = surveys_complete, aes(x = species_id, y=weight)) + 
  geom_violin() + scale_y_log10()

ggplot(data = surveys_complete, aes(x = species_id, y = hindfoot_length)) + 
  geom_jitter(alpha=0.3, aes(color=plot_id)) + geom_boxplot()

#Visualising time differences
 #Create a new object for 
yearly_count <- surveys_complete %>%
  group_by(year, species_id) %>%
  tally()
#Plotting counts per time interval (n = number of species observed in that year)
ggplot(data = yearly_count, aes(x=year, y=n)) + geom_line()

#Create a seperate line for each species
ggplot(data = yearly_count, aes(x=year, y=n, group=species_id)) + geom_line()

#Color each species line
ggplot(data = yearly_count, aes(x=year, y=n, color=species_id)) + geom_line()

#Create a plot for each species separately using facet_wrap (break-up the data in separate figures)
ggplot(data=yearly_count, aes(x=year,y=n)) + geom_line() + facet_wrap(~ species_id)

#Look at counts of males and females per year (previous figure, but with separate lines for males and females)
#Make new object
yearly_sex_counts <- surveys_complete %>%
  group_by(year, species_id, sex) %>%
  tally()

ggplot(data = yearly_sex_counts, aes(x = year, y = n, color=sex)) +
  geom_line() + facet_wrap(~species_id)

ggplot(data = yearly_sex_counts, aes(x = year, y = n, color=sex)) +
  geom_line() + facet_wrap(~species_id) +
  theme_bw() + #removes background colour
  theme(panel.grid = element_blank()) #removes background grid

#Add a titel to the graph
ggplot(data = yearly_sex_counts, aes(x = year, y = n, color=sex)) +
  geom_line() + facet_wrap(~species_id) +
  theme_bw() + #removes background colour
  theme(panel.grid = element_blank()) + #removes background grid
  labs(title = "Observed species over time", x = "Year of observation", y = "Number of observations")

#Change the text size
#Add a titel to the graph
ggplot(data = yearly_sex_counts, aes(x = year, y = n, color=sex)) +
  geom_line() + facet_wrap(~species_id) +
  theme_bw() + #removes background colour
  theme(panel.grid = element_blank(), text = element_text(size=16)) + #removes background grid and increase text size
  labs(title = "Observed species over time", x = "Year of observation", y = "Number of observations")

ggplot(data = yearly_sex_counts, aes(x = year, y = n, color=sex)) +
  geom_line() + facet_wrap(~species_id) +
  theme_bw() + #removes background colour
  theme(panel.grid = element_blank(), text = element_text(size=16), axis.text.x = element_text(color="grey20", size=12, angle=90, hjust=0.5, vjust=0.5)) + #removes background grid and increase text size
  labs(title = "Observed species over time", x = "Year of observation", y = "Number of observations")
#Kan ook als afzonderlijk thema worden opgeslagen
grey_theme <- theme(panel.grid = element_blank(), text = element_text(size=16), axis.text.x = element_text(color="grey20", size=12, angle=90, hjust=0.5, vjust=0.5))
ggplot(data = yearly_sex_counts, aes(x = year, y = n, color='slateblue3')) +
  geom_line() + facet_wrap(~species_id) +
  theme_bw() + #removes background colour + #removes background grid and increase text size
  grey_theme +
  labs(title = "Observed species over time", x = "Year of observation", y = "Number of observations")
colors()

ggplot(data = suerveys_complete, aes(fill=conditions, x = sex, y=value)) +
  geom_bar(stat="sex")
  theme_bw() + #removes background colour
  theme(panel.grid = element_blank(), text = element_text(size=16), axis.text.x = element_text(color="grey20", size=12, angle=90, hjust=0.5, vjust=0.5)) + #removes background grid and increase text size
  labs(title = "Observed species over time", x = "Year of observation", y = "Number of observations")
  
#How to save an image as high resolution: ggsave

  #Step1: assign your plot to an object

my_plot <- ggplot(data = yearly_sex_counts, aes(x = year, y = n, color='slateblue3')) +
  geom_line() + facet_wrap(~species_id) +
  theme_bw() + #removes background colour + #removes background grid and increase text size
  grey_theme +
  labs(title = "Observed species over time", x = "Year of observation", y = "Number of observations")
my_plot

yellow_theme <- theme(panel.grid = element_blank(), text = element_text(size=16), axis.text.x = element_text(color="yellow", size=12, angle=90, hjust=0.5, vjust=0.5))

my_plot + yellow_theme

#For journals: use vector-based figures (can be infinitely scaled), PNG = raster (pixels)
#When you want to adjust a detail on your figure; save it as pdf and load it in inskape
ggsave("C:/Users/ybawin/Documents/DCEcology/Plots/my_first_plot.png", my_plot, width = 15, height = 10, dpi = 300)

#Data manipulation
library(tidyverse)





