---
title: "Chart"
output: html_document
---
```{r, include=FALSE}
library(quantmod)
loadSymbols(Symbols = "BTCUSD=X",  src="yahoo")
chartSeries(`BTCUSD=X`,subset="last 12 months")
```

```{r,echo=FALSE}
addMACD()
```