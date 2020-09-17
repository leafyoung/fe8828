count_bizday <- function(year){
  y <- year - (12 - 1) %/% 10
  m <- 1 + 12 * (12 - 1) %/% 10
  c <- y %/% 100
  Y <- y %% 100
  ## Find the day of the week for the first day of the year: "0: Sat", "1: Sun", "2: Mon", etc. 
  day <- ( 1 + Y + Y %/% 4 + c %/% 4 + 5 * c + ( 26 * (m + 1)) %/% 10) %% 7
  ## Find how many days there are in the year
  n_days <- ifelse(year%%100 == 0, ifelse(year%%400 == 0, 1, 0), ifelse(year%%4  == 0, 1, 0)) + 365
  
  bizday <- n_days
  i <- 1
  while (i <= n_days){
    if (day == 0){
      bizday <- bizday - 1
      day <- (day + 1) %% 7
      i <- i + 1
      next
    }
    if (day == 1){
      bizday <- bizday - 1
      day <- (day + 6) %% 7
      i <- i + 6
      next
    }
    day <- (day + 1) %% 7
    i <- i + 1
  }
  return(bizday)
}

count_bizday(2019)