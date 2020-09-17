library(fOptions)

set.seed(100)
df <- data.frame(type = sample(c("c", "p"), 100, replace = TRUE), 
                 strike = round(runif(100) * 100, 0), 
                 underlying = round(runif(100) * 100, 0), 
                 Time = 1, 
                 r = 0.01, 
                 b = 0, 
                 sigma = 0.3)

optionprice <- data.frame()
optionprice <- 0
for(i in 1:100)
{
  #YY: TypeFlag needs to be from optionprice
  optionprice <- optionprice + GBSOption(TypeFlag = df$type[i], S = df$underlying[i], X = df$strike[i], 
            Time = 1, r = 0.01, b = 0, sigma = 0.3)@price 
}
cat(paste0("Portfolio price is ", optionprice, ".\n"))

