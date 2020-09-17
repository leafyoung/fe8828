library(dplyr)
library(readxl)
library(fOptions)


Book1 <- read_excel("Book1.xlsx", sheet = "Sheet1", 
                    col_types = c("text", "text", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric"))
Book1 <- mutate(Book1,
                Call_Put = "Call",
                Expiry = as.Date("2019-12-20"),
                Underlying = 1221.36)

Book2 <- read_excel("Book1.xlsx", sheet = "Sheet2", 
                    col_types = c("text", "text", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric"))
Book2 <- mutate(Book2,
                Call_Put = "Put",
                Expiry = as.Date("2019-12-20"),
                Underlying = 1221.36)


colnames(Book1)
df <- bind_rows(Book1, Book2)

df1 <- mutate(df, Value = `Open Interest` * (Bid + Ask)/2)

df_call <- df1 %>% dplyr::filter(Call_Put == "Call")
df_put <- df1 %>% dplyr::filter(Call_Put == "Put")

#Part 1.2
sum(df_call$Value,na.rm = TRUE)
sum(df_put$Value,na.rm = TRUE)
sum(df1$Value,na.rm = TRUE)

#Part 1.3
df1%>% dplyr::filter((`Call_Put`=="Call" & Underlying>Strike) | (`Call_Put`=="Put" & Underlying<Strike)) -> df_itm
sum(df_itm$`Open Interest`,na.rm = TRUE)

#Part 1.4

df_callIV<-df_call%>%dplyr::filter(Strike>Underlying)%>%rowwise()%>%mutate(IV=GBSVolatility(`Last Price`,"c",Underlying,Strike,(as.numeric(Expiry)-as.numeric(Sys.Date()))/365,r=0.03,b=0))
df_putIV<-df_put%>%dplyr::filter(Strike<Underlying)%>%rowwise()%>%mutate(IV=GBSVolatility(`Last Price`,"p",Underlying,Strike,(as.numeric(Expiry)-as.numeric(Sys.Date()))/365,r=0.03,b=0))
df_allIV<-bind_rows(df_callIV,df_putIV)

plot(df_allIV$Strike,df_allIV$IV,xlab="Strike",ylab="Implied Volatility")

