library(readxl)
library(dplyr)
# 1.1 Copy the options data from https://www.nasdaq.com/symbol/goog/optionchain?dateindex=1
Call <- read_excel("Documents/MFE/Mini-term 2/FE8828 Programming Web Applications in Finance/GOOGOption.xlsx", 
                  sheet = "Call", col_types = c("text", 
                                                "text", "numeric", "numeric", "numeric", 
                                                "numeric", "numeric", "numeric", "text", 
                                                "numeric", "numeric"))

Put <- read_excel("Documents/MFE/Mini-term 2/FE8828 Programming Web Applications in Finance/GOOGOption.xlsx", 
                   sheet = "Put", col_types = c("text", 
                                                 "text", "numeric", "numeric", "numeric", 
                                                 "numeric", "numeric", "numeric", "text", 
                                                 "numeric", "numeric"))

# 1.2 Count the total valuation of 1) call alone, 2) put alone, 3) call and put.
Call <- mutate (Call,
                Call_Put = "Call",
                Expiry = as.Date("2019-12-20"),
                Underlying = 1234.03)

Put <- mutate (Put,
                Call_Put = "Put",
                Expiry = as.Date("2019-12-20"),
                Underlying = 1234.03)

df <- bind_rows(Call,Put)

df <- mutate(df, Value = `Open interest` * (Bid + Ask/2))

summarize(group_by(df,Call_Put),Sum=sum(Value))
summarize(df,SumCP=sum(Value))


# 1.3 Find those in the money and get their total Open Interest.
df_call <- df %>% dplyr::filter(Call_Put == "Call")
df_put <- df %>% dplyr::filter(Call_Put == "Put")

df_call %>% group_by(Strike>Underlying) %>% summarize(Sum = sum(Value)) %>% dplyr::filter(`Strike > Underlying`=="FALSE") -> df1_call
call = df1_call[[2]]
df_put %>% group_by( Strike>Underlying) %>% summarize(Sum = sum(Value)) %>% dplyr::filter(`Strike > Underlying`=="TRUE") -> df1_put
put = df1_put[[2]]

cat('Open interest for in the money calls is:',call)
cat('Open interest for in the money puts is:',put)

# 1.4. Plot the volatility curve, strike v.s. vol.
volcall <- df_call %>% 
  dplyr::filter(Strike>Underlying) %>%
  mutate(vol = Vectorize(GBSVolatility)(`Last price`,"c",Underlying,Strike,as.numeric((as.Date("2019-12-20") -
                                                                                     as.Date("2019-09-16")))/365, r = 0.03, b = 0))

volput <- df_put %>% 
  dplyr::filter(Strike<Underlying) %>%
  mutate(vol = Vectorize(GBSVolatility)(`Last price`,"p",Underlying,Strike,as.numeric((as.Date("2019-12-20") -
                                                                                         as.Date("2019-09-16")))/365, r = 0.03, b = 0))

bind_rows(volput,volcall) %>% 
  ggplot(aes(Strike,vol)) + 
  geom_line() + 
  theme_bw()+
  labs(title="Volatility curve")
