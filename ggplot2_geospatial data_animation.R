# Want to add images in ggplot:
library(ggplot2)
library(ggimage)
library(gganimate)

# some data:
e <- 1e-3
s <- 1e4
t <- pi/15*cumsum(seq(e, -e, length.out = s))^4
t

ggplot() + 
  geom_spoke (aes(x=cumsum(cos(t)), y=cumsum(sin(t)), angle=t, color=t, radius=1:s%% 300), alpha=0.5) +
  scale_color_distiller(palette=15, guide="none") + 
  coord_fixed() + 
  theme_void()

#Other fun packages:
devtools::install_github("wilkelab/cowplot")
install.packages("colorspace", repos = "http://R-Forge.R-project.org")
devtools::install_github("clauswilke/colorblindr")

library(colorblindr)
cvd_grid(your_ggplot)

# Pipe operators:
# Chaining funcitons with pipe opereations:

library(dplyr)
library(magrittr)
library(tidyverse)

log(35)
35 %>% log

round(10/3, 2)
10/3 %>% round()

  # Counting names:
library(babynames)
names(babynames)
temp1 <- filter(babynames, sex=="M", name=="Taylor")
temp2 <- select(temp1, n)
temp3 <- sum(temp2)
temp3
temp2
i <- sum(select(filter(babynames, sex=="M", name=="Taylor"), n))
i

# OR

babynames %>% 
  filter (sex=="M", name=="Taylor") %>%
  select(n) %>% 
  sum

# OR

temp1 %>% 
  select(n) %>% 
  sum
# Data frame to spatial points:
library(sf)
library(rgdal)

df <- read.csv("C:/Users/Jado/Documents/EAGLE/Introduction to programming/Gorilla_ranging_data/Ranging_RDB_KRC_2020-2022.csv", header=T)
names(df)
df1 <- st_as_sf(x=df, coords = c("Longitude", "Latitude"), crs = "epsg:32735")
df1
# write geopackage:

st_write(df1, "GG_ranging_2020-2022.gpkg")


# Plotting spatial vectr objects_sp:
library(sf)
library(ggplot2)
library(rworldmap)
world <- getMap()
world

class(world)
plot(world)

rwa <- world[world$ADMIN=="Rwanda", ]
rwa
names(rwa)
head(rwa)
ggplot() + geom_polygon(data=rwa, aes(x=long, y=lat, group=rwa$SRES, fill=rwa$LDC),
                        color = "black", size =0.1) + 
  coord_map(xlim= c(29.0, 30.8), ylim=c(-3.0, -1.0))

# Other spatial plotting:
library(sf)
library(ggplot2)
library(maps)

usa<- st_as_sf(map("usa", plot = F, fill = T))
ggplot() + geom_sf(data=usa)

laea = st_crs("+proj=laea +lat_0=30 +lon_0=-95")
usa <- st_transform(usa, laea)

ggplot() + geom_sf(data=usa)

ggplot() + 
  geom_sf(data = usa, aes(fill = ID)) +
  scale_y_continuous()

# Plotting satial vector objects_sf and rnaturalearth
library(readr)
library(cowplot)
library(googleway)
library(ggplot2)
library(ggrepel)
library(ggspatial)
library(terra)
library(sf)
library(geomapdata)
library(rnaturalearth)
library(rnaturalearthdata)
library(geodata)

world <- ne_countries(scale="medium", returnclass= "sf")
class(world)

df3 <- ggplot(data=world) + geom_sf(color = "darkgrey", fill = "lightgreen")
df3

df4 <- ggplot(data=world) + geom_sf(aes(fill=pop_est)) + scale_fill_viridis_c(option = "inferno", trans = "sqrt")
df4

df5 <- ggplot(data=world) + 
  geom_sf()+ xlab ("Longitude") + ylab("Latitude") + ggtitle ("World map", subtitle = paste0("(Displaying", length(unique(world$name)), "countries)"))
df5

df6 <- ggplot(data=world) + 
  geom_sf() + 
  coord_sf(crs= "+proj=laea + lat_0=52 +lon_0=4321000 +y_0=3210000 +ellps=GRS80 + units=m + no_defs ")
