count_bizday <- function(year) {  
  x <- as.numeric(strftime(as.Date(paste0(year,"-01-01")), "%u"))
  if ((year%%400==0)||(year%%4==0&year%%100!=0)) {
    leap=T
  }else{
    leap=F
  }
  if (leap==F) {
    if (x==5||x==6) {
      return(52*5)
    }else{
      return(52*5+1) 
    }
  }else{
    if (x==5){
      return(52*5)
    }else if (x==4||x==6) {
      return(52*5+1) 
    }else{
      return(52*5+2)  
    }
  }
}

count_bizday(2019)

