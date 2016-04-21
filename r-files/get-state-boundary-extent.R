# script reads the state boundary shapefile, transforms crs to one used 
# by Google Maps and uses bounding box of state boundary to get map tile from 
# Google Maps to get backgound image for the map
# created by Kevin Brannan 2016-04-21

#load packages
library(rgdal)
library(ggmap)
library(raster)
library(RgoogleMaps)
library(maptools)

## path for making map
chr.make.map.dir <- "M:/GIS/BacteriaTMDL/rscripts/make-map-in-R"

## get state outline from map_data data set
df.state.bnd <- map_data("state", region = "oregon")

## get center of map and set zoom for the goog map
center <- c(mean(df.state.bnd$long), mean(df.state.bnd$lat))

# calculate the zoom level for the Google Maps tile
zoom <- min(MaxZoom(range(df.state.bnd$lat), 
                    range(df.state.bnd$long)))

# get the Google Maps tile to use as background
gm.state.bnd <- get_googlemap(center = center, size = c(640, 640), 
                        zoom=zoom, maptype="roadmap")


## plot google map tile and state boundary
ggmap(gm.state.bnd, extent="device") + 
  geom_path(data = df.state.bnd,
               aes(x = long, y = lat, group=group), 
            colour = "black")

## save data
save(df.state.bnd, gm.state.bnd, file = paste0(chr.make.map.dir, 
                                               "/data-files/state-bnd.RData"))


