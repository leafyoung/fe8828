###Problem 1 - Princess marriage problem

#run_func - runs make choice 1000 times for each possible split number from 1 to N/2
run_func <- function(N){
  avg_choice <- vector()
  prob <- vector()
  for(i in 1:(N/2)){
    count <- 0
    res_n <- vector()
    for(j in 1:1000){
      res_n[j] <- make_choice(N,i)
      if(res_n[j]==N)
        count<-count+1
    }
    avg_choice[i] <- mean(res_n) #average value of chosen prince for each split
    prob[i] <- count/1000 #probabilit of finding best prince at each split
  }
  return(list(avg_choice, prob))
}

#make choice divides the princes into 2 groups and returns the best chosen prince
make_choice<-function(N, split_number){
  input_list <- sample(1:N, N, replace=FALSE)
  best_n <- max(input_list[1:split_number])
  for(i in (split_number+1):N){
    in_n <- input_list[i]
    if(in_n>best_n){
      best_n <- in_n
      break;
    }
    if(i==N) #counting how many times the best prince is picked for the probability
      best_n <- input_list[N]
  }
  return(best_n) 
}

###Run the following lines after sourcing the functions for the result###
ans <- run_func(100)
best_split <- which.max(ans[[2]])
prob_best_split <- max(ans[[2]])
paste0("Best to split the group at ", best_split, "\n")
paste0("The probability of finding best prince using this split number is: ", prob_best_split)

################################################################################################

###Problem 2 - Bond Scheduler and pricing

#Bond Scheduler function. Just source and call the function with the require inputs. 
library(lubridate)
library(bizdays)

bond_scheduler<-function(start_date, tenor, coupon_rate, coupon_freq, ytm){
  par_value <- 1000
  coupon_pmt <- (par_value * (coupon_rate/100)) / coupon_freq
  yield <- ytm/coupon_freq
  
  date <- as.Date(start_date)
  start_year <- year(date)
  end_date <- date + years(tenor)
  end_year <- year(end_date)
  pmt_dates <- as.Date(vector())
  n <- 0
  while(date < end_date){
    
    if((coupon_freq < 12) & (12%%coupon_freq==0)){
      date <- date + months(12/coupon_freq) 
    }
    else{
      date <- date + (365/coupon_freq) #Assuming coupon_freq is number of times per year
    }
    
    n <- n + 1
    
    save_date <- date #Saves the date incase the date has to be changed if not a business day
    
    if(date<=end_date){
      if(!isBizday(timeDate(date), holidays = holidayNYSE(start_year:end_year), wday = 1:5)){
        while(!isBizday(timeDate(date), holidays = holidayNYSE(start_year:end_year), wday = 1:5)){ #Finds the next business day
          date <- date + 1
        }
      }
      
      cat(paste0("PMT ", n, ": ", format(date, format="%a, %d %b %Y")), sep="\n")
      date <- save_date #Reinstates the date (just incase date was modified for being a holiday)
    }
    
  }
  
  npv <- 0
  for(i in 1:n){
    if(i==n){
      cf <- coupon_pmt + par_value
    }
    else{
      cf <- coupon_pmt
    }
    
    npv <- npv + (cf/((1+(yield)/100)^i))
  }
  
  cat("NPV = ", npv, "\n")
  
  bond_price <- coupon_pmt*((1-1/((1+(yield/100))^n))/(yield/100)) + par_value*(1/((1+(yield/100))^n))
  
  cat("Bond Price: ", bond_price)
  
}
