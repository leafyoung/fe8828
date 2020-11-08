library(tidyverse)

tibble(Date = as.Date(c('2020-09-11', '2020-09-12')),
       Valuation_Stock1 = c(1000,1100),
       Valuation_Stock2 = c(1000,600),
       Valuation_Stock3 = c(1200,1300),
       Valuation_Stock4 = c(800,1900),
       Valuation_Cash = c(100,102),
       ) %>% 
  pivot_longer(Valuation_Stock1:Valuation_Cash, names_to = "Component", values_to = 'Value') %>%
  ggplot(.) + geom_area(aes(Date, Value, fill = Component), position = 'fill')
