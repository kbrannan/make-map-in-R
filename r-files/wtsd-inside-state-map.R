# script reads the state boundary shapefile, transforms crs to one used 
# by Google Maps and uses bounding box of state boundary to get map tile from 
# Google Maps to get backgound image for the map
# created by Kevin Brannan 2016-04-21

#load packages
library(grid)
library(ggplot2)
library(ggmap)


## path for making map
chr.make.map.dir <- "M:/GIS/BacteriaTMDL/rscripts/make-map-in-R"

## load state bnd data
load(file = paste0(chr.make.map.dir, 
                  "/data-files/state-bnd.RData"))

## load wtsd bnd data
load(file = paste0(chr.make.map.dir, 
                   "/data-files/wtsd-bnd-upper-yaquina.RData"))
## coords for arrows
gm.state.bb <- as.numeric(attr(gm.state.bnd, which = "bb"))
df.arrow <- data.frame(x = mean(sp.wtsd.bnd.g@bbox[1, ]), 
                       xend = gm.state.bb[4] + (gm.state.bb[2] - gm.state.bb[4]) / 2,
                       y = mean(sp.wtsd.bnd.g@bbox[2, ]),
                       yend.bot =  mean(gm.state.bb[c(1,3)]),
                       yend.top =  
                         0.5 * (gm.state.bb[3] - mean(gm.state.bb[c(1,3)])) +
                         mean(gm.state.bb[c(1,3)]))
## plot google map tile and state boundary
p.state <- ggmap(gm.state.bnd, extent="device") + 
  geom_path(data = df.state.bnd,
            aes(x = long, y = lat, group=group), 
            colour = "black") + 
  geom_segment(data = df.arrow,
               aes(x = x, xend = xend,
                   y = y, yend = yend.bot, arrow=arrow(type = "closed")),
               size = 0.75) +
  geom_segment(data = df.arrow,
               aes(x = x, xend = xend,
                   y = y, yend = yend.top),
               size = 1) +
geom_polygon(data = sp.wtsd.bnd.g,
             aes(x = long, y = lat, group=group),
             fill = "red")



## plot google map tile and watershed boundary
p.wtsd <- ggmap(gm.wtsd.bnd, extent="device") + 
  geom_path(data = sp.wtsd.bnd.g,
            aes(x = long, y = lat, group=group), 
            colour = "red", size = 1.25) +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1.5)) +
  scale_x_continuous(expand = c(0.05,0), limits=range(sp.wtsd.bnd.g@bbox[1,])) +
  scale_y_continuous(expand = c(0.05,0), limits=range(sp.wtsd.bnd.g@bbox[2,]))


## plot map in map
plot.new()
plot(p.state)
print(p.wtsd, vp=viewport(x = 0.5, y = 0.7, 
                          width = 0.5, height = 0.5, just = "left"))

## start of arrows
arr.bgn <- c(mean(sp.wtsd.bnd.g@bbox[2, ]), mean(sp.wtsd.bnd.g@bbox[1, ]))
## end of arrows
gm.state.bb <- attr(gm.state.bnd, which = "bb")
arr.bot.end <- gm.state.bb[1:2]
arr.top.end <- c(gm.state.bb[1] + (gm.state.bb[3] -  gm.state.bb[1]) / 2,
                 gm.state.bb[2])
arr.top.end

  

