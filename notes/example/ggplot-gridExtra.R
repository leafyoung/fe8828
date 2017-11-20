library(tibble)
library(ggplot2)
library(gridExtra)

df <- tibble(x = rnorm(100), y = rnorm(1000))

# hist_top <- ggplot() + geom_histogram(aes(rnorm(100)))
hist_top <- ggplot(df, aes(x = x)) + geom_density()

empty <-
  ggplot()+geom_point(aes(1,1), colour="white")+
  theme(axis.ticks=element_blank(), 
        panel.background=element_blank(), 
        axis.text.x=element_blank(), axis.text.y=element_blank(),
        axis.title.x=element_blank(), axis.title.y=element_blank())

scatter <- ggplot(df, aes(x = x, y = y)) + geom_point()

hist_right <- ggplot(df, aes(x = y)) + geom_density() +coord_flip()

grid.arrange(hist_top, empty, scatter, hist_right, ncol=2, nrow=2, widths=c(4, 2), heights=c(1, 4))

p1 <- ggplot(bank) + geom_bar(mapping = aes(x = age, fill = job), position = "fill") + coord_polar()
p2 <- ggplot(bank) + geom_bar(mapping = aes(x = age, fill = education), position = "fill") + coord_polar()
grid.arrange(p1, p2, ncol=2, nrow=1)
grid.arrange(p1, p2, ncol=2, nrow=1, widths = c(4,2))
grid.arrange(p1, p2, ncol=1, nrow=2, heights = c(4,2))



