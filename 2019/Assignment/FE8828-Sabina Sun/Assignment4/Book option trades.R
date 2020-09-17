library(readxl)
library(tidyverse)
library(fOptions)
library(dplyr)
library(tidyr)

Google_options <- read_excel("~/R/Assignment1/Google_options.xlsx", 
                             col_types = c("text", "text", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "numeric", 
                                           "numeric", "numeric", "text"))

df <-mutate(Google_options,Expiry=as.Date("2019-12-20"), Underlying = 1234.03)
df<-select(df,Expiry,Strike,`Open Interest`,Underlying,`Call/put`,Bid,Ask)
head(df)
#1.1 cleaned dataframe into defined format

df%>%
  mutate(valuation=(`Open Interest`*(Bid+Ask)/2))%>%
  group_by(`Call/put`)%>%
  summarise(total=sum(valuation))
# total call=18563
# total put=68578

df%>%
  mutate(valuation=(`Open Interest`*(Bid+Ask)/2))%>%
  summarise(total=sum(valuation))
#total call & put=87141

df%>%
  dplyr::filter(`Call/put`=="Call"& Strike<Underlying)%>%
  summarise(total=sum(`Open Interest`))
#total interest for in the money call = 93

df%>%
  dplyr::filter(`Call/put`=="Put"& Strike>Underlying)%>%
  summarise(total=sum(`Open Interest`))
#total interest for in the money put = 96

df2<-data.frame(rbind(dplyr::filter(df,`Call/put`=="Put"& Strike<Underlying),
                      dplyr::filter(df,`Call/put`=="Call"& Strike>Underlying)))
df2 <- df2 %>%  
  dplyr::filter(Ask!=0)%>%
  mutate(type = ifelse(Call.put=="Put","p","c"))

implied_vol_l <- list(1:nrow(df2))
for (i in 1:nrow(df2)){
  implied_vol_l[i]<-GBSVolatility(price = df2$Ask[i], TypeFlag = df2$type[i], S = df2$Underlying[i],X = df2$Strike[i], 
                Time = ((as.numeric(as.Date("2019-12-20")-as.Date("2019-09-24")))/365), 
                r = 0.03, b = 0)
}

implied_vol<-as.numeric(implied_vol_l)
df_result<-tibble(Strike=df2$Strike, `implied volatility`=implied_vol)

ggplot(df_result,aes(Strike,`implied volatility`)) + 
  geom_point() +
  geom_smooth()

            
               