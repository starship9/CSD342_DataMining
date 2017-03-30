library(readr)
annual_all_2016 <- read_csv("~/Desktop/SNU/RStuff/GLA2/annual_all_2016.csv")

head(annual_all_2016)
names(annual_all_2016)
library(dplyr)
reqData<-select(annual_all_2016, `Parameter Name`, `Sample Duration`, `State Name`, `County Name`, `City Name`)
head(reqData)


