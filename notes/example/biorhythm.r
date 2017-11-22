library(ggplot2)
library(reshape2)

biorhythm <- function(dob, target = Sys.Date()) {
  dob <- as.Date(dob)
  target <- as.Date(target)
  t <- round(as.numeric(difftime(target, dob)))
  days <- (t - 14) : (t + 14)
  period <- data.frame(Date = seq.Date(from = target - 15, by = 1, length.out = 29),
                       Physical = sin (2 * pi * days / 23) * 100, 
                       Emotional = sin (2 * pi * days / 28) * 100, 
                       Intellectual = sin (2 * pi * days / 33) * 100)
  period <- melt(period, id.vars = "Date", variable.name = "Biorhythm", value.name = "Percentage")
  ggplot(period, aes(x = Date, y = Percentage, col = Biorhythm)) + geom_line() +  
    ggtitle(paste("DoB:", format(dob, "%d %B %Y"))) + 
    geom_vline(xintercept = as.numeric(target))
}

biorhythm("1969-09-12", "2017-03-30")
biorhythm("1981-11-03", "2017-03-30")
