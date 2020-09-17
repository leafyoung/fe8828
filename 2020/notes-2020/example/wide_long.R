library(tidyverse)

df <- group_by(bank, job) %>%
  summarize(yy = sum(ifelse(default == "yes", 1, 0)),
            nn = sum(ifelse(default == "no", 1, 0)))

df2 <- gather(df, key, value, -job) # wide => long

ggplot(df2) + geom_bar(aes(x = key, y = value, fill = job), stat = "identity")
