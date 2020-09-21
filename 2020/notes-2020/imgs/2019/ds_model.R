vv <- load(file = "E:/Dropbox/Docs/MFE/FE8828/2019/notes-2019/imgs/2019/data_model.Rda")
vv

df_sel <- df_omit

# Preparing for data modeling

form <- df[vars] %>%
  formula() %>%
  print()
form

seed <- 42
set.seed(seed)

nobs <- 10000
df   <- df_sel[sample(nobs),]

train <- nobs %>% sample(0.70*nobs)
validate <- nobs %>% seq_len() %>% setdiff(train) %>% sample(0.15*nobs)
test <- nobs %>% seq_len() %>% setdiff(union(train, validate))
  
# Cache the various actual values for target and risk.
tr_target <- df[train,][[target]]
tr_risk <- df[train,][[risk]]
va_target <- df[validate,][[target]] 
va_risk <- df[validate,][[risk]]

te_target <- df[test,][[target]]
te_risk <- df[test,][[risk]]

library(rpart)        # Model: decision tree.

# modeling
# Train a decision tree model.
m_rp <- rpart(form, df[train, vars])

# Basic model structure.
m_rp
## n= 94343

summary(m_rp)

ggVarImp(m_rp, log=TRUE)

# Visualise the discovered knowledge.
fancyRpartPlot(m_rp)

m_rp %>%
  predict(newdata=df[train, vars], type="class") %>%
  set_names(NULL) %T>%
  {head(., 20) %>% print()} -> tr_class

tr_acc <- sum(tr_class == tr_target) %>%
  divide_by(length(tr_target))
tr_acc
## Overall accuracy=83%

tr_err <- sum(tr_class != tr_target) %>%
  divide_by(length(tr_target))
tr_err  

## Overall error=17%

table(tr_target, tr_class, dnn=c("Actual", "Predicted"))

table(tr_target, tr_class, dnn=c("Actual", "Predicted")) %>%
  divide_by(length(tr_target)) %>%
  multiply_by(100) %>%
  round(1)

### here

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