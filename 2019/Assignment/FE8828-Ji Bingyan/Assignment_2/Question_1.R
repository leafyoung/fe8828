library(lubridate)
business_day <- function(yr){
    num_yr <- as.numeric(as.character(yr, format = "%Y"))
    if ((num_yr %% 400 == 0) | (num_yr %% 4 == 0 & num_yr %% 100 != 0)){
        days_in_year <- 366
    }else{
        days_in_year <- 365
    }
    start_weekday <- weekdays(ymd(paste0(as.character(yr), "-01-01")))
    end_weekday <- weekdays(ymd(paste0(as.character(yr), "-12-31")))
    order_weekdays <- factor(c(start_weekday, end_weekday), 
                             levels = c("Monday", "Tuesday", "Wednesday", 
                                        "Thursday", "Friday", "Saturday", "Sunday"),
                             ordered = TRUE)
    num_weeks <- (days_in_year - (7-as.numeric(order_weekdays)[1] + 1) - (as.numeric(order_weekdays)[2]))/7
    num_business <- num_weeks * 5 + max(7-as.numeric(order_weekdays)[1] - 1 , 0) + min(as.numeric(order_weekdays)[2], 5)
    num_business
}


