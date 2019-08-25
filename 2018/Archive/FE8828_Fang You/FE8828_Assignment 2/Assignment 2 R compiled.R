###FE8828 assignment 2 
#Fang You G1800202G

##Q: pg 23 of 102 determine leap year

leap_year <- function(year)
{
  div_4 <- (year %% 4 == 0) #TRUE if year is divisible by 4 with no remainder
  div_100 <- (year %% 100 ==0 ) #TRUE if year is divisible by 100 with no remainder
  div_400 <- (year %% 400 ==0 )  #TRUE if year is divisible by 400 with no remainder
  
  if (div_4 == TRUE & div_100 == FALSE)
  {
    return(cat(paste0(year," is a leap year")))
    #break
  } else if(div_4 == TRUE & div_100 == TRUE & div_400 == TRUE)
  {
    return(cat(paste0(year," is a leap year")))
    #break
  } else
  {
    return(cat(paste0(year," is not a leap year")))
  }
  
}

##Q: pg 23 of 102 print list of month names in abbreviation or full
library(lubridate)

#set start and end date
date1 <- ymd(20180101)
date2 <- ymd(20181231)

#print list of months
format(seq(date1,date2,by = "month"), format = "%b")
format(seq(date1,date2,by = "month"), format = "%B")


##Q: pg 23 of 102 write function to count how many working days in a year, given the year and the list of holidays
library(bizdays)

#arbitrary list of public holidays
SG_holiday <- list("Holiday" = c("New Year's Day","Chinese New Year day 1","Chinese New Year day 2"), "Date" = c("2019-01-01","2019-02-05","2019-02-06"))

#calc no. of holidays from list of public holidays
num_holidays <- length(SG_holiday[[2]])

#create calendar with holidays
create.calendar(name = "Singapore", holiday = as.Date(SG_holiday), start.date = as.Date(date1), end.date = as.Date(date2), weekdays = c("saturday","sunday"))

# calc no. of working days = weekdays - holidays
num_wkday <- bizdays(date1,date2,"Singapore") - num_holidays


##pg 44 of 102 equivalent to princess marriage problem (ans ~37)

#function for counting the min number in selection group that is >= evluation group
make_choice <- function(N, split_number)
{
  input_list <- sample(1:N,N,replace =FALSE) #replace = FALSE because every prince is unique
  
  #create evaluation vector and populate
  evaluation <- vector(mode = "integer", split_number)
  for (i in 1:split_number)
  {
    evaluation[i] <- input_list[i]
  }
  
  #find max of evaluation group
  max_eval <- max(evaluation)
  
  #create selection vector and populate
  selection <- vector(mode = "integer",N-split_number)
  j <- 1
  for (i in (split_number+1):N)
  {
    selection[j] <- input_list[i]
    j <- j+1
  }
  
  #find index of first element >= max_eval
  index <- min(which(selection >= max_eval))
  
  if (index > (N-split_number))
  {
    return(selection[N-split_number]) #if no better prince can be found from the selection group, princess settles for the last guy she meets
  } else
  {
    return(selection[index]) 
  }
}


N <- 3 #no. of princes the princess will meet in her lifetime
M <- 100 #no. of model trials at each split_number
score <- vector(mode = "integer",M) #create vector to store the score of the prince that was chosen at each model trial

#find probability of marrying the prince with the highest score, N
split_number <- 0 #vary this to try split number = 0,1 or 2
for (i in 1:M)
{
  score[i] <- make_choice(N,split_number)
}
prob_get_N <- sum(score == N)/M 
#ans
#probability of marrying prince with score N is approx. 0.33 when N=3, split_number = 2
#probability of marrying prince with score N is approx. 0.5 when N=3, split_number = 1

#finding optimal split_number to marry the prince with the highest score, N
N <- 3 #no. of princes the princess will meet in her lifetime
M <- 100 #no. of model trials at each split_number

for (k in 1:100)
{

  for (j in 1:ceiling(N/2)) #j is the trial split_number
  {
    split_number <- j
    
    for (i in 1:M) #for each split_number, execute M times model trial
    {
      score[i] <- make_choice(N,split_number)
    }
    
  #probability of marrying prince with highest score
  prob_get_N[j] <- sum(score == N)/M 
  }
  
  optimal_split[k] <- which(prob_get_N == max(prob_get_N)) # creates vector recording the optimal split numbers
  
}

avg_optimal_split <- mean(optimal_split)
#average optimal split number is 36.43 with N=100

##pg 84 of 102 (bank clients)

#initiate tidyverse and import xls file
library(tidyverse)
bank <- read.csv("https://goo.gl/PBQnBt", sep = ";")

##Q: (pg84 of 102) how many clients have a loan but not a house?
#filters "bank" for those with loan but not housing
loan_not_house <- dplyr::filter(bank, (loan == "yes")&(housing=="no"))
length(loan_not_house)
#ans: 17 have a loan but not a house

##Q: (pg84 of 102) how many clients have a job between 20 to 40?
working_20_40 <- dplyr::filter(bank, (job != "unemployed")&(age >= 20)&(age<=40))
length(working_20_40)
#ans: 17 are working and aged between 20 to 40 inclusive

##Q: (pg87 of 102) how could you use arrange() to sort all missing values to the start?
#hint: use is.na()

#to arrange with fields containing unknowns at the top
bank_arranged <- arrange(bank,!is.na(education), desc(education))

#to arrange all fields with at least one "unknown" with the unknowns at the top
bank_arranged <- arrange(bank,!is.na(education),!is.na(job),!is.na(marital),!is.na(poutcome),!is.na(contact), 
                         desc(job:marital:education:loan:contact:poutcome))
#note to self: there should be a more compact way to do this....

##Q: (pg87 of 102) find the longest duration
list <- bank["duration"] == max(bank["duration"]) #creates a list of TRUE/FALSE with the element returning TRUE as the max value
index <- which(list == TRUE) #find index of element that returns TRUE, and hence is the max
max_duration = bank$duration[index] #returns the value of the duration that is the maximum
#ans: longest duration is 3025, which happens at the 569th row

##Q: (pg87 of 102) find the eldest person
list <- bank["age"] == max(bank["age"]) #creates a list of TRUE/FALSE with the element returning TRUE as the max value
index <- which(list == TRUE) #find index of element that returns TRUE, and hence is the max
max_age = bank$age[index] #returns the value of the duration that is the maximum
#ans: eldest client is 87 years old, which happens at row 3312