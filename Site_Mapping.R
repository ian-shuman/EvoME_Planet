rm(list = ls())

# Load necessary libraries
library(sf)
library(dplyr)
library(readr)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)

# Read CSV file of sites
sites_csv <- read_csv("Sites/EvoME Sites.csv", col_select = c("River-ID", "Lat", "Long"))
sites_csv <- na.omit(sites_csv)

# Convert the data frame to an sf object
sites_sf <- st_as_sf(sites_csv, coords = c("Long", "Lat"), crs = 4326)

# Transform the CRS to a projected CRS for accurate distance calculations
sites_sf <- st_transform(sites_sf, crs = 3338) #CRS for NAD83 / Alaska Albers 

# Create a buffer of 500 meters around each point
buffers <- st_buffer(sites_sf, dist = 500)

# Save each buffer as a separate shapefile
buffers %>%
  split(.$`River-ID`) %>%
  purrr::iwalk(~ st_write(.x, paste0("Sites/",.y, ".shp")))


# Map of Alaska and major rivers
world <- ne_states(country = "United States of America", returnclass = "sf")
alaska <- world[world$name == "Alaska", ]
rivers <- ne_download(scale = 10, type = 'rivers_lake_centerlines', category = 'physical', returnclass = "sf")


#Plot
ggplot() +
  ggplot2::geom_sf(data = alaska, color = 'black', linewidth = 1) +
  geom_sf(data = buffers, fill = "lightblue", color = "blue", alpha = 0.5) +
  geom_sf(data = rivers, fill = "lightblue", color = "blue", alpha = 0.5) +
  theme_minimal() +
  labs(title = "EvoME Sites",
       x = "Longitude",
       y = "Latitude")+
  ggplot2::coord_sf(crs = 'EPSG:3338', ylim = c(1733539, 2340581), xlim = c(100000, 300000))
  
  




