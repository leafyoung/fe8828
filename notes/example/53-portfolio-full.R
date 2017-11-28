library(timetk)
library(tidyverse)
library(tidyquant)
library(highcharter)

symbols <- c("SPY","IJS","EFA","EEM","AGG")

prices <- 
  getSymbols(symbols, src = 'google', from = "2005-01-01", 
             auto.assign = TRUE, warnings = FALSE) %>% 
  map(~Cl(get(.))) %>% 
  reduce(merge) %>%
  `colnames<-`(symbols)

prices_monthly <- to.monthly(prices, indexAt = "first", OHLC = FALSE)

portfolioComponentReturns <- na.omit(Return.calculate(prices_monthly, method = "log"))

w = c(0.25, 0.20, 0.20, 0.25, 0.10)

covariance_matrix <- cov(portfolioComponentReturns)

# Square root of transpose of the weights cross prod covariance matrix returns 
# cross prod weights gives portfolio standard deviation.
sd_portfolio <- sqrt(t(w) %*% covariance_matrix %*% w)

sd_portfolio

# Marginal contribution of each asset. 
marginal_contribution <- w %*% covariance_matrix / sd_portfolio[1, 1]

# Component contributions to risk are the weighted marginal contributions
component_contribution <- marginal_contribution * w 

# This should equal total portfolio vol, or the object `sd_portfolio`
components_summed <- rowSums(component_contribution)

# To get the percentage contribution, divide component contribution by total sd.
component_percentages <- component_contribution / sd_portfolio[1, 1]

percentage_tibble_by_hand <- 
  tibble(symbols, w, as.vector(component_percentages)) %>% 
  rename(asset = symbols, 'portfolio weight' = w, 'risk contribution' = `as.vector(component_percentages)`)

percentage_tibble_by_hand

component_sd_pre_built <- StdDev(portfolioComponentReturns, weights = w, 
                                 portfolio_method = "component")
component_sd_pre_built

# Port to a tibble.  
percentages_tibble_pre_built <- component_sd_pre_built$pct_contrib_StdDev %>%
  tk_tbl(preserve_row_names = FALSE) %>%
  mutate(asset = symbols) %>%
  rename('risk contribution' = data) %>% 
  select(asset, everything(), -index)

percentages_tibble_pre_built

percentage_tibble_by_hand

component_percent_plot <- 
  ggplot(percentage_tibble_by_hand, aes(asset, `risk contribution`)) +
  geom_col(fill = 'blue', colour = 'red') + 
  scale_y_continuous(labels = scales::percent) + 
  ggtitle("Percent Contribution to Volatility", 
          subtitle = "") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(plot.subtitle = element_text(hjust = 0.5)) +
  xlab("Asset") +
  ylab("Percent Contribution to Risk")

component_percent_plot

# gather
percentage_tibble_by_hand_gather <-
  percentage_tibble_by_hand %>% 
  gather(type, percent, -asset)

# built ggplot object
plot_compare_weight_contribution <- 
  ggplot(percentage_tibble_by_hand_gather, aes(x = asset, y = percent, fill = type)) +
  geom_col(position = 'dodge') + 
  scale_y_continuous(labels = scales::percent) + 
  ggtitle("Percent Contribution to Volatility", 
          subtitle = "") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(plot.subtitle = element_text(hjust = 0.5))

plot_compare_weight_contribution

EEM_sd <- StdDev(portfolioComponentReturns$EEM)

EEM_sd_overtime <- 
  round(rollapply(portfolioComponentReturns$EEM, 20, function(x) StdDev(x)), 4) * 100

highchart(type = "stock") %>%
  hc_title(text = "EEM Volatility") %>%
  hc_add_series(EEM_sd_overtime, name = "EEM Vol") %>%
  hc_yAxis(labels = list(format = "{value}%"), opposite = FALSE) %>%
  hc_navigator(enabled = FALSE) %>% 
  hc_scrollbar(enabled = FALSE)
