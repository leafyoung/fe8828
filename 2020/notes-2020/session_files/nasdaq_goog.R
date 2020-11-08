library(readxl)
nasdap_goog_20201002 <- read_excel("E:/Dropbox/MFE/FE8828/2020/notes-2020/session_files/nasdap_goog_20201002.xlsx")

library(conflicted)
library(tidyverse)
library(fOptions)
conflict_prefer('lag', 'dplyr')
conflict_prefer('filter', 'dplyr')
nasdap_goog_20201002

colnames(nasdap_goog_20201002)

nasdap_goog_20201002_clean <- nasdap_goog_20201002 %>%
  select(Strike, `Bid...4`, `Ask...5`, `Bid...11`, `Ask...12`, `Open Int....7`, `Open Int....14`) %>%
  mutate(Today = as.Date('2020-10-02'), Underlying = 1458.42, Expiry = as.Date('2020-12-18')) %>%
  {
    v <- .
    calls <- select(v, -`Bid...11`, -`Ask...12`,-`Open Int....14`) %>% rename(Bid = `Bid...4`, Ask = `Ask...5`, OI = `Open Int....7`) %>% mutate(type = 'c')
    puts <- select(v, -`Bid...4`, -`Ask...5`,-`Open Int....7`) %>% rename(Bid = `Bid...11`, Ask = `Ask...12`, OI = `Open Int....14`) %>% mutate(type = 'p')
    bind_rows(calls, puts)
  }

nasdap_goog_20201002_dt <- nasdap_goog_20201002_clean %>% rowwise() %>%
  mutate(vol = GBSVolatility(Ask, type, Underlying, Strike, Time = as.numeric((Expiry - Today) / 365), r = 0.03, b = 0.0)) %>% ungroup

# (Bid + Ask ) / 2

# GBSVolatility(867.30,"c",1135.67,240,as.numeric((as.Date("2020-12-18")-as.Date("2020-09-29")))/365,r=0.03,b=0)

nasdap_goog_20201002_dt %>% {
  df <- .

  df1 <- filter(df, {
    sel <- ((Strike < Underlying) && type == 'p') || ((Strike > Underlying) && type == 'c')
    sel2 <- ((Strike < Underlying) & type == 'p') | ((Strike > Underlying) & type == 'c')
    sel2
  }) %>% arrange(Strike)
  
  plot(df1$Strike, df1$vol, col = 'red', type = 'l')
  points(df$Strike, df$vol)
}

nasdap_goog_20201002_dt %>% ggplot(.) + geom_point(aes(x = Strike, y = OI, color = type))

# write_csv(nasdap_goog_20201002_dt, 'c:/temp/nasdap_goog_20201002_dt.csv')

Long_format_df <- tibble(Name = rep(c('a','b','c'),2),
                         key = c(rep('Buy_Quantity',3),rep('Sell_Quantity',3)),
                         value = c(1,2,3,4,5,6))

Wide_format_df <- tibble(Name = c('a','b','c'),
                         Buy_Quantity = c(1,2,3), Sell_Quantity = c(4,5,6))
