# Load the packages - you won't know in the beginning.
# Slowly add this list up.


library(rattle)# normVarNames().
library(readr)# Efficient reading of CSV data.
library(dplyr)# Data wrangling, glimpse() and tbl_df().
library(tidyr)# Prepare a tidy dataset, gather().
library(magrittr)# Pipes %>% and %T>% and equals().
library(glue)# Format strings.
library(lubridate)# Dates and time.
library(FSelector)# Feature selection, information.gain().
library(stringi)# String concat operator %s+%.
library(stringr)# String operations.
library(randomForest)# Impute missing values with na.roughfix().
library(ggplot2)# Visualise data.

library(magrittr)

# dfpath <- "http://rattle.togaware.com/weatherAUS.csv"
dfpath <- "https://www.dropbox.com/s/dknnj9fbjhm33iw/weatherAUS.csv?dl=1"

dfpath <- "http://bit.ly/fe8828_weatherAUS2"

# load the original data
weatherAUS <- read_csv(file=dfpath)

# add more details and load again
weatherAUS <- read_csv(file=dfpath,
                       col_types = list(
                         .default = col_double(),
                         Date = col_date(format = ""),
                         Location = col_character(),
                         Evaporation = col_double(),
                         Sunshine = col_double(),
                         WindGustDir = col_character(),
                         WindDir9am = col_character(),
                         WindDir3pm = col_character(),
                         RainToday = col_character(),
                         RainTomorrow = col_character()))

glimpse(weatherAUS)

# a copy of original data
df <- weatherAUS

# colnames
names(df)

# change all names to small cases
names(df) <- tolower(names(df))

# Find all character fields
charc <- df %>% select_if(is.character, function(x) {x}) %>% colnames
charc

df[charc] %>% sapply(unique)

df$location %>% unique() %>% length()
df$location %>% table()

# change all character fields to factor
df %>% mutate_if(is.character, function(x) factor(x))

# Wind direction
df %>% select(contains("dir")) %>% sapply(table)

# Find all wind directions
compass <- df %>% select(contains("dir")) %>% gather(type, value) %>% .$value %>% unique %>% sort
compass

# Rain
df %>% select_at(vars("raintoday", "raintomorrow")) %>% sapply(table)

# convert to logic type
df <- df %>% mutate(raintoday = raintoday == "Yes",
                    raintomorrow = raintomorrow=="Yes")

df %>%
  select(raintoday, raintomorrow) %>% 
  summary()

# With some knowledge of the data we observe risk_mm captures the amount of rain recorded
# tomorrow. We refer to this as a risk variable, being a measure of the impact or risk of the target
# we are predicting (rain tomorrow). The risk is an output variable and should not be used as
# an input to the modelling—it is not an independent variable. In other circumstances it might
# actually be treated as the target variable.

# If not rains
df %>% filter(!raintomorrow) %>% select(risk_mm) %>% summary()

# If rains
df %>% filter(raintomorrow) %>% select(risk_mm) %>% summary()

# all variables/columns
vars <- names(df)

risk <- "risk_mm"

# find all numeric fields
num1 <- df %>% select_if(is.numeric) %>% colnames

# Given a date and a location we have an observation of the remaining
# variables. Thus we note that these two variables are so-called identifiers.
# Identifiers would not usually be used as independent variables for building predictive analytics models.

id<-c("date", "location")

# count per location/date
df[id] %>%
  group_by(location) %>% 
  count() %>%
  rename(days=n) %>%
  mutate(years=round(days/365)) %>% 
  as.data.frame() %>% 
  sample_n(10)

df[id] %>%
  group_by(location) %>% 
  count() %>%
  rename(days=n) %>%
  mutate(years=round(days/365)) %>%
  ungroup() %>%
  select(years) %>%
  summary()

ignore <- union(id, risk)
ignore

# We might also check for any variable that has a unique value for every observation
ids <- df[vars] %>%
  sapply(function(x) x %>% unique() %>% length()) %>% 
  equals(nrow(df)) %>%
  which() %>%
  names()

ids

# Fortunately, nothing
ignore <- union(ignore, ids)

# Ignore missing
missing <- df[vars] %>% 
  sapply(function(x) x %>% is.na %>% sum) %>%
  equals(nrow(df)) %>%
  which() %>%
  names()
missing

# Or mostly missing
missing.threshold <- 0.7

mostly <- df[vars] %>%
  sapply(function(x) x %>% is.na() %>% sum() / length(x))

mostly %>%
  '>'(missing.threshold) %>%
  which() %>%
  names() %T>%
  print()

ignore <- union(ignore, missing) %>% union(mostly)
ignore

# ignore excessive level variables
levels.threshold <- 20

