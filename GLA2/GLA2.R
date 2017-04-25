#Graded Lab assignment, group 2:

#Manjul Singh Sachan (1410110228)
#Mohak Garg (1410110247)
#Nishank Saini (1410110266)



library(readr)
library(magrittr)

#function for generating yearly bar graphs
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

#actual graphing
newG<-ggplot(sample_n( reqData, 20),aes(x = `State Name`,color = `State Name`,fill = `State Name`)) + geom_bar()

library(plotly)
ggplotly(newG)
return(newG)
}
#loading the function with different .csv files
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

#plotting the pollution across the states
genDataMap<-function(x) {

  annual_all_2016 <- read_csv(x)
  
  head(annual_all_2016)
  names(annual_all_2016)
  library(dplyr)
  library(rgdal)
  #getting required data parameters, including only those that have been completed
  shapeFile<-readOGR(dsn=".",layer="cb_2013_us_county_20m",stringsAsFactors = FALSE)
  reqData<-select(annual_all_2016,`Year`,`Parameter Name`, `Observation Count`,`Arithmetic Mean`,`Completeness Indicator`,`State Code`,`County Code`,`Sample Duration` ,`State Name`, `County Name`, `City Name`,`Latitude`,`Longitude`,`Primary Exceedance Count`)%>%filter(`Completeness Indicator`!='N')
  
  head(reqData)
  
library(leaflet)
library(RColorBrewer)
library(plyr)
colorCount<-plyr::count(reqData$`Parameter Name`)
#colorCount
#nrow(colorCount)
labelTitles <- sample_n(tbl_df(reqData$`Parameter Name`),5)
reqData$`State Code`<-format(reqData$`State Code`,width = 2, format = "d", flag="0")
reqData$`County Code`<-format(reqData$`County Code`,width = 3, format = "d", flag="0")
reqData$geoID<-paste(reqData$`State Code`,reqData$`County Code`,sep="")
#m<-merge(shapeFile,reqData$`Primary Exceedance Count`,)
exceedCount<-aggregate(formula=reqData$`Primary Exceedance Count`~reqData$geoID,data = reqData,FUN = mean)
colnames(exceedCount)<-c("GEOID","exceed")
mergeStuff<-merge(shapeFile,exceedCount,by=c("GEOID"))
pal<-colorQuantile("Greens",NULL,n=9)
m<-leaflet() %>% addTiles() %>% setView(-72.690940, 41.651426, zoom = 8) %>% addCircles(lng=reqData$Longitude, lat=reqData$Latitude,radius = reqData$`Observation Count`,color = colorQuantile("plasma", NULL, n = 9),opacity = reqData$`Arithmetic Mean`,fill = TRUE, fillColor = colorQuantile("plasma", NULL, n = 9),popup=paste(reqData$`State Name`, reqData$`County Name`, reqData$`City Name`, reqData$`Parameter Name`,sep = " | "))%>% highlightOptions(stroke = NULL, color = labelTitles, weight = 5, opacity = 0.75, fill = TRUE, fillColor = labelTitles, bringToFront = TRUE)
#m<-leaflet(data=mergeStuff) %>% addTiles() %>% addPolygons(fillColor=~pal(exceedCount),fillOpacity=0.8,color="#BDBDC3",weight=1)
return (m)
}

#differing data sets used
map1995<-genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_1995.csv")
map2000<-genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2000.csv")
map2005<-genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2005.csv")
map2010<-genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2010.csv")
map2016<-genDataMap("/home/starship9/Desktop/SNU/Data Mining/CSD342_DataMining/GLA2/annual_all_2016.csv")

print(map1995)
print(map2000)
print(map2005)
print(map2010)
print(map2016)
#library(htmlwidgets)
#saveWidget(map1995, file = "map1995.html", selfcontained = F)

#saveWidget(map2000, file = "map2000.html", selfcontained = F)

#saveWidget(map2010, file = "map2010.html", selfcontained = F)

#saveWidget(map2016, file = "map2016.html", selfcontained = F)

#saveWidget(map2005, file = "map2005.html", selfcontained = F)


#generating choropleth
library(sp)
library(rgdal)
library(maptools)
library(dplyr)
library(leaflet)
library(scales)

### Begin data prep