df6
# plotting country:
df7 <- rwa <- world[world$name=="Rwanda", ]
ggplot(data=rwa) + geom_sf() + annotation_scale(location="bl", width_hint=0.5) + 
  annotation_north_arrow(location="bl", which_north = "true",
                         pad_x = unit(0.2, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering)
df7
ggsave("map.pdf")
ggsave("map_web_rwa.png", width=6, height=6, dpi = "screen")

# Vector susetting:
library(readr)
library(dplyr)
library(sf)
library(sp)
library(maptools)
library(rgdal)

x1 <- world
plot(world)
names(x1)

norway <- x1[x1$name == "Norway", ] + plot(norway)
sweden <- x1[x1$name == "Sweden", ] + plot(sweden)
rwa <- x1[x1$name=="Rwanda", ] + plot(rwa)

# OR
library(dplyr)
nc <- st_read(system.file("shape/nc.shp", package="sf"))
nc %>% filter(AREA>0.1) %>% plot()

# plot ten smallest countries in grey:
st_geometry(nc) %>% plot()
nc %>% select(AREA) %>% arrange(AREA) %>% slice(1:10) %>% plot(add = T, col = 'grey')

# RStoolbox package:
# extract the underlying data frame values, requires 'raster' package
library(ggplot2)
library(usethis)
library(cmsaf)
library(devtools)
library(sf)
library(sp)
library(raster)
library(terra)
library(SpatRaster)
library(RStoolbox)


df <- worldclim_global(var="tavg", res = 5, path = ".")
germany_crs <- st_transform(germany, st_crs(df))
germany_crop <- terra::crop(df, germany_crs)
plot(germany_crs)
germany_mask <- terra::mask(germany_crop, germany_crs)
plot(germany_mask)
names(germany_mask)

lsat.df <- data.frame(coordinates(germany_mask), getValues(germany_mask))

# optional: remove background if needed, not with lsat data set:
lsat.df <- lsat.df[lsat.df$B3_dn!=0, ]
  
  # plot the data and specify which band to be used
ggplot(lsat.df) + geom_raster(aes(x=x, y=y, fill=B3_dn)) + scale_fill_gradient(na.value = NA) + 
    coord_equal()

  # Adding another colour scheme:
ggplot(lsat.df) +
    geom_raster(aes(x=x, y=y, fill=B3_dn)) +
    scale_fill_gradient(low="black", hgh = "white", na.value = NA) + coord_equal()
  
# Plotting raster objects with RStoobox:
data(lsat)

# singlelayers:
plot(lsat[[1]]) #base graphics
ggR(lsat, 1) #ggplot2

# multile layers
plot(lsat)
ggR(lsat, 1:6, geom_raster = TRUE)

# plotting raster objects:
library(RStoolbox)

# RGB plot with a linear stretch:
ggRBG(lsat, 3, 2, 1, stretch = "lin")

# single layer greyscale:
ggR(lsat, layer = 4, mazpixels = 1e6, stretch = "hist")

# single layer map to user defined legend:
ggR(lsat, layer = 1, stretch = "lin", geom_raster = TRUE) +
  scale_fill_gradient(low = "blue", high = "green")

# plotting raster and vector objects:
library(rnaturalearth)
library(geodata)
library(rnaturalearthdata)

germany <- ne_countries(country="Germany", scale="medium", returnclass = "sf")
ggplot(data=germany) + geom_sf()



# vector data on top of raster data:
aa <- ggplot(data=germany) + ggR(rasterData, geom_raster=T, fflayer=T) +
  geom_sf()

# for different color scales
bb <- aa + scale_fill_manual()

# for text on map
dd <- bb + geom_text_repel()

# for scale bar

ff <- dd + scale()

# for north arrow

jj <- ff + annotation_north_arrow()

# if required:convert from sp to sf and vice vrsa

st_as_sf()

# Plotting raster and vector objects_Animove package:
library(gdal)
library(gdalraster)
library(aniMove)

data(buffalo_env)
data(buffako_utm)

# plot buffalo tracks on top of NDVI layer
buffalo_df <- data.frame(buffalo_utm)
ggp <- ggR(buffalo_env, layer="mean_NDVI", geom_raster=TRUE) +
  scale_fill_gradient(low = "gold", high = "darkgreen")

ggp + geom_path(data = buffalo_df, aes(x = coords.x1, y = coords.x2), alpha = 1)

# #Hillshade (blend focal illumination map with elevation layer)

terrainVariables <- terrain(buffalo_env[["elev"]], c("slope", "aspect"))
hillshade <- hillshade(terrainVariables$slope, terrainVariables$aspect, angle = 10)

ggR(hillshade) +
  ggR(buffalo_env, layer = "elev", alpha = 0.3, geom_raster = TRUE, ggLayer = TRUE) +
  scale_fill_gradient(name = "Elevation (m)", colors = terrain.colors(100)) +
  geom_point(data = buffalo_df, aes(x = coords.x1, y = coords.x2), 
             alpha = 0.1, size = 0.5) +
  theme(axis.text.y = element_text(angle = 90), 
        axis.title = element_blank())

# #ggplot2syntax for spatial data:
# get the extent of lsat
lim <- extent(lsat)

# use stored plot plus new plotting commands
a + 
  guides(fill=guide.colorbar()) + 
  geom_point(data=plots, aes(aes(x=V1, y=V2)), shape=3, colour="yellow") + 
               theme(axis.title.x = element_blank()) + 
               scale_x_continuous(limits=c(lim@xmin, lim@xmax)) + 
               ylim(c(lim@ymin, lim@ymax))

# Alternatively use sf functionality

ggplot(....) + geom_sf() + coord_sf(xlim = ...., ylim = ....)