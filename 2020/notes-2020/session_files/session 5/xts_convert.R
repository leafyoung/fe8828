getSymbols("^RUT")
getSymbols("SPY")

convert_xts <- function(x) {
  bind_cols(tibble(Date = index(x)), as_tibble(coredata(x)))
}

df_RUT <- convert_xts(RUT)
df_SPY <- convert_xts(SPY)

g <- ggplot() +
  geom_line(data = df_RUT, aes(x = Date, y = RUT.Adjusted, color = "RUT")) +
  geom_line(data = df_SPY, aes(x = Date, y = SPY.Adjusted * 5, color = "SPY"))

# ggplot
g

# dygraph
dygraph(RUT, main = "Russell 2000") %>%
  dySeries("RUT.Adjusted", label = "Actual")

# plotly
ggplotly(g)