##BEGIN PARSING 2016 DATA
dat <- read.csv('annual_all_2016.csv', stringsAsFactors = FALSE)
# Colnames tolower
names(dat) <- tolower(names(dat))
county_dat <- subset(dat, parameter.code == "88101", select = c("state.code", "county.code", "county.name", "parameter.name", "arithmetic.mean"))

# Format the state and county codes
county_dat$county.code <- formatC(county_dat$county.code, width = 3, format = "d", flag = "0")
county_dat$state.code <- formatC(county_dat$state.code, width = 2, format = "d", flag = "0")
#merge them in a new column
county_dat$fsid<-paste(county_dat$state.code, county_dat$county.code, sep="")

#take the mean of ozone for each county
meanval <- aggregate(formula=county_dat$arithmetic.mean~county_dat$fsid, data = county_dat, FUN=mean)

# Rename columns to make for a clean df merge later.
colnames(meanval) <- c("GEOID", "airqlty")
### End data prep

us.map <- readOGR(dsn = ".", layer = "cb_2013_us_county_20m", stringsAsFactors = FALSE)

# Remove Alaska(2), Hawaii(15), Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60)
#  Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
us.map <- us.map[!us.map$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                        "64", "68", "70", "74"),]
# Make sure other outling islands are removed.
us.map <- us.map[!us.map$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                        "95", "79"),]
# Merge spatial df with downloade ddata.
leafmap <- merge(us.map, meanval, by=c("GEOID"))

# Format popup data for leaflet map.
popup_dat <- paste0("<strong>County: </strong>", 
                    leafmap$NAME, 
                    "<br><strong>Value: </strong>", 
                    leafmap$airqlty)

#END PARSING 2016 DATA

#PARSING 2000 DATA

dat2000 <- read.csv('annual_all_2000.csv', stringsAsFactors = FALSE)
# Colnames tolower
names(dat2000) <- tolower(names(dat2000))
county_dat2000 <- subset(dat2000, parameter.code == "88101", select = c("state.code", "county.code", "county.name", "parameter.name", "arithmetic.mean"))

# Format the state and county codes
county_dat2000$county.code <- formatC(county_dat2000$county.code, width = 3, format = "d", flag = "0")
county_dat2000$state.code <- formatC(county_dat2000$state.code, width = 2, format = "d", flag = "0")
#merge them in a new column
county_dat2000$fsid<-paste(county_dat2000$state.code, county_dat2000$county.code, sep="")

#take the mean of ozone for each county
meanval2000 <- aggregate(formula=county_dat2000$arithmetic.mean~county_dat2000$fsid, data = county_dat2000, FUN=mean)

# Rename columns to make for a clean df merge later.
colnames(meanval2000) <- c("GEOID", "airqlty2000")
### End data prep

us.map <- readOGR(dsn = ".", layer = "cb_2013_us_county_20m", stringsAsFactors = FALSE)

# Remove Alaska(2), Hawaii(15), Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60)
#  Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
us.map <- us.map[!us.map$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                        "64", "68", "70", "74"),]
# Make sure other outling islands are removed.
us.map <- us.map[!us.map$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                        "95", "79"),]
# Merge spatial df with downloade ddata.
leafmap2000 <- merge(us.map, meanval2000, by=c("GEOID"))

# Format popup data for leaflet map.
popup_dat2000 <- paste0("<strong>County: </strong>", 
                    leafmap2000$NAME, 
                    "<br><strong>Value: </strong>", 
                    leafmap2000$airqlty2000)

#END PARSING

#PARSE 2005
dat2010 <- read.csv('annual_all_2010.csv', stringsAsFactors = FALSE)
# Colnames tolower
names(dat2010) <- tolower(names(dat2010))
county_dat2010 <- subset(dat2010, parameter.code == "88101", select = c("state.code", "county.code", "county.name", "parameter.name", "arithmetic.mean"))

# Format the state and county codes
county_dat2010$county.code <- formatC(county_dat2010$county.code, width = 3, format = "d", flag = "0")
county_dat2010$state.code <- formatC(county_dat2010$state.code, width = 2, format = "d", flag = "0")
#merge them in a new column
county_dat2010$fsid<-paste(county_dat2010$state.code, county_dat2010$county.code, sep="")

#take the mean of ozone for each county
meanval2010 <- aggregate(formula=county_dat2010$arithmetic.mean~county_dat2010$fsid, data = county_dat2010, FUN=mean)

