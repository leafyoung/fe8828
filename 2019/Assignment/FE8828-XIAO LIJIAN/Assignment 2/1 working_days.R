#this code works for 2019
library(timeDate)

# YY: This may temporarily set English as default locale
Sys.setlocale("LC_ALL", "English")

working_days <- function(){
  # holiday_list <- holidayNYSE(year = getRmetricsOptions("currentYear"))
  # hl <- as.Date(holiday_list)
  hl <- c()
  #My system language is Chinese
  #which maybe the reason why "weekdays" returns Chinese "Xingqi"
  Date1 <- as.Date("2005-01-01")
  Date2 <- as.Date("2005-12-31")
  # a <- sum(!weekdays(seq(Date1, Date2, "days")) %in% c("星期六", "星期日"))
  # YY: To test on English system
  a <- sum(!weekdays(seq(Date1, Date2, "days")) %in% c("Saturday", "Sunday"))
  # b <- sum(!weekdays(hl) %in% c("星期六", "星期日"))
  # YY: To test on English system
  b <- sum(!weekdays(hl) %in% c("Saturday", "Sunday"))
  a - b
}
