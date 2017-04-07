#Methods to Plot Choropleth Maps in R  
load(url("http://www.fabioveronesi.net/Blog/polygons.RData"))  

#Standard method  
#SP PACKAGE  
library(sp)  
spplot(polygons,"CO2",main=paste("CO2 Emissions - Year:",CO2.year),sub="Metric Tons per capita")  


#PLOT METHOD  
library(plotrix)  
CO2.dat <- na.omit(polygons$CO2)  
colorScale <- color.scale(CO2.dat,color.spec="rgb",extremes=c("red","blue"),alpha=0.8)  

colors.DF <- data.frame(CO2.dat,colorScale)  
colors.DF <- colors.DF[with(colors.DF, order(colors.DF[,1])), ]  
colors.DF$ID <- 1:nrow(colors.DF)  
breaks <- seq(1,nrow(colors.DF),length.out=10)  


jpeg("CO2_Emissions.jpg",7000,5000,res=300)  
plot(polygons,col=colorScale)  
title("CO2 Emissions",cex.main=3)  

legend.pos <- list(x=-28.52392,y=-20.59119)  
legendg(legend.pos,legend=c(round(colors.DF[colors.DF$ID %in% round(breaks,0),1],2)),fill=paste(colors.DF[colors.DF$ID %in% round(breaks,0),2]),bty="n",bg=c("white"),y.intersp=0.75,title="Metric tons per capita",cex=0.8)   

dev.off()  





#INTERACTIVE MAPS  
#googleVis PACKAGE  
library(googleVis)  

data.poly <- as.data.frame(polygons)  
data.poly <- data.poly[,c(5,12)]  
names(data.poly) <- c("Country Name","CO2 emissions (metric tons per capita)")  

map <- gvisGeoMap(data=data.poly, locationvar = "Country Name", numvar='CO2 emissions (metric tons per capita)',options=list(width='800px',heigth='500px',colors="['0x0000ff', '0xff0000']"))  
plot(map)  

print(map,file="Map.html")  

#http://www.javascripter.net/faq/rgbtohex.htm  
#To find HEX codes for RGB colors  





#plotGoogleMaps  
library(plotGoogleMaps)  

polygons.plot <- polygons[,c("CO2","GDP.capita","NAME")]  
polygons.plot <- polygons.plot[polygons.plot$NAME!="Antarctica",]  
names(polygons.plot) <- c("CO2 emissions (metric tons per capita)","GDP per capita (current US$)","Country Name")  

#Full Page Map  
map <- plotGoogleMaps(polygons.plot,zoom=4,fitBounds=F,filename="Map_GoogleMaps.html",layerName="Economic Data")  


#To add this to an existing HTML page  
map <- plotGoogleMaps(polygons.plot,zoom=2,fitBounds=F,filename="Map_GoogleMaps_small.html",layerName="Economic Data",map="GoogleMap",mapCanvas="Map",map.width="800px",map.height="600px",control.width="200px",control.height="600px") 