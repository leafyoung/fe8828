# install.R
# FE8828
# Author: Yang Ye

list.of.packages <- c("tibble", "openssl","testit","sodium")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
