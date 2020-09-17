GOOG <- read_csv("GOOG.csv",
                 col_types = cols(
                   Date = col_date(format = "%Y-%m-%d"),
                   Volume = col_double()))

GOOG[1:30, ] %>% {
  ggplot(data = .,
         aes(x = Date,
             lower=.$Open,
             middle=.$Close,
             upper=.$Close,
             ymin=.$Low,
             ymax=.$High,
             fill = Open < Close)) +
    geom_boxplot(stat='identity')
}


