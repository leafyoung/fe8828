# Q2
# WU Hongsheng

# 2.1
options <- read_excel("FE8828-WU Hongsheng/Assignment 3/options.xlsx",
col_types = c("date", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric", "numeric",
"numeric", "numeric"))

put <-  options[1] %>% mutate(options[9:14], options[8], OptionType = "p")
colnames(put)[1:8] <- c("Exp. Date", "Last", "Change", "Bid",
                       "Ask", "Volume", "Open Int.", "Strike")

call <- options[1:8] %>% mutate(OptionType = "c")
colnames(call)[1:8] <- c("Exp. Date", "Last", "Change", "Bid",
                       "Ask", "Volume", "Open Int.", "Strike")

options2 <- rbind(call, put)

options_final <- options2[1] %>% mutate(options2[8], options2[7], 
                                        options2[9], options2[4:5], 
                                        Underlying = 1481.06,  # 1481.06
                                        Today = (as.Date("2020-10-08")))

# 2.2
options_final2 <- mutate(`Open Int.` = ifelse(is.na(`Open Int.`), 0, `Open Int.`),
                         options_final, ConvPrice = (Bid + Ask) / 2, 
                         TotalValuation = `Open Int.` * ConvPrice)

ValCall <- options_final2 %>% dplyr::filter(OptionType == "c")
ValPut <- options_final2 %>% dplyr::filter(OptionType == "p")

cat(paste0("total valuation for call alone is ", sum(ValCall$TotalValuation)))
cat(paste0("total valuation for put alone is ", sum(ValPut$TotalValuation)))
cat(paste0("total valuation for all is ", sum(options_final2$TotalValuation)))

# 2.3
in_the_money <- options_final %>% 
  dplyr::filter(((OptionType == "c") & (Strike < Underlying)) |
                  ((OptionType == "p") & (Strike > Underlying)))

cat(paste0("total open interest is ", sum(in_the_money[3], na.rm = TRUE)))

# 2.4
options3 <- options
options3[2] = (options[4] + options[5]) / 2
options3[9] = (options[11] + options[12]) / 2

colnames(options3)[2] <- "CallPrice"
colnames(options3)[9] <- "PutPrice"

vol_group <- options3 %>% mutate(Underlying = 1481.06) %>% 
  mutate(PriceForCal = case_when(
  Strike < Underlying ~ PutPrice,
  Strike > Underlying ~ CallPrice), 
  TypeFlag = case_when(
    Strike < Underlying ~ "p",
    Strike > Underlying ~ "c"),
  Today = (as.Date("2020-10-08")))

vol_group2 <- mutate(vol_group[16:17], vol_group[15],
                    vol_group[8], vol_group[16], 
                    Time = as.numeric((as.Date("2020-12-18") - as.Date("2020-10-08")))/365,
                    r = 0.03, b = 0)

result <- rowwise(vol_group2) %>% 
  mutate(Volatility = GBSVolatility(price = PriceForCal, TypeFlag = TypeFlag, 
                                    S = Underlying, X = Strike, 
                                    Time = Time, r = r, b = b)) %>% ungroup()

plot(result$Strike, result$Volatility, type = "o")