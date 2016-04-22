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


# dns and layer for the watershed boundary shape file
dns.wtsd <- "m:/GIS/BacteriaTMDL/Mult_Basins/StreamStats/FreshwaterBacteriaStations/shapefiles"
name.wtsd <- "st34456WatershedOR"

# read watershed boundary into spatial.data.frame
sp.wtsd.bnd <- readOGR(dsn = dns.wtsd, layer = name.wtsd)

## get the projection arguments for the Google Maps crs
google.proj4string <- CRS("+init=epsg:4326")

## transform state boundary to Google Maps crs
sp.wtsd.bnd.g <- spTransform(sp.wtsd.bnd, google.proj4string)


## calculate the lon and lat of the center for the Google Maps tile from the
## bounding box of the state boundary
center <- c(mean(sp.wtsd.bnd.g@bbox[1,]), mean(sp.wtsd.bnd.g@bbox[2,]))

# calculate the zoom level for the Google Maps tile from the state boundary
# bounding box
zoom <- min(MaxZoom(range(sp.wtsd.bnd.g@bbox[2,]), 
                    range(sp.wtsd.bnd.g@bbox[1,])))

# get the Google Maps tile to use as background
gm.wtsd.bnd <- get_googlemap(center = center, size = c(640, 640), 
                        zoom=zoom, maptype="roadmap")

## get mid-coast boundary
dns.md <- "m:/GIS/shapefiles/HUC"
name.md <- "MidCoast_HUC08_with_ocean"

# read watershed boundary into spatial.data.frame
sp.md.bnd <- readOGR(dsn = dns.md, layer = name.md)

## get the projection arguments for the Google Maps crs
google.proj4string <- CRS("+init=epsg:4326")

## transform state boundary to Google Maps crs
sp.md.bnd.g <- spTransform(sp.md.bnd, google.proj4string)


## plot google map tile and watershed boundary
ggmap(gm.wtsd.bnd, extent="device") + 
  geom_polygon(data = sp.md.bnd.g,
            aes(x = long, y = lat), 
            fill = "green") +
  geom_path(data = sp.wtsd.bnd.g,
               aes(x = long, y = lat, group=group), 
            colour = "red", size = 1.25)

## save data
save(sp.wtsd.bnd.g, gm.wtsd.bnd, 
     file = paste0(chr.make.map.dir, 
                   "/data-files/wtsd-bnd-upper-yaquina.RData"))


