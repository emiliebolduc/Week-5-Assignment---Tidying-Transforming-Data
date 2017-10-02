# Read CSV
library(readr)
Airline_delays <- read_csv("~/Documents/CUNY Data 607/data/airlines/Airline_delays.csv")
Airline_delays

# Fill first column with complete row names
library(tidyr)
Airline <- Airline_delays %>% fill(X1)
Airline
# Reference: https://blog.rstudio.com/2015/09/13/tidyr-0-3-0/

# Remove rows with NAs
Airline <- na.omit(Airline)

# Make observations from variables with [gather]. i.e. Change the City columns into observations
Airline <- gather(Airline, "City", "n", 3:7)
Airline

# Make variables from observations with [spread]. i.e. Take the "On Time" and "Delayed" variables and turn into observations.
Airline <- spread(Airline, "X2", "n")
Airline

# Change column names with [dplyr]
library(dplyr)
Airline <- dplyr::rename(Airline, Carrier = X1)
Airline <- dplyr::rename(Airline, Delayed = delayed)
Airline <- dplyr::rename(Airline, On_Time = 'on time')
Airline

# (I still find the following function quicker and easier...)
colnames(Airline)<- c("Carrier","City","Delayed", "On Time")

# Analysis with [dplyr]
dplyr::tbl_df(Airline)
dplyr::glimpse(Airline)
select(Airline, Carrier, Delayed)
dplyr::summarise(Airline, median = median(Delayed))

dplyr::arrange(Airline, desc(Delayed))
dplyr::arrange(Airline, Carrier, Delayed)

Carrier <- Airline %>% group_by(Carrier) %>% 
  summarise(mean = mean(Delayed), sum = sum(Delayed), n = n())
Carrier

City <- Airline %>% group_by(City) %>% 
  summarise(mean = mean(Delayed), sum = sum(Delayed)) %>% 
  arrange(desc(mean))
City

CityCarrier <- Airline %>% group_by(City, Carrier) %>% 
  summarise(mean = mean(Delayed), sum = sum(Delayed))
CityCarrier

# Line graph
library(ggplot2)
library(scales)
LineGraph <- ggplot(CityCarrier, aes(x = City, y = mean))
LineGraph <- LineGraph + geom_line(aes(color=factor(Carrier), group = Carrier))
LineGraph <- LineGraph + scale_color_discrete(name = "Carrier")
LineGraph <- LineGraph + labs(title = "Carrier Delays by City", x = "City", y = "Total Number of Delays")
LineGraph
