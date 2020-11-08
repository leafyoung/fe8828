library(conflicted) 
library(tidyquant) 
conflict_prefer("filter", "dplyr") 
conflict_prefer("lag", "dplyr")
getSymbols('SPY', src = 'yahoo', adjusted = TRUE, output.size = 'full')














