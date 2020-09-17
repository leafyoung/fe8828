## Can consider return numeric, i.e. return(262), instead of return string.

count_bizday <- function(year) {
  #if leap year
  if((year %% 400 == 0) | ((year %% 4 == 0) && (year %% 100 !=0))){
    days = 366
    firstday<-weekdays(as.Date(paste0(year,"-01-01")))
    if(firstday=="Monday") {
      return("262")
    } else if(firstday=="Tuesday") {
      return("262")
    } else if(firstday=="Wednesday") {
      return("262")
    } else if(firstday=="Thursday") {
      return("262")
    } else if(firstday=="Friday") {
      return("261")
    } else if(firstday=="Saturday") {
      return("260")
    } else if(firstday=="Sunday") {
      return("261")
    } else {
      stop("Invalid")
    }
    
  } else{
    days = 365
    # YY: typo: y should be year
    # firstday<-weekdays(as.Date(paste0(y,"-01-01")))
    firstday<-weekdays(as.Date(paste0(year,"-01-01")))
    if(firstday=="Monday") {
      return("261")
    } else if(firstday=="Tuesday") {
      return("261")
    } else if(firstday=="Wednesday") {
      return("261")
    } else if(firstday=="Thursday") {
      return("261")
    } else if(firstday=="Friday") {
      return("261")
    } else if(firstday=="Saturday") {
      return("260")
    } else if(firstday=="Sunday") {
      return("260")
    } else {
      stop("Invalid")
    }
  }  
}
