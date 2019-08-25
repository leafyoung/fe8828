###Problem 1 - HOW LONG TO MAKE A CHOICE?(Princess problem)
#find_optimal, calls Step 1(make_choice fucntion) a few (hundred) times for each of the split number
#from 1 to N/2.-Used run_fucntion for this objective. So we can find the optimal value for the split for the N.
run_func <- function(N){
  optimal_choice <- vector()
  prob <- vector()
  for(i in 1:(N/2)){
    count <- 0
    res_n <- vector()
    for(j in 1:1000){
      res_n[j] <- make_choice(N,i)
      if(res_n[j]==N)
        count<-count+1
    }
    optimal_choice[i] <- mean(res_n) #Optimal choicein choosing best prince for each split
    prob[i] <- count/1000 #probability of finding best prince at each split
  }
  return(list(optimal_choice, prob))
}

#Following Step by step as given in lecture notes
make_choice<-function(N, split_number){
  input_list <- sample(1:N, N, replace=FALSE)#Generate a list input_list of N long with integer 1 to N at random position
  #Split the list input_list into two: evaluation group and selection group.
  best_n <- max(input_list[1:split_number])#Remember the best number from evaluation group and match the first number
  #in selection group, >= than best(DOne below in for loop)
  for(i in (split_number+1):N){
    in_n <- input_list[i]
    if(in_n>best_n){
      best_n <- in_n
      break;
    }
    if(i==N) #Say ,if we don't find any prince in selction group better than bets one in evaluation group,last prince is chosen.
      best_n <- input_list[N]
  }
  return(best_n) #Returns this number

}

optimal_result <- run_func(1000)#Using
best_split <- which.max(optimal_result[[2]])
probability_best <- max(optimal_result[[2]])
paste("It would be optimal to split the group at ", best_split, "\n")
paste("Using this best split,probability of finding best prince  ", probability_best)

################################################################################################

###Problem 2 - Bond Scheduler and Pricing Problem
library(lubridate)
library(bizdays)

bond_scheduler<-function(start_date, tenor, coupon_rate, coupon_freq, ytm){
  par_value <- 1000
  coupon_pmt <- (par_value * (coupon_rate/100)) / coupon_freq
  yield <- ytm/coupon_freq
  
  date <- as.Date(start_date)#Given input is converted into date format
  start_year <- year(date)#extracting year as  date is in DateFormat
  end_date <- date + years(tenor)#years()Coverts to y m d h m s .so that now date is added properly.
  end_year <- year(end_date)
  n <- 0
  #Our task is to move to next payment date.But if it isn't a business day next best business day should be taken into consideration.
  while(date < end_date){
    
    if((coupon_freq < 12) & (12%%coupon_freq==0)){
      date <- date + months(12/coupon_freq) 
    }
    else{
      date <- date + (365/coupon_freq) 
    }
    
    n <- n + 1
    
    temp <- date #Temporary variable which helps in saving date
    
    if(date<=end_date){
      if(!isBizday(timeDate(date), holidays = holidayNYSE(start_year:end_year), wday = 1:5)){
        while(!isBizday(timeDate(date), holidays = holidayNYSE(start_year:end_year), wday = 1:5)){ #Finds the next immediate business day
          date <- date + 1
        }
      }
      
      cat(paste0("PMT ", n, ": ", format(date, format="%a, %d %b %Y")), sep="\n")
      date <- temp #It helps in not disturbing next payment date schedule and would be in line with schedule
    }
    
  }
  #Calculating NPV.
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
  
  cat("Bond Price =", bond_price)
  
}
