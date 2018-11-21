require(shinydashboard)
require(ggplot2)
require(dplyr)
require(highcharter) #to plot amazing time series plots
library(readxl)
require(tidyr)
#loading the dataset

setwd("D:\\Dropbox\\Docs\\MFE\\FE8828\\notes\\example\\dashboard")

inflation <- read_excel("inflation.xls")

year<-c(1980:2022) #making a vector consisting of all years
year<-as.character(year)#converting to character type to use in gather()

#converting dataset to a long format
inf <- gather(inflation, key = "Year",value="InflationRate", -1)
inf <- na.omit(inf) #omitting NA values
names(inf) <- c("region","year","inflation")
inf$year<- as.integer(inf$year)

#Making data frame for specific countries and economic unions to be used in plotting

India <- filter(inf,region=="India")
India$inflation<-as.numeric(India$inflation)
India$year<-as.numeric(India$year)
China<-filter(inf,region=="China, People's Republic of")
Ger<-filter(inf,region=="Germany")
Japan<-filter(inf,region=="Japan")
US<-filter(inf,region=="United States")
EU<-filter(inf,region=="European Union")
UK<-filter(inf,region=="United Kingdom")
Fr<-filter(inf,region=="France")
uae<-filter(inf,region=="United Arab Emirates")

#server function and logic
server <- function(input, output) { 
  output$hcontainer <- renderHighchart ({
    
    #write all R-code inside this
    
    df  <- inf %>% filter(region==input$country) #making the dataframe of the country
    #above input$country is used to extract the select input value from the UI and then make 
    #a dataframe based on the selected input
    df$inflation <- as.numeric(df$inflation)
    df$year <- as.numeric(df$year)
    
    #plotting the data
    hchart(df, "line",color="#DC270C",hcaes(x=year,y=inflation))  %>%
      
      hc_exporting(enabled = TRUE) %>% 
      hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                 shared = TRUE, borderWidth = 2) %>%
      hc_title(text="Time series plot of Inflation Rates",align="center") %>%
      hc_subtitle(text="Data Source: IMF",align="center") %>%
      hc_add_theme(hc_theme_elementary()) 
    
  }) # end hcontainer
  
  
  output$hc2 <- renderHighchart({
    
    highchart() %>% 
      hc_xAxis(categories=inf$year) %>% 
      hc_add_series(name = "India", data = India$inflation) %>% 
      hc_add_series(name = "USA", data = US$inflation) %>%
      hc_add_series(name = "UK", data = UK$inflation) %>%
      hc_add_series(name = "China", data = China$inflation) %>%
      hc_add_series(name = "Germany", data = Ger$inflation) %>%
      hc_add_series(name="Japan",data=Japan$inflation) %>%
      #to add colors
      hc_colors(c("red","blue","green","purple","darkpink","orange")) %>%
      hc_add_theme(hc_theme_elementary())
  }) # end hc2
  
  output$hc3<-renderHighchart({
    union <- inf %>% filter(region==input$region)
    union$year <- as.numeric(union$year)
    union$inflation <- as.numeric(union$inflation)
    
    hchart(union,hcaes(x=year,y=inflation),type="area",color="#2B1F97") %>%
      hc_exporting(enabled = TRUE) %>% 
      hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                 shared = TRUE, borderWidth = 2) %>%
      hc_title(text="Time series plot of Inflation Rates for Economic Unions",align="center") %>%
      hc_subtitle(text="Data Source: IMF",align="center") %>%
      hc_add_theme(hc_theme_elementary())
  }) #end hc3
  
  output$hc4<-renderHighchart({
    
    world <- inf %>% filter(region=="World")
    world$year<-as.numeric(world$year)
    world$inflation <-as.numeric(world$inflation)
    
    hchart(world,hcaes(x=year,y=inflation),type="area",color="#B915A3") %>%
      hc_exporting(enabled = TRUE) %>% 
      hc_tooltip(crosshairs = TRUE, backgroundColor = "#FCFFC5",
                 shared = TRUE, borderWidth = 2) %>%
      hc_title(text="Time series plot of Inflation Rates for World",align="center") %>%
      hc_subtitle(text="Data Source: IMF",align="center") %>%
      hc_add_theme(hc_theme_elementary())
    
  }) #end hc4
}