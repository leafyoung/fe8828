library(tidyverse)
library(dplyr)
library(ggplot2)
bank <- read.csv("https://goo.gl/PBQnBt", sep = ";")

ggplot(airquality, aes(Temp, Ozone)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE)+geom_line()

#non-numeric data
ggplot(bank, aes(default, age)) + geom_point()
ggplot(bank, aes(age, default)) + geom_point()
ggplot(bank, aes(job, age)) + geom_point()

#Add 2nd geometry
ggplot(bank, aes(age, balance)) + geom_point() + geom_smooth()

# adjustment
ggplot(bank, aes(x = age, y = duration, color = job)) +
  geom_point() +
  theme(legend.position="bottom") + # legend position
  coord_flip() + # Switch the x and y axis
  scale_y_log10() + # Make y as log scaled
  xlim(0, 100) # set range of x

g <- ggplot(bank, aes(x = age, y = duration))
g + geom_point() + geom_smooth(method = "lm") + facet_grid(. ~ job) #按Name分面并且Name内容显示在顶部
g + geom_point(color = "steelblue", size = 4, alpha = 1/2) # enforce a certain color, put things outside aes
g + geom_point(aes(color = job), size = 4, alpha = 1/2)
g + geom_point() + geom_point(aes(color = job), size = 4, alpha = 1/2)

# Differentiate groups
ggplot(bank) + geom_point(aes(age, duration, shape = contact)) # shape
ggplot(bank) + geom_point(aes(age, duration, color = contact)) # color
ggplot(bank) + geom_point(aes(age, duration, size = contact)) # size
ggplot(bank) + geom_point(aes(age, duration, alpha = contact)) # alpha
ggplot(bank) + geom_point(aes(age, duration, group = contact)) # group

# reverse a variable
ggplot(bank, aes(age, job)) +
  geom_point() +
  scale_y_discrete(limit = rev(levels(bank$job)))  # alphabetical, discrete
ggplot(bank, aes(age, job)) +
  geom_point() +
  scale_x_reverse() # continuous

# Other geoms
ggplot(bank, aes(job, age)) + geom_boxplot()
ggplot(bank, aes(age, color = job, fill = job, alpha = 0.3)) + geom_density()
ggplot(bank, aes(job, y = education, color = education, fill = education)) + geom_col() # discrete x
ggplot(data = bank, aes(x = duration, fill = job)) + geom_histogram(binwidth = 10) # continuous x
ggplot(data = bank, mapping = aes(x = age, colour = job)) + geom_freqpoly(binwidth = 10)

# bar
ggplot(bank) + geom_bar(aes(x = age)) # count discrete variable
ggplot(bank) + geom_bar(aes(x = age, fill = job)) # comparing to colour, for Bar, we better use fill
ggplot(bank) + geom_bar(aes(x = age, fill = job),position = "fill")
ggplot(bank) + geom_bar(aes(x = age, fill = job),position = "dodge") # adaptive width of the bar
ggplot(bank) + geom_bar(mapping = aes(x = age, fill = job), position = "fill") +
  coord_polar() # circle
ggplot(data = bank, mapping = aes(x = reorder(job, age, FUN = mean),fill = education)) +
  geom_bar() + coord_flip() # sort job by mean age
 
 #composite
ggplot(data = bank, mapping = aes(x = reorder(job, age, FUN = median),fill = education)) +
  # sort the job acccording to median age
  geom_bar() + scale_x_discrete(limit = rev(levels(reorder(bank$job, bank$age, FUN = median)))) +
  # And also add age range and median age.
  geom_line(aes(x = job, y = age)) + 
  geom_point(data = group_by(bank, job) %>% summarize(age = median(age)) %>% ungroup,
             aes(x = job, y = age), inherit.aes = FALSE) +
  xlab("Job sorted according to\nMedian age\n(Top - younger)") + coord_flip()

# Statistical
ggplot(data = bank) +
  stat_summary(
    mapping = aes(x = age, y = balance),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median,
  )

# Facet: Create invidual figures
  # basic
ggplot(data = bank) +
  geom_point(mapping = aes(x = age, y = duration)) +
  facet_grid( ~ education)
  # control number of rows and cols
ggplot(data = bank) +
  geom_point(mapping = aes(x = age, y = duration)) +
  facet_wrap(loan ~ education ~ housing, nrow = 2)

