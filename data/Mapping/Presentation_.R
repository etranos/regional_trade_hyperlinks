library(readr)
library(dplyr)
library(RColorBrewer)
library(rgdal)
library(ggplot2)

NUTS210_2007 <- read_csv("NUTS210_2007.csv", col_types = cols(X1 = col_skip()))
shapefile<- readOGR(dsn=path.expand("shp"), layer="NUTS_Level_2_January_2018_Full_Clipped_Boundaries_in_the_United_Kingdom")
mapdata <- tidy(shapefile, region="nuts218cd")
centroids <- SpatialPointsDataFrame(coordinates(shapefile), data = as(shapefile, "data.frame")[c("nuts218cd")])
proj4string(centroids) <- CRS("+init=epsg:4326")
overall <- merge(NUTS210_2007, centroids, by.x = "origin", by.y = "nuts218cd")
overall <- merge(overall, centroids, by.x = "destination", by.y= "nuts218cd") #add centroids to both origin and destination
names(overall) <- c("destination" , "origin", "weight", "OLong", "OLat", "DLong", "DLat")
heat_destination <- aggregate(NUTS210_2007$weight, #aggregate destinations for heat map
                                   by = list(NUTS210_2007$destination),
                                   FUN = sum)
names(heat_destination) <- c("id", "no.links") #rename to match mapdata
heat_test_destination_1 <- merge(mapdata, heat_destination, by="id") #merge centroids with flows
heat_test_destination_1$no.links <- log(heat_test_destination_1$no.links)

gg2 <- ggplot(heat_test_destination_1)+
  geom_polygon(aes(x = long, y = lat, group = group, fill = no.links), color = "#ff9900", size = 0.0000001)+
  coord_fixed(1)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_fill_viridis_c("no.links")+
  ggtitle("Destination NUTS2 locations of Hyperlinks")
gg2


xquiet<- scale_x_continuous("", breaks=NULL)
yquiet<-scale_y_continuous("", breaks=NULL)
quiet<-list(xquiet, yquiet)
gg <- ggplot(overall[which(overall$weight>20),], aes(OLong, OLat))+
  #The next line tells ggplot that we wish to plot line segments. The "alpha=" is line transparency and used below 
  geom_segment(aes(x=OLong, y=OLat,xend=DLong, yend=DLat, alpha=weight), col="white")+
  #Here is the magic bit that sets line transparency - essential to make the plot readable
  scale_alpha_continuous(range = c(0.03, 0.3))+
  #Set black background, ditch axes and fix aspect ratio
  theme(panel.background = element_rect(fill='black',colour='black'))+coord_equal()+quiet+
  borders("world", regions = "UK")+
  ggtitle("Links between NUTS3 in 2007")
gg
