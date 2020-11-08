daily_ret

As our group proceed to do the project, we discovered that the sum of cumulative gross return Ri (i means each ETF, e.g.XLB_cumret) is not equal to 9*portfolio cumulative return(daily_ret$EW_cumret), which intuitively should be equal for the no-balance portfolio.

w <- rep(1, len_invest) / len_invest
daily_ret['EW'] <- as.matrix(daily_ret[,2:(2+len_invest-1)]) %*% w

tail(daily_ret,1) %>%
  select(XLB_cumret:XLY_cumret) %>% 
  pivot_longer(XLB_cumret:XLY_cumret) %>%
  summarise(vvv = sum(value) / 9) 

tail(daily_ret['EW_cumret'],1)

1 + 0.1 + 0.1 + 0.1 => 2.0/1.99999
(1.000001)**5263


daily_ret['EW_daily'] <- as.matrix(daily_ret[,2:(2+len_invest-1)]) %*% w
daily_ret %>% {plot(.$Date,.$EW_daily,type='l')}
daily_ret['EW_daily_cumret'] <- cumprod(daily_ret['EW_daily'] + 1)

daily_ret
str(daily_ret)

daily_ret_n <- daily_ret %>% nest(ret = c(XLB:XLY), cumret = c(XLB_cumret:XLY_cumret))

# when re-balance, multiple weights with cumret, otherwise, multiply cumret with ret

for (ii in 1:len_tickers) {
  daily_ret[paste0(all_tickers[ii],"_cumret")] <- cumprod(1 + daily_ret[all_tickers[ii]])
}

row_daily_ret <- nrow(daily_ret)

rebal_days <- 1:row_daily_ret
w0 <- w
for (ii in 1:row_daily_ret) {
  if (ii == 1) {
    prev_cumret <- matrix(w0,1,len_invest)
  }
  daily_ret[ii,12:20] <- prev_cumret * as.matrix(1 + daily_ret[ii,2:10])    
  if (ii %in% rebal_days) {
    port_sum <- sum(daily_ret[ii,12:20])
    daily_ret[ii,12:20] <- matrix(rep(port_sum, len_invest) / len_invest, 1, len_invest)
  }
  prev_cumret <- as.matrix(daily_ret[ii,12:20])
}

daily_ret[row_daily_ret, 12:20]
