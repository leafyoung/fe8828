# 2-ex-2.R

is_leap_year <- function(yr) {
  yr <- as.numeric(year)
  yr <- year(yr)
  
  yr <- as.numeric(as.character(yr, format = "%Y"))
  
  if ((yr %% 400 == 0) | (yr %% 4 == 0 & yr %% 100 != 0)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

is_leap_year(as.Date("2014-01-01"))