# Identify variables that have too many levels.
too.many <- df[vars] %>%
  select_if(is.character) %>%
  names() %>%
  sapply(function(x) df %>% extract2(x) %>% unique %>% length()) %>%
  '>='(levels.threshold) %>%
  which() %>%
  names() %T>%
  print()

ignore <- union(ignore, too.many)
ignore

# ignore constants
constants <- df[vars] %>%
  sapply(function(x) all(x==x[1L])) %>% 
  which() %>% 
  names()
constants

ignore <- union(ignore, constants)

# Eliminate highly correlated
numc <- vars %>% 
  setdiff(ignore) %>%
  extract(df, .) %>% 
  select_if(is.numeric) %>% 
  colnames()
numc

df[numc] %>%
  cor(use="complete.obs") %>% 
  ifelse(upper.tri(.,diag=TRUE),NA, .) %>%
  abs %>%
  data.frame %>%
  tbl_df %>%
  set_colnames(numc) %>%
  mutate(var1=numc) %>%
  gather(var2, cor,-var1) %>%
  na.omit %>%
  arrange(-abs(cor))

correlated<-c("temp3pm","pressure3pm","temp9am")

ignore <- union(ignore, correlated)
ignore

# Use caret package
library(caret)
correlationMatrix <- cor(df[,numc], use="complete.obs")
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.8)
highlyCorrelated

# Just keep one variable for temperature
correlated <- numc[highlyCorrelated]
correlated <- correlated[-1]
correlated

# Final list of variable to build the model
vars <- setdiff(vars, ignore)
length(vars)

vars

# put raintomorrow first
target <- "raintomorrow"
vars <- c(target, vars) %>% unique()

# Use correlation search to identify key variables.
cfs(form, df[vars])

# Use information gain to identify variable importance.
information.gain(form, df[vars])

missing.target <- df %>% extract2(target) %>% is.na()
sum(missing.target)

library(purrr)

nrow(df)

df <- df %>% filter_at(vars(target), compose(not, is.na))
nrow(df)

df <- mutate_if(df, is.character, factor)

# omit na or fix
df_omit <- df %>% filter_at(vars(vars), compose(not, is.na))
nrow(df_omit)

# convert all character to levels
df_nafix <- df
df_nafix[vars] <- df_nafix[vars] %>% randomForest::na.roughfix()

nrow(df_nafix)

df_nafix %>%
  ggplot(aes_string(x=target)) +
  geom_bar(width=0.2,fill="grey") +
  theme(text=element_text(size=14))

df_omit %>%
  ggplot(aes_string(x=target)) +
  geom_bar(width=0.2,fill="grey") +
  theme(text=element_text(size=14))

inputs <- setdiff(vars, target)
inputs
df

set.seed(7465)
getwd()

# Other tools
# Cluster the numeric data per location.
add_cluster <- function(df_sel) {
  NCLUST <- 5
  
  cluster <- df_sel[c("location", numc)] %>%
    group_by(location) %>%
    summarise_all(funs(mean(., na.rm=TRUE))) %T>%
    {locations <<- .$location} %>% # Store locations for later.
    select(-location) %>%
    sapply(function(x) ifelse(is.nan(x), 0, x)) %>%
    as.data.frame() %>%
    sapply(scale) %>%
    kmeans(NCLUST) %T>%
    print() %>%
    extract2("cluster")
  
  cluster
  
  ## K-means clustering with 5 clusters of sizes 4, 22, 10, 8, 5
  ##
  ## Cluster means:
  ## min_temp max_temp rainfall evaporation sunshine
  ## 1 -0.6271436 -0.5345409 0.061972675 -1.2699891 -1.21861982
  ## 2 -0.3411683 -0.5272989 -0.007762188 0.1137179 0.09919753
  head(cluster)
  ## [1] 3 2 2 3 4 2
  
  # Index the cluster vector by the appropriate locations.
  names(cluster) <- locations
  # Add the cluster to the dataset.
  df_sel %<>% mutate(cluster="area" %>%
                       paste0(cluster[df_sel$location]) %>%
                       as.factor)
  # Check clusters.
  df_sel %>% select(location, cluster) %>% sample_n(10)

  print(cluster[levels(df_sel$location)] %>% sort())
  df_sel
}

df_omit <- add_cluster(df_omit)
df_nafix <- add_cluster(df_nafix)

# add cluster to vars
vars <- c(vars, "cluster") %>% unique
vars

save(list = c("df_nafix", "df_omit", "vars", "inputs", "target", "risk"),
     file = "E:/Dropbox/Docs/MFE/FE8828/2019/notes-2019/new2019/data_model.Rda")