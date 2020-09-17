library(tidyverse)
library(readxl)
library(fOptions)

#Part 1.1
Book1 <- read_excel("Book1.xlsx", sheet = "Sheet1", 
                    col_types = c("text", "text", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric"))
Book1 <- mutate(Book1,
                Call_Put = "Call",
                Expiry = as.Date("2019-12-20"),
                Underlying = 1234.03)

Book2 <- read_excel("Book1.xlsx", sheet = "Sheet2", 
                    col_types = c("text", "text", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric"))
Book2 <- mutate(Book2,
                Call_Put = "Put",
                Expiry = as.Date("2019-12-20"),
                Underlying = 1234.03)

colnames(Book1)
df <- bind_rows(Book1, Book2)
df <- select(df, Expiry, Strike, `Open Interest`, Underlying, Call_Put, Bid, Ask, `Last Price`)

#Part 1.2
df1 <- mutate(df, Value = `Open Interest` * (Bid + Ask)/2)

df_call <- df1 %>% dplyr::filter(Call_Put == "Call")
df_put <- df1 %>% dplyr::filter(Call_Put == "Put")

cat("Total valuation of call alone: ", paste0(sum(df_call$Value, na.rm = TRUE)), "\n")
cat("Total valuation of put alone: ", paste0(sum(df_put$Value,na.rm = TRUE)), "\n")
cat("Total valuation of call and put: ", paste0(sum(df1$Value,na.rm = TRUE)), "\n")

#Part 1.3
df_ITM <- df1 %>% 
  dplyr::filter(((Call_Put == "Call") & (Underlying > Strike)) | ((Call_Put == "Put") & (Underlying < Strike)))

cat("Total Open Interest: ", paste0(sum(df_ITM$`Open Interest`, na.rm = TRUE)),"\n")

#Part 1.4
#Assume r = 0.03
df_callVol <- df_call %>% 
  dplyr::filter(Strike > Underlying) %>% 
  rowwise() %>% 
  mutate(Vol = GBSVolatility(`Last Price`, "c", Underlying, Strike, (as.numeric(Expiry) - as.numeric(Sys.Date()))/365, r=0.03, b=0))
df_putVol <- df_put %>% 
  dplyr::filter(Strike < Underlying) %>% 
  rowwise() %>% 
  mutate(Vol = GBSVolatility(`Last Price`, "p", Underlying, Strike, (as.numeric(Expiry) - as.numeric(Sys.Date()))/365, r=0.03, b=0))
df_Vol <- bind_rows(df_callVol, df_putVol)

ggplot(df_Vol, aes(Strike, Vol)) +
  geom_point() +
  geom_line() + 
  geom_vline(xintercept = 1234.03, color = "steelblue") +
  theme_bw() +
  labs(title = "Volatility curve") +
  theme(plot.title = element_text(hjust = 0.5))

#check implied volatility using a for-loop
#head(df_callVol)
#for (i in 1:6){
#  cat(paste(round(GBSVolatility(df_callVol$`Last Price`[i], TypeFlag = "c", S = df_callVol$Underlying[i], X = df_callVol$Strike[i], Time = (as.numeric(df_callVol$Expiry[i]) - as.numeric(Sys.Date()))/365, r = 0.03, b = 0),3)),"\n")
#}
#head(df_putVol)
#for (i in 1:6){
#  cat(paste(round(GBSVolatility(df_putVol$`Last Price`[i], TypeFlag = "p", S = df_putVol$Underlying[i], X = df_putVol$Strike[i], Time = (as.numeric(df_putVol$Expiry[i]) - as.numeric(Sys.Date()))/365, r = 0.03, b = 0),3)),"\n")
#}
