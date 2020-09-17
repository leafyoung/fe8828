count_bizdays <- function(year){
  all_days <- seq(as.Date(paste0(as.character(year),"-01-01")),
                as.Date(paste0(as.character(year),"-12-31")),by = "day")

  workdays <- all_days[!(weekdays(all_days) %in% c("ÐÇÆÚÁù","ÐÇÆÚÈÕ"))]  
  nn <- length(workdays)
  
  return(nn)
}


