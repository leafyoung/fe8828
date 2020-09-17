count_bizday <- function(year) { 
  month = 1
  day = 1
  t = (12 - month) %/% 10
  y = year - t
  m = month + 12 * t
  c = y %/% 100
  Y = y %% 100
  w = (day + Y + Y %/% 4 + c %/% 4 + 5 * c + (26 * (m + 1)) %/% 10) %% 7  
  #Zeller 0-Saturday 1-Sunday...
  biz_day = 52 * 5
  if (year %% 400 ==0 | year %% 4 == 0 & year %% 100 != 0)
    leapyear = 1
  else
    leapyear = 0
  if(leapyear){
    if(w != 0){
      if(w == 1 | w == 6)
        biz_day = biz_day + 1
      else
        biz_day = biz_day + 2
    }
  }
  else{
    if(!(w == 0 | w == 1))
      biz_day = biz_day + 1
  }
  biz_day
}
