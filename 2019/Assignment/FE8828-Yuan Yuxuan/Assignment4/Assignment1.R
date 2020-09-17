#Assignment 1
#Exercise 3 : slides 72 in session 3 notes
library(readxl)
library(dplyr)
library(fOptions)

#1.1 Copy the options data
CallOptions <- read_excel("E:/gdrive/MFECourse/FE8828/2019/FE8828-Yuan Yuxuan/Assignment4/GoogleOptionData.xlsx", 
     sheet = "Call", col_types = c("skip", 
         "skip", "numeric", "skip", "numeric", 
         "numeric", "skip", "skip", "skip", 
         "numeric", "skip"))

CallOptions <- mutate(CallOptions, `Call/Put` = "c", 
                      `Underlying` = 1212.07, 
                      `Expiry Date` = as.Date("2019-12-20"))

PutOptions <- read_excel("E:/gdrive/MFECourse/FE8828/2019/FE8828-Yuan Yuxuan/Assignment4/GoogleOptionData.xlsx", 
                          sheet = "Put", col_types = c("skip", 
                                                        "skip", "numeric", "skip", "numeric", 
                                                        "numeric", "skip", "skip", "skip", 
                                                        "numeric", "skip"))
PutOptions <- mutate(PutOptions, `Call/Put` = "p", 
                      `Underlying` = 1212.07, 
                      `Expiry Date` = as.Date("2019-12-20"), `Open Interest` = ifelse(is.na(`Open Interest`), 0, `Open Interest`))
Options <- bind_rows(CallOptions, PutOptions)

#1.2 Count the total valuation of 1) call alone, 2) put alone, 3) call and put.
Valuation_Inidividual <-
  group_by(Options, `Call/Put`) %>%
  summarise(`Total Valuation` = sum(`Open Interest` * (Bid+Ask)/2)) 
Valuation_Inidividual

Valuation_Both <- Options %>% 
  summarise(`Total Valuation` = sum(`Open Interest` * (Bid+Ask)/2)) %>% 
  mutate(`Call/Put` = "c&p")
Valuation_Both

Total_Valulation <- bind_rows(Valuation_Inidividual, Valuation_Both)
Total_Valulation

#1.3 Find those in the money and get their total Open Interest
Options <- mutate(Options, 
                  `In the Money` = ifelse(`Call/Put`=="c", 
                                                   Underlying > Strike, 
                                                   Underlying < Strike))
In_the_Money_Open_Interest = summarise(Options, `Sum` = sum(ifelse(`In the Money`, `Open Interest`, 0)))


#1.4. Plot the volatility curve, strike v.s. vol. For strike < current price, use puts' price; for strike > current price, use calls’ price.
Options_Q4 <- dplyr::filter(Options, (`Call/Put`=="c" & `Strike` > `Underlying`) | (`Call/Put`=="p" & `Strike` < `Underlying`))
Options_Q4 <- mutate(rowwise(Options_Q4), `Volatility` = GBSVolatility(price = (`Bid`+`Ask`)/2, 
                                                      TypeFlag = `Call/Put`, 
                                                      S = `Underlying`, 
                                                      X = `Strike`, 
                                                      Time = as.numeric(`Expiry Date`-as.Date("2019-10-12"))/365, 
                                                      r = 0.03, 
                                                      b = 0))
plot(select(Options_Q4, `Strike`, `Volatility`))
