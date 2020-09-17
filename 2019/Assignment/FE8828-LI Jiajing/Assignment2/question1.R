count_bizday <- function(year){ 
  if(year %% 100==0){
    if(year %% 400==0)
      x <- 366
    else
      x <- 365
  }
  else{
    if(year %% 4==0)
      x <- 366
    else
      x <- 365
  }
  y <- year-1
  m <- 13
  c <- y %/% 100
  Y <- y %% 100
  w <- (1 + Y + Y %/% 4 + c %/% 4 +5*c +364 %/% 10) %% 7
  if(x == 365)
  {
    if(w==0)
      n <- 52*5
    else if(w==1)
      n <- 52*5
    else if((w!=1)&(w!=0))
      n <- 52*5+1
  }
  if(x == 366)
  {
    if(w==6)
      n <- 52*5+1
    else if(w==0)
      n <- 52*5
    else if(w==1)
      n <- 52*5+1
    else if((w!=6)&(w!=0)&(w!=1))
      n <- 52*5+2
  }
  cat(n)
}

count_bizday(2005)
count_bizday(2019)
