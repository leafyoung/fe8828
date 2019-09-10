
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

dfpath <- "http://rattle.togaware.com/weatherAUS.csv"

weatherAUS <- read_csv(file=dfpath)

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

names(df)

names(df) <- tolower(names(df))

names(df) <- str_replace(names(df), "^[^_]*_","")

# All character fields
charc <- df %>% select_if(is.character, function(x) {x}) %>% colnames

df[charc] %>% sapply(unique)

df %>% mutate_if(is.character, function(x) factor(x))

df$location %>% unique() %>% length()
df$location %>% table()

# Wind direction
df %>% select(contains("dir")) %>% sapply(table)

compass <- df %>% select(contains("dir")) %>% gather(type, value) %>% .$value %>% unique %>% sort

# Rain
df %>% select_at(vars("raintoday", "raintomorrow")) %>% sapply(table)

df <- df %>% mutate(raintoday = raintoday == "Yes",
                    raintomorrow = raintomorrow=="Yes")

num1 <- df %>% select_if(is.numeric) %>% colnames

df %>%
  select(raintoday, raintomorrow) %>% 
  summary()

vars <- names(df)

risk <- "mm"

# If not rains
df %>% filter(!raintomorrow) %>% select(mm) %>% summary()

# If rains
df %>% filter(raintomorrow) %>% select(mm) %>% summary()

# 
id<-c("date", "location")

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
# Fortunately, nothing

ignore <- union(ignore, ids)

# Ignore missing
missing <- df[vars] %>% 
  sapply(function(x) x %>% is.na %>% sum) %>%
  equals(nrow(df)) %>%
  which() %>%
  names()

ignore <- union(ignore, missing)
ignore

# ignore constants

constants <- df[vars] %>%
  sapply(function(x) all(x==x[1L])) %>% 
  which() %>% 
  names()

ignore <- union(ignore, constants)

# Eliminate highly correlated
numc <- vars %>% 
  setdiff(ignore) %>%
  extract(df, .) %>% 
  select_if(is.numeric) %>% 
  colnames()

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

# Use caret package
library(caret)
correlationMatrix <- cor(df[,numc], use="complete.obs")
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.8)

correlated <- numc[highlyCorrelated][-1]

vars <- names(df)
vars <- setdiff(vars, ignore)
length(vars)

# put raintomorrow first
target <- "raintomorrow"
vars <- c(target, vars) %>% unique()

form <- formula(paste0(target, " ~ ."))

# Use correlation search to identify key variables.
cfs(form, df[vars])

# Use information gain to identify variable importance.
information.gain(form, df[vars])

nrow(df)
df <- df %>% filter_at(vars(target), compose(not, is.na))

nrow(df)
df <- df %>% filter_at(vars(vars), compose(not, is.na))
nrow(df)

df <- mutate_at(df, target, as.factor)

df %>%
  ggplot(aes_string(x=target)) +
  geom_bar(width=0.2,fill="grey") +
  theme(text=element_text(size=14))

inputs <- setdiff(vars, target)
input1 <- which(names(df) %in% inputs)


set.seed(7465)
# Cluster the numeric data per location.
NCLUST <- 5


df[c("location", numc)] %>%
  group_by(location) %>%
  summarise_all(funs(mean(., na.rm=TRUE))) %T>%
  {locations <<- .$location} %>% # Store locations for later.
  select(-location) %>%
  sapply(function(x) ifelse(is.nan(x), 0, x)) %>%
  as.data.frame() %>%
  sapply(scale) %>%
  kmeans(NCLUST) %T>%
  print() %>%
  extract2("cluster")->
  cluster

## K-means clustering with 5 clusters of sizes 4, 22, 10, 8, 5
##
## Cluster means:
## min_temp max_temp rainfall evaporation sunshine
## 1 -0.6271436 -0.5345409 0.061972675 -1.2699891 -1.21861982
## 2 -0.3411683 -0.5272989 -0.007762188 0.1137179 0.09919753
....
head(cluster)
## [1] 3 2 2 3 4 2

