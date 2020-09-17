library("bizdays")

count_bizday  <- function(year){
  Year <- toString(year, "string")
  s <- c(bizseq(paste0(Year,"-01-01"), paste0(Year,"-12-31"), cal="weekends"))
  return(length(s))
}

count_bizday(2000)
count_bizday(2005)
count_bizday(2019)
