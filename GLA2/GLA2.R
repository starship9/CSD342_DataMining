library(readr)
library(magrittr)
annual_all_2016 <- read_csv("~/Desktop/SNU/RStuff/GLA2/annual_all_2016.csv")

head(annual_all_2016)
names(annual_all_2016)
library(dplyr)
#getting required data parameters, including only those that have been completed
reqData<-select(annual_all_2016,`Year`,`Parameter Name`, `Observation Count`,`Completeness Indicator`,`Sample Duration` ,`State Name`, `County Name`, `City Name`)%>%filter(`Completeness Indicator`!='N')
head(reqData)
View(reqData)

library(ggmap)
library(ggplot2)

g<-ggplot(sample_n(reqData,20),aes(x = `Parameter Name`, y = `Observation Count`, color = `Parameter Name`)) + geom_point()
g

#qmplot(location = "US" ,data = reqData, maptype = "toner-lite",color = I("red"))

usa_center <- as.numeric(geocode("United States"))
USAMap <- ggmap(get_googlemap(center = usa_center,scale = 2, zoom = 4),extent = "normal")
#USAMap


#sampleData<-sample_n(reqData,5)
#sampleData
#ifelse(sampleData$`Observation Count` == reqData$`Observation Count`){
#  sampleData$`Completeness Indicator` = "NO"
#}
#sampleData