# Index the cluster vector by the appropriate locations.
names(cluster) <- locations
# Add the cluster to the dataset.
df %<>% mutate(cluster="area" %>%
                 paste0(cluster[df$location]) %>%
                 as.factor)

# Check clusters.
df %>% select(location, cluster) %>% sample_n(10)
## # A tibble: 10 x 2
## location cluster
## <fctr> <fctr>
## 1 richmond area2
## 2 cobar area3
## 3 mount_gambier area2
## 4 nhil area4
## 5 sydney area2
## 6 launceston area2
## 7 mount_ginini area1
## 8 wollongong area2
## 9 gold_coast area4
## 10 hobart area2

vars %<>% c("cluster")

cluster[levels(df$location)] %>% sort()

# Preparing for data modeling

form <- df[vars] %>%
  formula() %>%
  print()

seed <- 42
set.seed(seed)

nobs %>%
  sample(0.70*nobs) %T>%
  {length(.) %>% comcat()} %T>%
  {sort(.) %>% head(30) %>% print()} ->
  train

## 94,343
## [1] 1 4 7 9 10 11 12 13 14 15 16 17 18 19 21 22 23 24 26
## [20] 28 31 32 33 35 37 40 41 42 43 45

nobs %>%
  seq_len() %>%
  setdiff(train) %>%
  sample(0.15*nobs) %T>%
  {length(.) %>% comcat()} %T>%
  {sort(.) %>% head(15) %>% print()} ->
  validate

nobs %>%
  seq_len() %>%
  setdiff(union(train, validate)) %T>%
  {length(.) %>% comcat()} %T>%
  {head(.) %>% print(15)} ->
  test

# Cache the various actual values for target and risk.
tr_target <- df[train,][[target]] %T>%
  {head(., 20) %>% print()}
## [1] no no no no no no no no no no no no no no
## [15] no no no no yes no
....
tr_risk <- df[train,][[risk]] %T>%
  {head(., 20) %>% print()}
## [1] 0.0 0.0 0.0 0.0 0.4 0.0 0.2 0.0 0.0 0.0 0.0 0.2 0.2 1.0
## [15] 0.2 0.0 0.0 0.0 1.2 0.0

va_target <- df[validate,][[target]] %T>%
  {head(., 20) %>% print()}

va_risk <- df[validate,][[risk]] %T>%
  {head(., 20) %>% print()}
## [1] 9.8 0.0 0.0 0.0 0.0 0.0 0.0 0.6 0.8 0.0 1.6 0.0 0.2 0.0
## [15] 0.0 3.0 0.4 0.0 0.0 5.2

te_target <- df[test,][[target]] %T>%
  {head(., 20) %>% print()}
## [1] no no no no no no yes no no no yes yes no no
## [15] no no no no no yes

te_risk <- df[test,][[risk]] %T>%
  {head(., 20) %>% print()}

# modeling
# Train a decision tree model.
m_rp <- rpart(form, df[train, vars])

# Train a decision tree model.
m_rp <- rpart(form, df[train, vars])

# Basic model structure.
model
## n= 94343

summary(model)

ggVarImp(model, log=TRUE)

# Visualise the discovered knowledge.
fancyRpartPlot(model)

model %>%
  predict(newdata=df[train, vars], type="class") %>%
  set_names(NULL) %T>%
  {head(., 20) %>% print()} ->
  
  sum(tr_class == tr_target) %>%
  divide_by(length(tr_target)) %T>%
  {
    percent(.) %>%
      sprintf("Overall accuracy = %s\n", .) %>%
      cat()
  } ->
  tr_acc
## Overall accuracy=83%

sum(tr_class != tr_target) %>%
  divide_by(length(tr_target)) %T>%
  {
    percent(.) %>%
      sprintf("Overall error = %s\n", .) %>%
      cat()
  } ->
  tr_err
## Overall error=17%

table(tr_target, tr_class, dnn=c("Actual", "Predicted"))

table(tr_target, tr_class, dnn=c("Actual", "Predicted")) %>%
  divide_by(length(tr_target)) %>%
  multiply_by(100) %>%
  round(1)

