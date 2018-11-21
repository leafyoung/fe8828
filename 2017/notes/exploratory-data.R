Data analytics

# install.packages("plyr")

ozone <- plyr::ozone

nrow(ozone)
ncol(ozone)

str()

head(ozone[, c(6:7, 10)])
tail(bank[])

Hypothesis?
Does season matters?
Does employment matters?
Does age matters?

boxplot(bank$age, col = "blue")

> hist(bank$age, col = "orange")
> rug(bank$age)

> hist(bank$age, col = "green", breaks = 100)
> rug(bank$age)

> library(ggplot2)

> qplot(latitude, pm25, data = pollution, facets = . ~ region)

select(ozone, State.Name) %>% unique %>% nrow

> filter(ozone, State.Name == "Oklahoma" & County.Name == "Caddo") %>%
+         mutate(month = factor(months(Date.Local), levels = month.name)) %>%
+         group_by(month) %>%
+         summarize(ozone = mean(Sample.Measurement))


# color
> library(RColorBrewer)
> display.brewer.all()

# matrix/heatmap

> set.seed(12345)
> dataMatrix <- matrix(rnorm(400), nrow = 40)
> image(1:10, 1:40, t(dataMatrix)[, nrow(dataMatrix):1])

> heatmap(dataMatrix)
