# Subject: Quandl for Macroeconomics
# Author: Yang Ye
# Date: 20170511

#--#
library(magrittr)
library(Quandl)
# Pass the code string to Quandl. 
China_GDPPC <- Quandl("WWDI/CHN_NY_GDP_PCAP_KN", type = 'xts') %>% 
  # Add a nice column name
  `colnames<-`("GDP Per Capita")

# Take a look at the result.
tail(China_GDPPC, n = 6)

#--#
library(purrr)
# Create a vector of economic indicators that can be passed to Quandl via map().
# Include names and values for easy naming of xts columns.
econIndicators <- c("GDP Per Capita" = "WWDI/CHN_NY_GDP_PCAP_KN",
                    "GDP Per Capita Growth" = "WWDI/CHN_NY_GDP_PCAP_KD_ZG",
                    "Real Interest Rate" = "WWDI/CHN_FR_INR_RINR",
                    "Exchange Rate" = "WWDI/CHN_PX_REX_REER",
                    "CPI" = "WWDI/CHN_FP_CPI_TOTL_ZG",
                    "Labor Force Part. Rate" = "WWDI/CHN_SL_TLF_ACTI_ZS")

# You might want to supply your Quandl api key. It's free to get one.
Quandl.api_key("d9EidiiDWoFESfdk5nPy")

China_all_indicators <- 
  # Start with the vector of Quandl codes
  econIndicators %>% 
  # Pass them to Quandl via map(). 
  map(Quandl, type = "xts") %>% 
  # Use the reduce() function to combine them into one xts objects.
  reduce(merge) %>% 
  # Use the names from the original vector to set nicer column names.
  `colnames<-`(names(econIndicators))
# Have a look.
tail(China_all_indicators, n = 6)

#--#
library(dygraphs)
dygraph(China_all_indicators$`GDP Per Capita`, main = "GDP Per Capita")
dygraph(China_all_indicators$`GDP Per Capita Growth`, main = "GDP Per Capita Growth")
dygraph(China_all_indicators$`Real Interest Rate`, main = "Real Interest Rate")
dygraph(China_all_indicators$`Exchange Rate`, main = "Exchange Rate")
dygraph(China_all_indicators$`CPI`, main = "CPI")
dygraph(China_all_indicators$`Labor Force Part. Rate`, main = "Labor Force Part. Rate")

#--#
library(rnaturalearth)
library(sp)
library(rgeos)
world <- ne_countries(type = "countries",  returnclass = 'sf')

# Take a peek at the name, gdp_md_est column and economy columns. 
# The same way we would peek at any data frame.
head(world[c('name', 'gdp_md_est', 'economy')], n = 6)

#--#
library(leaflet)
# Create shading by GDP. Let's go with purples.
gdpPal <- colorQuantile("Purples", world$gdp_md_est, n = 20)

# Create popup country name and income group so that something happens
# when a user clicks the map.
popup <- paste0("<strong>Country: </strong>", 
                world$name, 
                "<br><strong>Market Stage: </strong>", 
                world$income_grp)

leaf_world <- leaflet(world) %>%
  addProviderTiles("CartoDB.Positron") %>% 
  setView(lng =  20, lat =  15, zoom = 2) %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = .7, 
              # Note the layer ID. Not a country name! It's a country code!
              color = ~gdpPal(gdp_md_est), layerId = ~iso_a3, popup = popup)

leaf_world
