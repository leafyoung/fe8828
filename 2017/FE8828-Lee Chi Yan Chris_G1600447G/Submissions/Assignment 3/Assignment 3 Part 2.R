library(tidyverse)
library(fOptions)

#input data 
options_data<-data_frame(date=c("2017-12-17"),
                         maturity=("2018-01-19"),
                         strike=c(240,250,260,265,270,280,290,300,210,320,330,330,350,360,370,380,390,400,410,420,430,440,450,460,470,480,490,500,510,520,530,540,550,560,570,580,590,600,610,620,630,640,650,660,670,680,690,700,710,720,730,740,750,760,770,780,790,800,810,820,830,840,850,860,870,880,890,900,910,920,930,940,950,960,970,980,990,1000,1010,1020,1030,1040,1050,1060,1080,1100,1120),
                         quantity=1,
                         call_price=c(903.85,929.5,919.5,911.10,906.1,880.95,863.95,877.97,848.5,854.45,847.25,832.05,827.3,805.4,806,786.95,788.3,777.25,755.55,745.1,745.25,705.9,728.48,719.85,698.85,688.6,685.1,679.7,652.9,655.5,635.55,627.8,621,598.25,598,586.25,573.3,579.9,570.35,544,529.05,538.1,521,517.55,483.5, 495,417.95,473.15,459,448.21,437.69,438.4,427.85, 417.9, 406.05,367.42,353.57, 376.24, 370.65, 359.3, 341.5, 340.07, 330.72, 318.52, 305, 298.61, 265.75, 279.2, 267.97, 255.73, 249.14, 225.87, 232.1, 214.95, 211.02, 201.73, 191.8, 182.53, 168.85, 162.41,151.35, 140.8, 134,123.57, 103.9, 86.51, 68.18),
                         put_price=c(.01,.02,.02,.02,.02,.02,.03,.12,.02,.09,.03,.02,.02,.02,.01,.02,.02,.01,.03,.05,.02,.01,.02,.01,.08,.01,.07,.01,.14,.09,.02,.06,.03,.08,.06,.09,.09,.04,.05,.05,.28,.1,.1,.15,.28,.1,.15,.15,.36,.1,.37,.25,.31,.24,.25,.31,.35,.35,.45,.65,.47,.47,.52,.52,.72,.73,.76,.92,.8,1,1.01,1.08,1.08,1.21,1.27,1.5,1.5,1.62,1.65,1.77,2.09,2.29,2.41,2.93,3.95,5.3,8.04))

mutate(options_data, days_to_maturity=as.numeric(as.Date(maturity)-as.Date(date)))

#total valuation of calls
total_valuation_of_calls <- sum(options_data$call_price)
total_valuation_of_calls

#total valuation of puts
total_valuation_of_puts <- sum(options_data$put_price)
total_valuation_of_puts

#Given that Amazon share price is at 1179.14, see below or calls & puts that are in the money.

In_money_call <-dplyr::filter(options_data, strike<1179.14)

In_money_put <- dplyr::filter(options_data, strike>1179.14) 

In_money_call
In_money_put

#plot the volatility curve

#assuming that annualized interest rate = 2.04% (12M LIBOR) & annualized cost of carry=2%;

df<-mutate(options_data, implied_vol_call=0)

df$implied_vol_call <- with(df,mapply(GBSVolatility,call_price,strike,
                            MoreArgs=list(TypeFlag="c",S=1179.4,
                            Time=33/365,r=0.0204,b=0.02,maxiter=500)))

# Use mutate
df <- rowwise(df) %>%
      mutate(implied_vol_call =
        tryCatch({
          GBSVolatility(price = call_price,
                        TypeFlag="c",
                        S = 1179.4,
                        X = strike,
                        Time=33/365,
                        r=0.0204,
                        b=0.02,
                        maxiter=500)
      }, error = function(err) {
        cat(paste0("strike = ", strike, "\n"))
      })) %>% ungroup()

#volatility curve
select(df, implied_vol_call) %>% .$implied_vol_call -> vvv

plot(vvv)

