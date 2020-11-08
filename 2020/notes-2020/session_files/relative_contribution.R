library(conflicted)
library(tidyverse)
conflict_prefer('lag', 'dplyr')
conflict_prefer('filter', 'dplyr')

tibble(t = 1:10, v1 = 1:10, v2 = 10:1) %>% pivot_longer(cols = v1:v2) %>%
  ggplot(.) + geom_line(aes(x = t, y = value, color = name))

tibble(t = 1:10, v1 = (1:10) * 2, v2 = 30:21) %>% pivot_longer(cols = v1:v2) %>%
  ggplot(.) + geom_area(aes(x = t, y = value, fill = name)) # , position = 'fill'

tibble(t = 1:10, v1 = (1:10) * 2, v2 = 30:21) %>% pivot_longer(cols = v1:v2) %>%
  ggplot(.) + geom_area(aes(x = t, y = value, fill = name), position = 'fill')

tibble(t = 1:10, v1 = (1:10) * 2, v2 = 30:21) %>% pivot_longer(cols = v1:v2) %>%
  rowwise %>% mutate(vv = list(rep(TRUE, round(value,0)))) %>% ungroup %>% unnest(vv) %>%
  ggplot(.) + geom_bar(aes(x = t, fill = name), position = 'fill')
