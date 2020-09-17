library("fOptions")
library('dplyr')

set.seed(100)
df2 <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE),
                 strike = round(runif(100) * 100, 0),
                 underlying = round(runif(100) * 100, 0),
                 Time = 1,
                 r = 0.01,
                 b = 0,
                 sigma = 0.3)

# GBSOption(TypeFlag = "p", S = 3500, X = 3765,
#           Time = 1/12, r = 0, b = 0, sigma = 0.3)@price
get_price <- function(df){
  df$row_num = 1:nrow(df)
  price_ = c(1:nrow(df))
  for (i in 1:nrow(df)){
    currentopt <- dplyr::filter(df, row_num==i)
    ## YY: S = currentopt$strike, X = currentopt$underlying are mismatched.
    ## S = underlying, X = strike
    optprice <- GBSOption(TypeFlag = currentopt$type, S = currentopt$strike, X = currentopt$underlying,
              Time = currentopt$Time, r = currentopt$r, b = currentopt$b, sigma = currentopt$sigma)@price
    price_[i] <- optprice
  }
  return (sum(price_)) # total value
}

# call the function
get_price(df2)
