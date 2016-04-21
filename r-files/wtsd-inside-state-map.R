# script reads the state boundary shapefile, transforms crs to one used 
# by Google Maps and uses bounding box of state boundary to get map tile from 
# Google Maps to get backgound image for the map
# created by Kevin Brannan 2016-04-21

#load packages
library(grid)
library(ggplot2)


## path for making map
chr.make.map.dir <- "M:/GIS/BacteriaTMDL/rscripts/make-map-in-R"

## load state bnd data
load(file = paste0(chr.make.map.dir, 
                  "/data-files/state-bnd.RData"))

## load wtsd bnd data
load(file = paste0(chr.make.map.dir, 
                   "/data-files/wtsd-bnd-upper-yaquina.RData"))

## plot google map tile and state boundary
p.state <- ggmap(gm.state.bnd, extent="device") + 
  geom_path(data = df.state.bnd,
            aes(x = long, y = lat, group=group), 
            colour = "black") + 
  geom_polygon(data = sp.wtsd.bnd.g,
               aes(x = long, y = lat, group=group),
               fill = "red")


## plot google map tile and watershed boundary
p.wtsd <- ggmap(gm.wtsd.bnd, extent="device") + 
  geom_path(data = sp.wtsd.bnd.g,
            aes(x = long, y = lat, group=group), 
            colour = "red", size = 1.25)


## plot map in map
plot.new()
plot(p.state)
print(p.wtsd, vp=viewport(.5, .7, .5, .5, just = "left"))


