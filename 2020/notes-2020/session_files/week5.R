library(conflicted)
library(quantmod)
conflict_prefer('lag', 'dplyr')
conflict_prefer('filter', 'dplyr')

getSymbols("SPY", src = "yahoo", adjusted = TRUE, output.size = "full")

SPY

str(SPY)
head(SPY)
tail(SPY)

SPY['2009-11']

SPY['2009-11/']

tibble(Date = index(SPY['2009-11']), as_tibble(coredata(SPY['2009-11'])))


