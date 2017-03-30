library(readr)
library(magrittr)
annual_all_2016 <- read_csv("~/Desktop/SNU/RStuff/GLA2/annual_all_2016.csv")

head(annual_all_2016)
names(annual_all_2016)
library(dplyr)
#getting required data parameters, including only those that have been completed
reqData<-select(annual_all_2016, `Parameter Name`, `Observation Count`,`Completeness Indicator`,`Sample Duration` ,`State Name`, `County Name`, `City Name`)%>%filter(`Completeness Indicator`!='N')
head(reqData)
View(reqData)