errorMatrix(tr_target, tr_class, count=TRUE)

tr_matrix %>%
  diag() %>%
  sum(na.rm=TRUE) %>%
  subtract(100, .) %>%
  sprintf("Overall error percentage = %s%%\n", .) %>%
  cat()
## Overall error percentage=17%
tr_matrix[,"Error"] %>%
  mean(na.rm=TRUE) %>%
  sprintf("Averaged class error percentage = %s%%\n", .) %>%
  cat()

## random forest

# Train a random forest model.
m_rf <- randomForest(form,
                     data=df[train, vars],
                     na.action=na.roughfix,
                     importance=TRUE)

model <- m_rf
mtype <- "randomForest"
mdesc <- "random forest"
# Basic model structure.
model

# Review variable importance.
ggVarImp(model, log=TRUE)

model %>%
  predict(newdata=df[validate, vars], type="prob") %>%
  .[,2] %>%
  set_names(NULL) %>%
  round(2) %T>%
  {head(., 20) %>% print()} ->
  va_prob
## [1] 0.88 0.02 0.05 0.11 0.04 NA 0.04 NA NA NA NA
## [12] 0.09 NA 0.24 0.13 0.48 NA NA NA 0.23
model %>%
  predict(newdata=df[validate, vars], type="response") %>%
  set_names(NULL) %T>%
  {head(., 20) %>% print()} ->
  va_class

sum(va_class == va_target, na.rm=TRUE) %>%
  divide_by(va_class %>% is.na() %>% not() %>% sum()) %T>%
  {
    percent(.) %>%
      sprintf("Overall accuracy = %s\n", .) %>%
      cat()
  } ->
  va_acc
## Overall accuracy=86.7%
sum(va_class != va_target, na.rm=TRUE) %>%
  divide_by(va_class %>% is.na() %>% not() %>% sum()) %T>%
  {
    percent(.) %>%
      sprintf("Overall error = %s\n", .) %>%
      cat()
  } ->
  va_err

errorMatrix(va_target, va_class, count=TRUE)
## Predicted
## Actual no yes Error
## no 6185 300 4.6
## yes 795 933 46.0
# Comparison as percentages of all observations.
errorMatrix(va_target, va_class) %T>%
  print() ->
  va_matrix
## Predicted
## Actual no yes Error
## no 75.3 3.7 4.6
## yes 9.7 11.4 46.0
va_matrix %>%
  diag() %>%
  sum(na.rm=TRUE) %>%
  subtract(100, .) %>%
  sprintf("Overall error percentage = %s%%\n", .) %>%
  cat()
## Overall error percentage=13.3%
va_matrix[,"Error"] %>%
  mean(na.rm=TRUE) %>%
  sprintf("Averaged class error percentage = %s%%\n", .) %>%
  cat()
## Averaged class error percentage=25.3%
# AUC.
va_prob %>%
  prediction(va_target) %>%
  performance("auc") %>%
  attr("y.values") %>%
  .[[1]] %T>%
  {
    percent(.) %>%
      sprintf("Percentage area under the ROC curve = %s\n", .) %>%
      cat()
  } ->
  va_auc
## Percentage area under the ROC curve=90.1%
# Recall, precision, and F-score.
va_rec <- (va_matrix[2,2]/(va_matrix[2,2]+va_matrix[2,1])) %T>%
  {percent(.) %>% sprintf("Recall = %s\n", .) %>% cat()}
## Recall=54%
va_pre <- (va_matrix[2,2]/(va_matrix[2,2]+va_matrix[1,2])) %T>%
  {percent(.) %>% sprintf("Precision = %s\n", .) %>% cat()}
## Precision=75.5%
va_fsc <- ((2 * va_pre * va_rec)/(va_rec + va_pre)) %T>%
  {sprintf("F-Score = %.3f\n", .) %>% cat()}
## F-Score=0.630
# Rates for ROC curve.
va_prob %>%
  prediction(va_target) %>%
  performance("tpr", "fpr") %>%
  print() ->
  va_rates

# xgboost

