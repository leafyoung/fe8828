# biorhythm.R

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
                       Intellectual = sin (2 * pi * days / 33) * 100)
  period <- gather(period, key = "Biorhythm", value = "Percentage", -Date)
  ggplot(period, aes(x = Date, y = Percentage, col = Biorhythm)) + geom_line() +  
    ggtitle(paste("DoB:", format(dob, "%d %B %Y"))) + 
    geom_vline(xintercept = as.numeric(target)) +
    theme(legend.position = "bottom")
}

# I took four people's birthdays. Hope they are in good mode today.
biorhythm("1964-01-12", Sys.Date())
biorhythm("1971-06-28", Sys.Date())
biorhythm("1971-10-29", Sys.Date())
biorhythm("1957-08-11", Sys.Date())
