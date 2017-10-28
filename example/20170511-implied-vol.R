library(fOptions)

EuropeanOption(type="call", underlying=1.56, strike=1.6, dividendYield=0.06-0.08, riskFreeRate=0.06, maturity=1/2, volatility=0.12) 

a <- GBSCharacteristics(TypeFlag = "c", S = 1.5600, X = 1.6000,  Time = 1/2, r = 0.06, b = 0.06-0.08, sigma = 0.12)

GBSOption(TypeFlag = "p", S = 3500, X = 3765, Time = 1/12, r = 0, b = 0, sigma = 0.3)@price
GBSGreeks("delta", TypeFlag = "p", S = 3500, X = 3765,  Time = 1/12, r = 0, b = 0, sigma = 0.3)
GBSGreeks("delta", TypeFlag = "p", S = 3500, X = 3765,  Time = 1/365, r = 0, b = 0, sigma = 0.3)

y <- rep(0,0)
ii <- seq(from=1/12, to=1/365, by = -(1/365))
for (i in ii) {
  x <- GBSGreeks("delta", TypeFlag = "p", S = 3500, X = 3765,  Time = i, r = 0, b = 0, sigma = 0.3)
  x <- GBSOption(TypeFlag = "p", S = 3500, X = 3765, Time = i, r = 0, b = 0, sigma = 0.3)@price
  y <- c(y, x)
}
plot(ii, y)

GBSVolatility(price = 200, TypeFlag = "p", S = 3500, X = 3700, Time = 1/12, r = 0, b = 0)
GBSOption(TypeFlag = "p", S = 3500, X = 3500,  Time = 1/12, r = 0, b = 0, sigma = 0.74)@price
GBSOption(TypeFlag = "p", S = 3500, X = 3500,  Time = 1/12, r = 0, b = 0, sigma = 0.74)@price
Black76Option(TypeFlag = "p", FT = 3500, X = 3500,  Time = 1/12, r = 0, sigma = 0.74)@price

GBSGreeks("delta", TypeFlag = "p", S = 3500, X = 3500,  Time = 1/12, r = 0, b = 0, sigma = 0.74)
GBSGreeks("delta", TypeFlag = "p", S = 3500, X = 3500,  Time = 1/365, r = 0, b = 0, sigma = 0.3)

y <- rep(0,0)
ii <- seq(from=1/12, to=1/365, by = -(1/365))
vool <- seq(from=0.74, to=0.3, length.out=length(ii))
for (i in seq(1,length(ii))) {
  x <- GBSGreeks("delta", TypeFlag = "p", S = 3500, X = 3765,  Time = i, r = 0, b = 0, sigma = 0.3)
  x <- GBSOption(TypeFlag = "p", S = 3500, X = 3700,  Time = ii[i], r = 0, b = 0, sigma = vool[i])@price
  y <- c(y, x)
}
plot(ii, y)

