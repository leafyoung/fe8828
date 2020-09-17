library("readxl")
library("dplyr")
library("fOptions")
library("ggplot2")

#part 1:read data from excel.
option_data <- read_excel("option_data.xlsx")
cleaned_opt <- mutate(option_data, Expiry = as.Date("2019-12-20"), Underlying = 1234.03)

#part 2: calculate open interest.
get_open_interest <- function(df){
  cleaned_opt <-mutate(df, Underlying = 1234.03)
  df<-mutate(cleaned_opt, valuation=`Open Interest`*(Bid+Ask)/2)
  call_put_valuation <- df %>% group_by(Type) %>% summarise(`total valuation`=sum(valuation) ) 
  total_valuation <- df %>% summarize(`all valuation`= sum(valuation))
  return(total_valuation)
}

# part 3: get open interest summation for in the money call and put option
get_itm_opt <- function(df){
  df_money_call <- df %>% filter((Type=='C')&(Strike < Underlying[1])) %>% summarise(total_open_interest = sum(`Open Interest`))
  call_agg <- df_money_call$total_open_interest[[1]]
  print(paste0("The total open interest for in-the-money call option is $", call_agg))
  df_money_put <- df %>% filter((Type=='P')&(Strike > Underlying[1])) %>% 
    summarise(total_open_interest = sum(`Open Interest`))
  put_agg <- df_money_put$total_open_interest[[1]]
  print(paste0("The total open interest for in-the-money put option is $", put_agg))
  }

#4: plotting volatility curve
# df = cleaned_opt
plot_volatility <- function(df){
  df_parse <- df %>% mutate(optiontype= case_when(Type == "P"~'p',
                                                           Type == "C"~'c'))
  # filter out of the money call and put option
  underlying = df_parse$Underlying[[1]]
  #out-of-money call option
  df_otm_call <- df_parse %>% dplyr::filter(optiontype=='c'& Strike>underlying)
  #out-of-money put option
  df_otm_put <- df_parse %>% dplyr::filter(optiontype=='p'& Strike<underlying)
  nrow(df_otm_call)
  nrow(df_otm_put)
  otm_options <- rbind(df_otm_call,df_otm_put)
  implied_vol = c(1:nrow(otm_options))
  otm_options$row_num = c(1:nrow(otm_options))
  
  # Strike < current price, use puts’
  # price; for strike > current price, use calls’ price.
  for (i in 1:nrow(otm_options)){
    currentopt <- dplyr::filter(otm_options, row_num==i)
    ind_volatility<- GBSVolatility(currentopt$`Last Price`,currentopt$optiontype,
                  currentopt$Underlying , currentopt$Strike,
                  as.numeric((as.Date(currentopt$Expiry) -
                                as.Date("2019-09-26")))/365, r = 0.03, b = 0)
    implied_vol[[i]] = ind_volatility
  }
  otm_options$calc_vol <- implied_vol
  
  ggplot(otm_options, aes(Strike, calc_vol)) + geom_point() + 
    geom_smooth(method = "loess", se = FALSE, color ="darkred") +
   xlab("Strike price") + ylab("Implied Volatility") + ggtitle("Volatility Curve") +
    theme(plot.title = element_text(hjust = 0.5))
  }