# Rename columns to make for a clean df merge later.
colnames(meanval2010) <- c("GEOID", "airqlty2010")
### End data prep

us.map <- readOGR(dsn = ".", layer = "cb_2013_us_county_20m", stringsAsFactors = FALSE)

# Remove Alaska(2), Hawaii(15), Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60)
#  Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
us.map <- us.map[!us.map$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                        "64", "68", "70", "74"),]
# Make sure other outling islands are removed.
us.map <- us.map[!us.map$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                        "95", "79"),]
# Merge spatial df with downloade ddata.
leafmap2010 <- merge(us.map, meanval2010, by=c("GEOID"))

# Format popup data for leaflet map.
popup_dat2010 <- paste0("<strong>County: </strong>", 
                        leafmap2010$NAME, 
                        "<br><strong>Value: </strong>", 
                        leafmap2010$airqlty2010)

#END PARSE

#BEGIN PARSE
dat2005 <- read.csv('annual_all_2005.csv', stringsAsFactors = FALSE)
# Colnames tolower
names(dat2005) <- tolower(names(dat2005))
county_dat2005 <- subset(dat2005, parameter.code == "88101", select = c("state.code", "county.code", "county.name", "parameter.name", "arithmetic.mean"))

# Format the state and county codes
county_dat2005$county.code <- formatC(county_dat2005$county.code, width = 3, format = "d", flag = "0")
county_dat2005$state.code <- formatC(county_dat2005$state.code, width = 2, format = "d", flag = "0")
#merge them in a new column
county_dat2005$fsid<-paste(county_dat2005$state.code, county_dat2005$county.code, sep="")

#take the mean of ozone for each county
meanval2005 <- aggregate(formula=county_dat2005$arithmetic.mean~county_dat2005$fsid, data = county_dat2005, FUN=mean)

# Rename columns to make for a clean df merge later.
colnames(meanval2005) <- c("GEOID", "airqlty2005")
### End data prep

us.map <- readOGR(dsn = ".", layer = "cb_2013_us_county_20m", stringsAsFactors = FALSE)

# Remove Alaska(2), Hawaii(15), Puerto Rico (72), Guam (66), Virgin Islands (78), American Samoa (60)
#  Mariana Islands (69), Micronesia (64), Marshall Islands (68), Palau (70), Minor Islands (74)
us.map <- us.map[!us.map$STATEFP %in% c("02", "15", "72", "66", "78", "60", "69",
                                        "64", "68", "70", "74"),]
# Make sure other outling islands are removed.
us.map <- us.map[!us.map$STATEFP %in% c("81", "84", "86", "87", "89", "71", "76",
                                        "95", "79"),]
# Merge spatial df with downloade ddata.
leafmap2005 <- merge(us.map, meanval2005, by=c("GEOID"))

# Format popup data for leaflet map.
popup_dat2005 <- paste0("<strong>County: </strong>", 
                        leafmap2005$NAME, 
                        "<br><strong>Value: </strong>", 
                        leafmap2005$airqlty2005)


#END PARSE

#END DATA
pal <- colorQuantile("YlOrRd", NULL, n = 9)
# Render final map in leaflet.
polMap<-leaflet() %>% addTiles() %>%
  addPolygons(data = leafmap,fillColor = ~pal(airqlty), 
              fillOpacity = 0.8, 
              color = "#BDBDC3", 
              weight = 1,
              group = "2016",
              popup = popup_dat) %>% addPolygons(data = leafmap2010,fillColor = ~pal(airqlty2010), 
                                                 fillOpacity = 0.8, 
                                                 color = "#BDBDC3", 
                                                 weight = 2,
                                                 group = "2010",
                                                 popup = popup_dat2010)%>% addPolygons(data = leafmap2005,fillColor = ~pal(airqlty2005), 
                                                 fillOpacity = 0.8, 
                                                 color = "#BDBDC3", 
                                                 weight = 3,
                                                 group = "2005",
                                                 popup = popup_dat2005)%>% 
                                                  addPolygons(data = leafmap2000,fillColor = ~pal(airqlty2000), 
                                                 fillOpacity = 0.8, 
                                                 color = "#BDBDC3", 
                                                 weight = 4,
                                                 group = "2000",
                                                 popup = popup_dat2000) %>% addLayersControl(
                                                   baseGroups = c("2016","2010","2005", ## group 1
                                                                  "2000" ## group 2
                                                   ),
                                                   options = layersControlOptions(collapsed = FALSE)) 
