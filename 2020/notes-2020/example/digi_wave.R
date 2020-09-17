digi_wave <- function(days, up, down) {
  cycle <- up + down
  rem <- days %% cycle
  if_else(rem < up, 1, -1)
}

# Test function
digi_wave(3, 1, 2) == 1
digi_wave(5, 1, 2) == -1

digi_wave(0:6, 1, 2)
digi_wave(5, 1, 2) == 1

library(dplyr)
library(tidyr)
library(ggplot2)

biorhythm <- function(dob, target = Sys.Date()) {
  dob <- as.Date(dob)
  target <- as.Date(target)
  t <- round(as.numeric(difftime(target, dob)))
  days <- (t - 14) : (t + 14)
  period <- tibble(Date = seq.Date(from = target - 15, by = 1, length.out = 29),
                   Physical = sin (2 * pi * days / 23) * 100, 
                   Emotional = sin (2 * pi * days / 28) * 100, 
                   Intellectual = sin (2 * pi * days / 33) * 100,
                   WeekEnd = digi_wave(days, 2, 5)*100)
  period <- gather(period, key = "Biorhythm", value = "Percentage", -Date)
  ggplot(period, aes(x = Date, y = Percentage, col = Biorhythm)) +
    geom_line() +  
    ggtitle(paste("DoB:", format(dob, "%d %B %Y"))) + 
    geom_vline(xintercept = as.numeric(target)) +
    theme(legend.position = "bottom")
}

biorhythm("1964-01-01")
