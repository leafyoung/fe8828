library(readxl)
library(tidyverse)
library(lubridate)
library(fOptions)
Nasdaq <- read_excel("Desktop/Programming Web Application/My R/ASM3_XuXinzhi/Q2/Nasdaq.xlsx")
str(Nasdaq) #check type

n <- nrow(Nasdaq)
df <- Nasdaq[,-c(2,3,6,9,10,13)] %>%    #delete Last,change,volume
  mutate("c" = rep("c",n), "p" = rep("p",n), Underlying = rep(1458.42,n), Today = rep(as.Date("2020-10-02"),n))
df_1 <- df[,c(1,5,4,9,2,3,11,12)] %>%
  rename("Open_Int" = "Open Int....7", "Option Type" = "c")
df_1$Open_Int <-  as.numeric(df_1$Open_Int)
df_t <- df[,c(1,5,8,10,6,7,11,12)] %>%
  rename("Open_Int" = "Open Int....14", "Option Type" = "p") %>%
  bind_rows(df_1) %>%  #combine
  rename(Option_Type = "Option Type") %>%
  
  mutate(Individual_Valuation = Open_Int * (Bid + Ask)/2) %>% 
  group_by(Option_Type) %>%
  mutate(Total_Valuation = sum(Individual_Valuation,na.rm = TRUE))%>%
  #sum up all the individual valuation according to its option type
  ungroup()%>%
  mutate(Total_Val_Both = sum(Individual_Valuation,na.rm = TRUE)) %>%
  
  mutate(In_The_Money = case_when(
    Option_Type == "c" & Strike < Underlying ~ "In",
    Option_Type == "c" & Strike > Underlying ~ "Not_In",
    Option_Type == "p" & Strike > Underlying ~ "In",
    Option_Type == "p" & Strike < Underlying ~ "Not_In",
  )) %>%
  
  group_by(In_The_Money) %>%
  mutate(Tol_Open_Int_Money = sum(Open_Int,na.rm = TRUE)) %>%
  
  # GBSVolatility (price, TypeFlag, Underlying, Strike, Time, r, b, tol, maxiter) 
  # Use Price to back-out implied volatility. Assume r = 0.03
  rowwise() %>% 
  mutate(GBSvol = GBSVolatility(0.5*(Bid+Ask), Option_Type, Underlying, Strike,
                                 as.numeric((as.Date("2020-12-18") - as.Date("2020-10-02")))/365, 
                                 r = 0.03, b = 0)) %>% 
  ungroup() 

#Second approach
#function of calculating GBSvolatility
#vol <- function(x) GBSVolatility(0.5*(x$Bid + x$Ask), x["Option_Type"], as.numeric(x["Underlying"]), as.numeric(x["Strike"]), 
#                                 Time = as.numeric((as.Date("2020-12-18") - as.Date("2020-10-02")))/365, 
#                                 r = 0.03, b = 0)  
#GBSvol <- apply(df_t, 1, vol) 

#Plot
data <- dplyr::filter(df_t, In_The_Money == "Not_In") 
ggplot(data,aes(Strike,GBSvol)) + geom_line()

  
  
  
  