print(polMap)

library(htmlwidgets)
saveWidget(polMap, file = "polMap.html", selfcontained = F)


library(dplyr)

#plotting line/pie graphs

#getting the total amount of pollution for a particular year
s2016<-sum(dat$arithmetic.mean)
s2000<-sum(dat2000$arithmetic.mean)
s2010<-sum(dat2010$arithmetic.mean)
s2005<-sum(dat2005$arithmetic.mean)

arithSum<-c(s2000,s2005,s2010,s2016)
years<-c("2000","2005","2010","2016")


#getting total particulate matter
testDF<-subset(dat,parameter.code=="88101",select = ("arithmetic.mean"))
#testDF
sum2016<-mean(testDF$arithmetic.mean)
testDF2000<-subset(dat2000,parameter.code=="88101",select = ("arithmetic.mean"))
#testDF
sum2000<-mean(testDF2000$arithmetic.mean)
testDF2005<-subset(dat2005,parameter.code=="88101",select = ("arithmetic.mean"))
#testDF
sum2005<-mean(testDF2005$arithmetic.mean)
testDF2010<-subset(dat2010,parameter.code=="88101",select = ("arithmetic.mean"))
#testDF
sum2010<-mean(testDF2010$arithmetic.mean)

paramSum<-c(sum2000,sum2005,sum2010,sum2016)

#getting ozone data
testDFozone<-subset(dat,parameter.code=="42601",select = ("arithmetic.mean"))
#testDF
sum2016ozone<-mean(testDFozone$arithmetic.mean)
testDF2000ozone<-subset(dat2000,parameter.code=="42601",select = ("arithmetic.mean"))
#testDF
sum2000ozone<-mean(testDF2000$arithmetic.mean)
testDF2005ozone<-subset(dat2005,parameter.code=="42601",select = ("arithmetic.mean"))
#testDF
sum2005ozone<-mean(testDF2005ozone$arithmetic.mean)
testDF2010ozone<-subset(dat2010,parameter.code=="42601",select = ("arithmetic.mean"))
#testDF
sum2010ozone<-mean(testDF2010ozone$arithmetic.mean)

#CO!
testDFco<-subset(dat,parameter.code=="42101",select = ("arithmetic.mean"))
#testDF
sum2016co<-mean(testDFco$arithmetic.mean)
testDF2000co<-subset(dat2000,parameter.code=="42101",select = ("arithmetic.mean"))
#testDF
sum2000co<-mean(testDF2000co$arithmetic.mean)
testDF2005co<-subset(dat2005,parameter.code=="42101",select = ("arithmetic.mean"))
#testDF
sum2005co<-mean(testDF2005co$arithmetic.mean)
testDF2010co<-subset(dat2010,parameter.code=="42101",select = ("arithmetic.mean"))
#testDF
sum2010co<-mean(testDF2010co$arithmetic.mean)



coSum<-c(sum2000co,sum2005co,sum2010co,sum2016co)
paramSum<-c(sum2000,sum2005,sum2010,sum2016)
ozoneSum<-c(sum2000ozone,sum2005ozone,sum2010ozone,sum2016ozone)



dataFrame<-data.frame(paramSum,years,arithSum, ozoneSum,coSum)
#genChoro("annual_all_2016.csv")
library(plotly)
lineP<-plot_ly(dataFrame,x = ~years, y = ~paramSum, name = 'particulate matter count',type = 'scatter', mode = 'lines') %>% add_trace(y = ~coSum,name = 'carbon monoxide quantity',mode='line') %>% add_trace(y = ~ozoneSum,name='ozone quantity',mode='line')
lineP

p <- plot_ly(dataFrame, labels = ~rownames(dataFrame), values = ~coSum, type = 'pie') %>%
  layout(title = 'Yearly Carbon monoxide distribution',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
p

ozoneP <- plot_ly(dataFrame, labels = ~rownames(dataFrame), values = ~ozoneSum, type = 'pie') %>%
  layout(title = 'Yearly Ozone distribution',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
ozoneP
#genChoro("annual_all_1995.csv")
#genChoro("annual_all_2005.csv")
#genChoro("annual_all_2010.csv")