formula(target %s+% "~ .-1") %>%
  sparse.model.matrix(data=df[vars] %>% na.roughfix()) %T>%
  {dim(.) %>% print()} %T>%
  {head(.) %>% print()} ->
  sdf

df[target] %>%
  unlist(use.names=FALSE) %>%
  equals("yes") %T>%
  {head(., 20) %>% print()} ->
  label

m_xg <- xgboost(data=sdf[train,],
                label=label[train],
                nroundf=100,
                print_every_n=15,
                objective="binary:logistic")

model <- m_xg
mtype <- "xgboost"
mdesc <- "extreme gradient boosting"
# Basic model information.
model

ggVarImp(model, feature_names=colnames(sdf), n=20)

# Predict on the validate dataset.
va_prob <- 
  model %>%
  predict(newdata=sdf[validate,]) %>%
  set_names(NULL) %>%
  round(2) %T>%
  {head(., 20) %>% print()}

## [1] 0.94 0.03 0.03 0.07 0.03 0.26 0.02 0.68 0.32 0.56 0.22
## [12] 0.06 0.02 0.16 0.11 0.56 0.20 0.06 0.06 0.22

va_prob %>%
  is_greater_than(0.5) %>%
  ifelse("yes", "no") %T>%
  {head(., 20) %>% print()} ->
  va_class

sum(va_class == va_target, na.rm=TRUE) %>%
  divide_by(va_class %>% is.na() %>% not() %>% sum()) %T>%
  {
    percent(.) %>%
      sprintf("Overall accuracy = %s\n", .) %>%
      cat()
  } ->
  va_acc
## Overall accuracy=85.3%
sum(va_class != va_target, na.rm=TRUE) %>%
  divide_by(va_class %>% is.na() %>% not() %>% sum()) %T>%
  {
    percent(.) %>%
      sprintf("Overall error = %s\n", .) %>%
      cat()
  } ->
  va_err
## Overall error=14.7%

# Count of prediction versus actual as a confusion matrix.
errorMatrix(va_target, va_class, count=TRUE)
## Predicted
## Actual no yes Error
## no 14846 894 5.7
## yes 2074 2402 46.3
# Comparison as percentages of all observations.
errorMatrix(va_target, va_class) %T>%
  print() ->
  va_matrix
## Predicted
## Actual no yes Error
## no 73.4 4.4 5.7
## yes 10.3 11.9 46.3
va_matrix %>%
  diag() %>%
  sum(na.rm=TRUE) %>%
  subtract(100, .) %>%
  sprintf("Overall error percentage = %s%%\n", .) %>%
  cat()
## Overall error percentage=14.7%
va_matrix[,"Error"] %>%
  mean(na.rm=TRUE) %>%
  sprintf("Averaged class error percentage = %s%%\n", .) %>%
  cat()
## Averaged class error percentage=26%


# AUC.
va_prob %>%
  prediction(va_target) %>%
  performance("auc") %>%
  attr("y.values") %>%
  .[[1]] %T>%
  {
    percent(.) %>%
      sprintf("Percentage area under the ROC curve = %s\n", .) %>%
      cat()
  } ->
  va_auc

## Percentage area under the ROC curve=88.2%
# Recall, precision, and F-score.
va_rec <- (va_matrix[2,2]/(va_matrix[2,2]+va_matrix[2,1])) %T>%
  {percent(.) %>% sprintf("Recall = %s\n", .) %>% cat()}

## Recall=53.6%
va_pre <- (va_matrix[2,2]/(va_matrix[2,2]+va_matrix[1,2])) %T>%
  {percent(.) %>% sprintf("Precision = %s\n", .) %>% cat()}

## Precision=73%
va_fsc <- ((2 * va_pre * va_rec)/(va_rec + va_pre)) %T>%
  {sprintf("F-Score = %.3f\n", .) %>% cat()}

## F-Score=0.618
# Rates for ROC curve.
va_prob %>%
  prediction(va_target) %>%
  performance("tpr", "fpr") %>%
  print() ->
  va_rates

## An object of class "performance"
## Slot "x.name":
## [1] "False positive rate"
##
## Slot "y.name":
## [1] "True positive rate"
....