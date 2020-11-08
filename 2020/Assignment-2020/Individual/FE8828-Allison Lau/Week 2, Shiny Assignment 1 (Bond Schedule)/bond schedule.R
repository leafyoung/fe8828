library(tidyverse)
library(lubridate)
library(ggplot2)

table <- function(bond_par,date,coupon_rate,ytm,years,frequency){
  #if(frequency == "Q")
   # annual_count <- 4
  #else if(frequency == "H")
   # annual_count <- 2
  #else
   # annual_count <- 1
  annual_count <- frequency
  period <- annual_count * years 
  current_price <- 0
  
  tenors <- c()
  
  dates <- c()
  
  for(z in 1:period){
    if(annual_count == 1){
      require(lubridate)
      dates[z] <- format(ymd(date) + years(z))
    }
    else if(annual_count == 2){
      require(lubridate)
      dates[z] <- format(ymd(date) + months(z*6))
    }
    else if(annual_count == 4){
      require(lubridate)
      dates[z] <- format(ymd(date) + months(z*3))
    }
  }
  
  for(i in 1:period){
    tenors[i] <- i 
  }
  
  cash_flows <- c()
  for(j in 1:(period-1)){
    cash_flows[j] <- (bond_par * coupon_rate)/annual_count
  }
  
  cash_flows[period] <- ((bond_par * coupon_rate)/annual_count) + bond_par
  
  discountcf <- c()
  for(k in 1:(period-1)){
    cash_flows[j] <- (bond_par * coupon_rate)/annual_count
    discountcf[k] <- cash_flows[k]/((1+ytm/annual_count)^(tenors[k]*annual_count))
    current_price <- current_price + discountcf[k]
  }
  
  discountcf[period] <- cash_flows[period]/((1+ytm/annual_count)^(tenors[period]*annual_count))
  current_price <- current_price + discountcf[period]
  
  test <- tibble(
    Tenors = tenors,
    Date = dates,
    CashFlows = cash_flows,
    DCF = discountcf
    
  )
  
  return(test)
  
}

#for graph purposes
graph <- function(bond_par,date,coupon_rate,ytm,years,frequency){
  #if(frequency == "Q")
  # annual_count <- 4
  #else if(frequency == "H")
  # annual_count <- 2
  #else
  # annual_count <- 1
  annual_count <- frequency
  period <- annual_count * years 
  current_price <- 0
  
  tenors <- c()
  
  dates <- c()
  NPV <- c()
  
  for(z in 1:period){
    if(annual_count == 1){
      require(lubridate)
      dates[z] <- format(ymd(date) + years(z))
    }
    else if(annual_count == 2){
      require(lubridate)
      dates[z] <- format(ymd(date) + months(z*6))
    }
    else if(annual_count == 4){
      require(lubridate)
      dates[z] <- format(ymd(date) + months(z*3))
    }
  }
  
  for(i in 1:period){
    tenors[i] <- i 
  }
  
  cash_flows <- c()
  for(j in 1:(period-1)){
    cash_flows[j] <- (bond_par * coupon_rate)/annual_count
  }
  
  cash_flows[period] <- ((bond_par * coupon_rate)/annual_count) + bond_par
  
  discountcf <- c()
  for(k in 1:(period-1)){
    cash_flows[j] <- (bond_par * coupon_rate)/annual_count
    discountcf[k] <- cash_flows[k]/((1+ytm/annual_count)^(tenors[k]*annual_count))
    current_price <- current_price + discountcf[k]
    NPV[k] <- current_price
  }
  
  discountcf[period] <- cash_flows[period]/((1+ytm/annual_count)^(tenors[period]*annual_count))
  current_price <- current_price + discountcf[period]
  NPV[period] <- current_price
  
  test <- tibble(
    Tenors = tenors,
    Date = dates,
    CashFlows = cash_flows,
    DCF = discountcf
    
  )
  
  graph <- ggplot(test) + geom_point(aes(x = dates, y = NPV))
  #graph + ggtitle("Graph of Cash Flow vs. Dates") + xlab("NPV of Cash Flows") + ylab("Date")
  
  return(graph)
}




