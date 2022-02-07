#' IPBES Sustainable Use Assessment - Figure Chapter 3 - Global Fisheries by Coastline
#' 
#' This R script reproduces the Figure 'Global Fisheries by Coastline' of the 
#' chapter 3 of the IPBES Sustainable Use Assessment. This figure shows the 
#' global relative abundance of fisheries by coastline.
#' 
#' @author Nicolas Casajus <nicolas.casajus@fondationbiodiversite.fr>
#' @date 2022/02/07



## Install `remotes` package ----

if (!("remotes" %in% installed.packages())) install.packages("remotes")


## Install required packages (listed in DESCRIPTION) ----

remotes::install_deps(upgrade = "never")


## Load project dependencies ----

devtools::load_all(".")


## Robinson projection ----

robinson <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"


## Colors ----

col_sea  <- "#e5f1f6"
col_grat <- "#bfdde9"

# couleurs <- RColorBrewer::brewer.pal(9, "YlOrRd")
# couleurs <- rev(colorRampPalette(couleurs)(10))
couleurs <- c("#EA3223", "#F6C243", "#FFFD54", "#DFFC52", "#91FA4D")
couleurs <- colorRampPalette(couleurs)(10)


## Abundance classes ----

increment <- 0.1

cats <- data.frame(from = seq(0            , 1 - increment, by = increment),
                   to   = seq(0 + increment, 1            , by = increment))


## Import data to map ----

x <- readr::read_csv(here::here("data", "fisheries_governance_survey.csv"))
x <- as.data.frame(x)
x <- x[ , c("Country", "Abundance")]


## Rename countries names ----

x[which(x$"Country" == "U.K."), "Country"] <- "United Kingdom"


## Import EEZ boundaries ----

eez <- sf::st_read(here::here("data", "World_EEZ_v11_20191118_gpkg", 
                              "eez_v11.gpkg"))


## Import World country boundary ----

world <- rnaturalearth::ne_download(scale = "large", type = "land", 
                                    category = "physical", returnclass = "sf")


## Import global ocean -----

ocean <- sf::st_read(here::here("data", "ne_50m_ocean", "ne_50m_ocean.shp"))


## Merge data with EEZ ----

eez <- merge(eez, x, by.x = "SOVEREIGN1", by.y = "Country", all = TRUE)


## Project layers ----

eez   <- sf::st_transform(eez,   crs = robinson)
world <- sf::st_transform(world, crs = robinson)
ocean <- sf::st_transform(ocean, crs = robinson)


## Map guides ----

frame <- map_frame(crs = robinson)
grats <- map_graticules(crs = robinson)
axes  <- map_axes(crs = robinson)


## Crop layers with map extent ----

options(warn = -1)

world <- sf::st_intersection(world, frame)
ocean <- sf::st_intersection(ocean, frame)

options(warn = 0)


## Mapping ----

ragg::agg_png(filename   = here::here("figures", "ipbes-su-chap3-coastline_fisheries.png"), 
              width      = 14.00, 
              height     =  8.00, 
              units      = "in", 
              res        = 600, 
              pointsize  = 18,
              background = "white")

par(mar = c(1, 1, 1, 1), family = "Roboto")


## Base map ----

plot(sf::st_geometry(frame), border = NA, col = NA)
plot(sf::st_geometry(ocean), border = col_grat, col = col_sea, lwd = 0.2, add = TRUE)
plot(sf::st_geometry(grats), col = col_grat, lwd = 0.2, add = TRUE)
plot(sf::st_geometry(world), border = NA, col = "white", lwd = 0.2, add = TRUE)


## Add data ----

for (i in 1:nrow(cats)) {
  
  pos <- which(eez[ , "Abundance", drop = TRUE] >= cats[i, "from"] & 
                 eez[ , "Abundance", drop = TRUE] < cats[i, "to"])
  
  if (length(pos)) {
    plot(sf::st_geometry(eez[pos, ]), col = couleurs[i], border = "black", 
         lwd = 0.2, add = TRUE) 
  }
}


## Hack - Add Peru (don't know why) ----

pos <- which(eez$"SOVEREIGN1" == "Peru")
plot(sf::st_geometry(eez[pos, ]), col = couleurs[7], border = "black", 
     lwd = 0.2, add = TRUE)


## Add missing data ----

pos <- which(is.na(eez$"Abundance"))
plot(sf::st_geometry(eez[pos, ]), col = "#eeeeee", border = "black", 
     lwd = 0.2, add = TRUE)


## Add frame ----

plot(sf::st_geometry(frame), border = "white", col = NA, lwd = 4, add = TRUE, 
     xpd = TRUE)
plot(sf::st_geometry(frame), border = "black", col = NA, lwd = 1, add = TRUE, 
     xpd = TRUE)


## Add Axes ----

text(axes[axes$"side" == 1, c("x", "y")], axes[axes$"side" == 1, "text"], 
     pos = 1, xpd = TRUE, cex = 0.5, col = "#666666")
text(axes[axes$"side" == 2, c("x", "y")], axes[axes$"side" == 2, "text"], 
     pos = 2, xpd = TRUE, cex = 0.5, col = "#666666")
text(axes[axes$"side" == 3, c("x", "y")], axes[axes$"side" == 3, "text"], 
     pos = 3, xpd = TRUE, cex = 0.5, col = "#666666")
text(axes[axes$"side" == 4, c("x", "y")], axes[axes$"side" == 4, "text"], 
     pos = 4, xpd = TRUE, cex = 0.5, col = "#666666")


## Legend position ----

x_start <- -12000000
y_start <- -5500000
x_inc   <- 400000
y_inc   <- 300000


## Add legend ----

rect(x_start, y_start - y_inc, x_start + x_inc * 10, y_start + y_inc,
     border = "white", col = "white", lwd = 2)

for (i in 1:length(couleurs)) {
  
  rect(x_start + x_inc * (i - 1), 
       y_start - y_inc, 
       x_start + x_inc * i, 
       y_start + y_inc,
       border = NA, col = couleurs[i])
}


## Add legend labels ----

text(x_start, y_start - y_inc / 2, "0.0", pos = 1, cex = 0.65)
text(x_start + x_inc * 5, y_start - y_inc / 2, "0.5", pos = 1, cex = 0.65)
text(x_start + x_inc * 10, y_start - y_inc / 2, "1.0", pos = 1, cex = 0.65)


## Add legend title ----

text(x_start + x_inc * 5, y_start + y_inc / 2, 
     "Relative abundance\nof fisheries", pos = 3, cex = 0.65, font = 2)


## Save graphic ----

dev.off()