# Levels gives more control to the layer and style.
cutpoints <- quantile(bank$age, seq(0, 1, length = 4), na.rm = TRUE) # The age_group variable is now a categorical factor variable containing
bank$age_group <- cut(bank$age, cutpoints) # 3 levels, indicating the ranges of age.
levels(bank$age_group)
ggplot(bank, aes(age, duration)) +
  geom_point(alpha = 1/3) +
  facet_wrap(job ~ age_group, nrow = 2) + # Use facet_wrap to specify nrow/ncol.
  geom_smooth(method="lm", se=FALSE, col="steelblue") +
  theme_bw(base_size = 10) +
  labs(x = "age", y = expression("log " * Duration)) + # 轴标签
  scale_y_log10() +
  labs(title = "Bank Clients")

# Theme "theme_XXXX"
library(ggthemes)
g <- ggplot(bank, aes(x = age, y = log10(duration)))
g + geom_point(aes(color = job), size = 4, alpha = 1/2) + theme_bw()
g + geom_point(aes(color = job), size = 4, alpha = 1/2) + theme_void()
g + geom_point(aes(color = job), size = 4, alpha = 1/2) + theme_minimal() +
  labs(title = "Duration is longer with age", subtitle = "some random plot", caption = "from MFE") +
  labs(x = "age", y = expression("log " * Duration)) +theme_

# Map
install.packages("maps")
library(maps)
nz <- map_data("nz")
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()
ggplot(bank) + geom_bar(aes(x = age, fill = job),position = "fill")

# generate multiple plots
library(gridExtra)
p1 <- ggplot(bank) + geom_bar(mapping = aes(x = age, fill = job),
                              position = "fill") + coord_polar()
p2 <- ggplot(bank) + geom_bar(mapping = aes(x = age, fill = education),
                              position = "fill") + coord_polar()
grid.arrange(p1, p2, ncol=2, nrow=1, widths = c(4,3))
grid.arrange(p1, p2, ncol=1, nrow=2, heights = c(2,4))

  # Example
library(tibble)
library(ggplot2)
library(gridExtra)
df <- tibble(x = rnorm(1000), y = rnorm(1000))
hist_top <- ggplot(df, aes(x = x)) + geom_density()
empty <-
  ggplot()+geom_point(aes(1,1), colour="white")+
  theme(axis.ticks=element_blank(),
        panel.background=element_blank(),
        axis.text.x=element_blank(), axis.text.y=element_blank(),
        axis.title.x=element_blank(), axis.title.y=element_blank())
scatter <- ggplot(df, aes(x = x, y = y)) + geom_point()
hist_right <- ggplot(df, aes(x = y)) + geom_density() + coord_flip()
grid.arrange(hist_top, empty, scatter, hist_right,
             ncol=2, nrow=2,
             widths=c(3.5, 0.7), heights=c(1, 4))

# knitr/kableExtra
library(knitr)
library(kableExtra)
mtcars[1:10, , drop = F] %>%
  kable("html") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"),
                font_size = 12,
                full_width = T, # True for left-to-right width
                position = "right") # if full_width == F
  # column_spec 对列进行设置
mtcars[1:10, , drop = F] %>%
  kable("html") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"),
                font_size = 12,
                full_width = F, # True for left-to-right width
                position = "left") %>% # if full_width == FALSE
  column_spec(1, bold = T, border_right = TRUE) %>%
  column_spec(2, width = "30em", background = "yellow")
  # row_spec
mtcars[1:10, , drop = F] %>%
  kable("html") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"),
                font_size = 12,
                full_width = F, # True for left-to-right width
                position = "left") %>% # if full_width == F
  column_spec(5:7, bold = TRUE) %>%
  row_spec(3:5, bold = T, color = "white", background = "#D7261E")
  # cell_spec
vol_surface <- tibble(tenor = c("1M", "2M", "3M", "6M"),
                      `0.1` = c(0.472, 0.435, 0.391, 0.29),
                      `0.25` = c(0.431, 0.41, 0.337, 0.28),
                      `0.5` = c(0.398, 0.30, 0.251, 0.2),
                      `0.75` = c(0.428, 0.336, 0.307, 0.249),
                      `0.9` = c(0.457, 0.411, 0.391, 0.278))
# Coloring for volatility surface:
# Include all cells for colors, using gather, cell_spec, then spread
gather(vol_surface, key = "delta", value = "vol", -tenor) %>%
# cell_spec takes column vol. spec_color also takes column vol values into consideration.
# We take half of the spectrurm - yellow to red.
# Color specturm: "magma" (or "A"), "inferno" (or "B"), "plasma" (or "C"), and "viridis" (or "D", the default option).
mutate(vol = cell_spec(
  vol, "html", color = "black", bold = T,
  background = spec_color(vol, begin = 0.5, end = 1,
                          option = "B", direction = -1))) %>%
  spread(key = "delta", value = "vol") %>%
  kable("html", escape = F, align = "c") %>%
  kable_styling("striped", full_width = FALSE)
