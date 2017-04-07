library(readr)
library(magrittr)
annual_all_2016 <- read_csv("~/Desktop/SNU/RStuff/GLA2/annual_all_2016.csv")

head(annual_all_2016)
names(annual_all_2016)
library(dplyr)
#getting required data parameters, including only those that have been completed
reqData<-select(annual_all_2016,`Year`,`Parameter Name`, `Observation Count`,`Completeness Indicator`,`Sample Duration` ,`State Name`, `County Name`, `City Name`,`Latitude`,`Longitude`)%>%filter(`Completeness Indicator`!='N')
head(reqData)
View(reqData)

library(ggmap)
library(ggplot2)

g<-ggplot(sample_n(reqData,20),aes(x = `Parameter Name`, y = `Observation Count`, color = `Parameter Name`)) + geom_point()
g

#qmplot(location = "US" ,data = reqData, maptype = "toner-lite",color = I("red"))

usa_center <- as.numeric(geocode("United States"))
class(usa_center)
usa_center
USAMap <- ggmap(get_googlemap(center = usa_center,scale = 2, zoom = 4),extent = "normal")
USAMap
#for(i in 1:nrow(reqData)) {
  #latlon = geocode(reqData[i,1])
  #reqData$lat[i] = as.numeric(latlon[1])
  #reqData$lon[i] = as.numeric(latlon[2])
  #mutate(reqData,lat[i] = as.numeric(latlon[1]))
  #mutate(reqData,lon[i]  = as.numeric(latlon[2]))
#}

names(reqData)

#USAMap + geom_point(aes(x = `Latitude`, y = `Longitude`),data = reqData,col = "orange", alpha = 0.4,size = reqData$`Observation Count`) + scale_size_continuous(range = range(reqData$`Observation Count`))

#require(devtools)
#install_github('ramnathv/rCharts@dev')
#install_github('ramnathv/rMaps')

#library(rMaps)
#crosslet(
#  x = "country", 
#  y = c("web_index", "universal_access", "impact_empowerment", "freedom_openness"),
#  data = web_index
#)
#sampleData<-sample_n(reqData,5)
#sampleData
#ifelse(sampleData$`Observation Count` == reqData$`Observation Count`){
#  sampleData$`Completeness Indicator` = "NO"
#}
#sampleData

library(leaflet)
m<-leaflet() %>% addTiles() %>% setView(-72.690940, 41.651426, zoom = 8) %>% addMarkers(lng=reqData$Longitude, lat=reqData$Latitude, popup="<b>Hello</b><br><a href='http://www.trendct.org'>-TrendCT.org</a>")
m 


m <- leaflet(reqData) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
                              attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') 
m %>% setView(-95.71289,37.09024, zoom = 8)
m %>% addCircles(lng = reqData$Longitude, lat = reqData$Latitude, popup=reqData$`Parameter Name`, weight = 3, radius=40, 
                 color="#ffa500", stroke = TRUE, fillOpacity = 0.8)
m
