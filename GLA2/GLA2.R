#Graded Lab assignment, group 2:

#Manjul Singh Sachan (1410110228)
#Mohak Garg (1410110247)
#Nishank Saini (1410110266)



library(readr)
library(magrittr)
genGraphBar<-function(x) {
annual_all_2016 <- read_csv(x)

head(annual_all_2016)
names(annual_all_2016)
library(dplyr)
#getting required data parameters, including only those that have been completed
reqData<-select(annual_all_2016,`Year`,`Parameter Name`, `Observation Count`,`Arithmetic Mean`,`Completeness Indicator`,`Sample Duration` ,`State Name`, `County Name`, `City Name`,`Latitude`,`Longitude`)%>%filter(`Completeness Indicator`!='N')
head(reqData)
#View(reqData)

#library(ggmap)
library(ggplot2)


g<-ggplot(sample_n(reqData,20),aes(x = `Parameter Name`, y = `Observation Count`, color = `Parameter Name`)) + geom_point()
g

ggplot(sample_n( reqData, 20),aes(x = `State Name`,color = `State Name`,fill = `State Name`)) + geom_bar()
}

genGraphBar("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2016.csv")
genGraphBar("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_1995.csv")
genGraphBar("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2000.csv")
genGraphBar("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2005.csv")
genGraphBar("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2010.csv")
#ggplot(sample_n( reqData, 20),aes(x = `State Name`,y = `Arithmetic Mean`,color = `State Name`,linetype = reqData$`Parameter Name`)) + geom_smooth()
#qmplot(location = "US" ,data = reqData, maptype = "toner-lite",color = I("red"))

#usa_center <- as.numeric(geocode("United States"))
#class(usa_center)
#usa_center
#USAMap <- ggmap(get_googlemap(center = usa_center,scale = 2, zoom = 4),extent = "normal")
#USAMap
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

genDataMap<-function(x) {

  annual_all_2016 <- read_csv(x)
  
  head(annual_all_2016)
  names(annual_all_2016)
  library(dplyr)
  #getting required data parameters, including only those that have been completed
  reqData<-select(annual_all_2016,`Year`,`Parameter Name`, `Observation Count`,`Arithmetic Mean`,`Completeness Indicator`,`Sample Duration` ,`State Name`, `County Name`, `City Name`,`Latitude`,`Longitude`,`Primary Exceedance Count`)%>%filter(`Completeness Indicator`!='N')
  head(reqData)
  
  library(leaflet)
library(RColorBrewer)
library(plyr)
colorCount<-plyr::count(reqData$`Parameter Name`)
#colorCount
#nrow(colorCount)
labelTitles <- sample_n(tbl_df(reqData$`Parameter Name`),5)
m<-leaflet() %>% addTiles() %>% setView(-72.690940, 41.651426, zoom = 8) %>% addCircles(lng=reqData$Longitude, lat=reqData$Latitude,radius = reqData$`Observation Count`,color = palette(rainbow(nrow(colorCount))),opacity = reqData$`Arithmetic Mean`,fill = TRUE, fillColor = palette(rainbow(nrow(colorCount))),popup=paste(reqData$`State Name`, reqData$`County Name`, reqData$`City Name`, reqData$`Parameter Name`,sep = " | "))%>% highlightOptions(stroke = NULL, color = labelTitles, weight = 5, opacity = 0.75, fill = TRUE, fillColor = labelTitles, bringToFront = TRUE)
m 
}
genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_1995.csv")
genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2000.csv")
genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2005.csv")
genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2010.csv")
genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2016.csv")
#%>% addLegend(position='bottomright', colors = labelTitles,labels = labelTitles, title = 'Pollution data') 
#palette(rainbow(nrow(colorCount)))


#m <- leaflet(reqData) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
                              #attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') 
#m %>% setView(-95.71289,37.09024, zoom = 8)
#m %>% addCircles(lng = reqData$Longitude, lat = reqData$Latitude, popup=reqData$`Parameter Name`, weight = 3, radius=40, 
                 #color="#ffa500", stroke = TRUE, fillOpacity = 0.8)
#m

#library(plotly)
#l <- list(color = "rgba(255,255,255,1)", width = 1)
#g <- list(scope = 'usa')
#per_million_plot <- plot_ly(tbl_df(reqData$`Arithmetic Mean`), z = reqData$`Arithmetic Mean`, text = paste(reqData$`State Name`, reqData$`County Name`, reqData$`City Name`, reqData$`Parameter Name`,sep = " | "), locations = reqData$`State Name`, type = 'choropleth',
#                            locationmode = 'USA-states', color = reqData$`Arithmetic Mean`, colors = 'Purples',
#                            marker = list(line = l), colorbar = list(title = "Pollution choropleth", lenmode = "pixels",
#                                                                     titleside = "right", xpad = 0, ypad = 0)) %>%
#  layout(title = 'Pollution data for 2016', geo = g)

#per_million_plot

genPlotChoro<-function(x){
  library(plotly)
  annual_all_2016 <- read_csv(x)
  library(dplyr) 
  reqData<-select(annual_all_2016,`State Code`,`Year`,`Parameter Name`, `Observation Count`,`Arithmetic Mean`,`Completeness Indicator`,`Sample Duration` ,`State Name`, `County Name`, `City Name`,`Latitude`,`Longitude`,`Primary Exceedance Count`)%>%filter(`Completeness Indicator`!='N')  
  reqData$hover<-with(reqData,paste(`State Name`,'<br>',`Parameter Name`, '<br>', `Primary Exceedance Count`, '<br>', `Year`, '<br>' ))
  
  l<-list(color = toRGB("white"), width = 2)    

  g<-list(scope = 'usa', projection = list(type = 'albers usa'),showlakes = TRUE, lakecolor = toRGB('white'))
  
  #p<-plot_geo(reqData, locationmode = 'USA-states') %>% add_trace(z = ~`Primary Exceedance Count`, text = ~hover, locations = ~`State Code`,color = ~'Primary Exceedance Count',colors = 'Purples') %>% colorbar(title = "Pollution data") %>% layout(title = '2016 Air pollution data', geo = g)
  p <- plot_geo(reqData, locationmode = 'USA-states') %>%
    add_trace(
      z = reqData$`Primary Exceedance Count`, text = reqData$hover, locations = reqData$`State Code`,
      color = reqData$`Primary Exceedance Count`, colors = 'Purples'
    ) %>%
    colorbar(title = "Millions USD") %>%
    layout(
      title = 'Test choropleth',
      geo = g
    )
  
  
  p
}

genPlotChoro("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_1995.csv")
