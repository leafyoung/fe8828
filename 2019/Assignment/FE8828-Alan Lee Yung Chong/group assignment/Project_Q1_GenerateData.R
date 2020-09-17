library(randomNames)
library(dplyr)

set.seed(123)
account_df <- data.frame(AccountNo = 1:10,
                         Name = randomNames(10),
                         Deposit_SGD = sample(1000:2000, 10, replace = T),
                         Credit_Limit_SGD = rep(2000, 10))
save(account_df, file="account_df.rda")

fx_df <- read.csv("Exchange_Rates_Clean.csv", sep=";")
fx_df$DateTime <- paste(paste(fx_df$Year, fx_df$Month, fx_df$Day, sep="-"), "12:00:00")
fx_df$DateTime <- as.POSIXct(fx_df$DateTime, format="%Y-%b-%d %H:%M:%S")
fx_df$Year <- NULL; fx_df$Month <- NULL; fx_df$Day <- NULL;
colnames(fx_df)[1:2] <- c("SGD_per_USD", "SGD_per_CNY")
fx_df$SGD_per_CNY <- fx_df$SGD_per_CNY / 100
save(fx_df, file="fx_df.rda")

transac_df <- data.frame()
set.seed(321)
for (i in account_df$AccountNo){
  n_deposit <- sample(1:2, 3, replace = T)
  n_spend_withdraw <- sample(0:1000, 1)
  n_total <- sum(n_deposit) + n_spend_withdraw
  
  dt_vec <- as.POSIXct(c("2019-07-31 23:59:59", "2019-07-31 23:59:58",
                         "2019-08-31 23:59:59", "2019-08-31 23:59:58",
                         "2019-09-30 23:59:59", "2019-09-30 23:59:58",
                         "2019-10-01 00:00:00"))
  
  dt_seq <- seq(as.POSIXct('2019-07-01'), as.POSIXct('2019-10-01'), by = "sec")
  dt_seq <- dt_seq[-match(dt_vec, dt_seq)]
  
  datetime_vec <- sort(sample(dt_seq, n_total))
  
  deposits_datetime <- c()
  for (j in 1:3){
    temp_dt_vec <- datetime_vec[format(datetime_vec, "%b")==levels(as.factor(format(datetime_vec, "%b")))[j]]
    deposits_datetime <- c(deposits_datetime, as.character(sample(temp_dt_vec, n_deposit[j])))
  }
  deposits_datetime <- as.POSIXct(deposits_datetime)
  
  temp_df <- data.frame(TransactionNo=1:(n_total),
                        DateTime=datetime_vec,
                        AccountNo=i,
                        TransactionType=NA,
                        Amount=NA,
                        Currency=NA)
  temp_df$TransactionType <- sapply(1:nrow(temp_df), 
                                    function(e){
                                      return(ifelse(temp_df$DateTime[e] %in% deposits_datetime,
                                                    "Deposit",
                                                    sample(c("Withdraw", "Spend"), 1)))
                                      })
  mean_lognorm <- rnorm(1, 3, 1)
  sd_lognorm <- rnorm(1, 0.5, 0.15)
  temp_df$Amount <- sapply(1:nrow(temp_df),
                           function(e){
                             return(ifelse(temp_df$TransactionType[e]=="Deposit",
                                           round(sample(1000:2000, 1), 2),
                                           round(rlnorm(1, mean_lognorm, sd_lognorm), 2)))
                             })
  temp_df$Currency <- sample(c("CNY", "SGD", "USD"), nrow(temp_df), replace = T)
  transac_df <- rbind(transac_df, temp_df)
}
save("transac_df", file="transac_df.rda")

