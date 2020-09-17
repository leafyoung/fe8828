#Import call and put datasets
Optionscall <- read_excel("~/MFE/FE8828 Programming Web Applications in Finance (E)/R/Optionscall.xlsx", 
                          col_types = c("skip", "skip", "numeric", "numeric", "numeric", "numeric", "skip", 
                                        "skip", "skip", "numeric", "skip"))
Optionsput <- read_excel("~/MFE/FE8828 Programming Web Applications in Finance (E)/R/Optionsput.xlsx", 
                          col_types = c("skip", "skip", "numeric", "numeric", "numeric", "numeric", "skip", 
                                        "skip", "skip", "numeric", "skip"))

#1.1 Arrange into desired data format
Optionscall <- Optionscall %>%
  mutate(`Expiry Date` = as.Date("2019/12/20"), 
         `Call/Put` = "Call", 
         Underlying = 1234.03)
Call <- Optionscall %>% 
  select(`Expiry Date`, Strike, `Open Interest`, Underlying,`Call/Put`, Bid, Ask)
Optionsput <- Optionsput %>%
  mutate(`Expiry Date` = as.Date("2019/12/20"), 
         `Call/Put` = "Put", 
         Underlying = 1234.03)
Put <- Optionsput %>% select(`Expiry Date`, Strike, `Open Interest`, Underlying,`Call/Put`, Bid, Ask)
df <- bind_rows(Call,Put)

#1.2 Compute total valuation
dfv <- df %>% 
  mutate(Value=`Open Interest`*(Bid + Ask)/2) 
dfvs <- dfv %>%  
  group_by(`Call/Put`) %>% 
  summarise(totvalue = sum(Value)) %>%
  ungroup
cat(paste0("The total valuation of calls, puts, and calls and puts are ",
           dfvs$totvalue[which(dfvs$`Call/Put`=="Call")], " ",
           dfvs$totvalue[which(dfvs$`Call/Put`=="Put")],
           " and ", 
           sum(dfvs$totvalue)))

#1.3 Find options in the money and compute their Open Interest
sum1 <- df %>% 
  dplyr::filter(`Call/Put`=='Call', Strike<Underlying) %>% 
  summarise(totOpenInterest=sum(`Open Interest`)) 
sum2 <- df %>% 
  dplyr::filter(`Call/Put`=='Put', Strike>Underlying) %>% 
  summarise(totOpenInterest=sum(`Open Interest`))
sum <- sum1 +sum2
cat(paste0("Total Open Interest of options in the money is ",
           sum))

#1.4 Plot volatility curve
df2 <- bind_rows(Optionscall,Optionsput)
outcall <- df2 %>% 
  dplyr::filter(`Call/Put`=='Call', Strike>Underlying) %>% 
  mutate(Volatility = 
           Vectorize(GBSVolatility)(`Last Price`, "c", Underlying, as.numeric(Strike),
                         as.numeric((as.Date("2019-12-20")-as.Date("2019-09-24")))/365, 
                         r = 0.03, b = 0))
output <- df2 %>% 
  dplyr::filter(`Call/Put`=='Put', Strike<Underlying) %>% 
  mutate(Volatility = 
           Vectorize(GBSVolatility)(`Last Price`, "p", Underlying, as.numeric(Strike),
                                    as.numeric((as.Date("2019-12-20")-as.Date("2019-09-24")))/365, 
                                    r = 0.03, b = 0))
volcurve <- bind_rows(outcall,output) %>% select(Strike,Volatility)
ggplot(volcurve, aes(Strike,Volatility)) +
  geom_smooth()
