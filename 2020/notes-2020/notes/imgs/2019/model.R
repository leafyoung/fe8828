# Welcome to the Togaware Data Science Model Template ----
#
# Australian Weather Dataset.
# General Model Setup.
#
# File: 60_model.R
#
# This template provides a starting point for the 
# data scientist build analytic models. By no means
# is it the end point of the data science journey.
#
# This R script is automatically extracted from a knitr
# file with a .Rnw extension. That file includes a broader 
# narrative and explanation of the journey through our data.
# Before our own journey into literate programming we can
# make use of these R scripts as our templates for data science.
# 
# The template is under regular revision and improvement
# and is provided as is. It is published as an appendix to the 
# book, Quick Start Data Science in R from CRC Press (pending).
#
# Copyright (c) 2014-2016 Togaware.com
# Authored by and feedback to Graham.Williams@togaware.com
# License: Creative Commons Attribution-ShareAlike CC BY-SA 
#
# Version: 20161016T072816

#### MODEL SETUP ------------------------------------

# Load required packages from local library into R.

library(stringi)      # String operator: %s+%.
library(magrittr)     # Data pipelines: %>% %T>% %<>%.
library(rattle)       # Evaluate: riskchart(), rocChart() errorMatrix().
library(ROCR)         # Evaluate: prediction() performance().

# Useful utility functions.

echo <- function(x, big.mark=",", ...)
{
  format(x, big.mark=big.mark, ...) %>% cat("\n")
}

#### DATA INGESTION ------------------------------------

# Identify the dataset.

dsname <- "weatherAUS"

# Identify the dataset to load.

fpath  <- "data"
dsdate <- "_" %s+% "20170720"

# Filename of the saved dataset.

dsrdata <-
  file.path(fpath, dsname %s+% dsdate %s+% ".RData") %T>% 
  print()

# Load the R objects from file and list them.

load(dsrdata) %>% print()

# Review the metadata.

dsname
dspath
dsdate
nobs %>% echo()
vars
target
risk
id
ignore
omit

# TEMPORARY SMALLER DATASET FOR DEVELOPMENT

nobs <- 10000
ds   <- ds[sample(nobs),]

#### PREPARE FOR MODELLING ------------------------------------

# Formula for modelling.

form <- ds[vars] %>% formula() %T>% print()

# Initialise random numbers for repeatable results.

seed <- 123
set.seed(seed)

# Partition the full dataset into three: train, validate, test.

nobs %>%
  sample(0.70*nobs) %T>% 
  {length(.) %>% print()} ->
train

head(train)

nobs %>%
  seq_len() %>% 
  setdiff(train) %>% 
  sample(0.15*nobs) %T>%
  {length(.) %>% print()} ->
validate

head(validate)

nobs %>%
  seq_len() %>%
  setdiff(union(train, validate)) %T>%
  {length(.) %>% print()} ->
test

head(test)

# Note the class of the dataset.

class(ds)

# Actual values for target and risk variables for evaluation.

tr.target <- ds[train,][[target]]    %T>% {head(., 20) %>% print()}
tr.risk   <- ds[train,][[risk]]      %T>% {head(., 20) %>% print()}

va.target <- ds[validate,][[target]] %T>% {head(., 20) %>% print()}
va.risk   <- ds[validate,][[risk]]   %T>% {head(., 20) %>% print()}

te.target <- ds[test,][[target]]     %T>% {head(., 20) %>% print()}
te.risk   <- ds[test,][[risk]]       %T>% {head(., 20) %>% print()}

# Welcome to the Togaware Data Science Model Template.
#
# Australian Weather Dataset.
# Decision Tree Classification.
#
# File: 62_rpart.R
#
# This template provides a starting point for the 
# data scientist build analytic models. By no means
# is it the end point of the data science journey.
#
# This R script is automatically extracted from a knitr
# file with a .Rnw extension. That file includes a broader 
# narrative and explanation of the journey through our data.
# Before our own journey into literate programming we can
# make use of these R scripts as our templates for data science.
# 
# The template is under regular revision and improvement
# and is provided as is. It is published as an appendix to the 
# book, Quick Start Data Science in R from CRC Press (pending).
#
# Copyright (c) 2014-2016 Togaware.com
# Authored by and feedback to Graham.Williams@togaware.com
# License: Creative Commons Attribution-ShareAlike CC BY-SA 
#
# Version: 20161016T072816

#### DECISION TREE ------------------------------------

library(rpart)        # Model: decision tree.

## Build Model on Training Dataset ------------------

# Splitting function: "anova" "poisson" "class" "exp"

mthd <- "class"

# Splitting function parameters.

prms <- list(split="information"   # "information" "gini" 
         # , prior=c(0.5, 0.5)     # Sum to 1.
         # , loss=matrix(c(0,10,1,0), byrow=TRUE, nrow=2)
             )

# Control the training.

ctrl <- rpart.control(maxdepth=3	# 30
                  # , minsplit=20	# 20
                  # , minbucket=7	# minsplit/3
                  # , cp=0.01		# Complexity 0.01
                  # , maxcompete=4	# 4
                  # , maxsurrogate=5    # 5
                  # , usesurrogate=2	# 2
                  # , xval=10		# 10
                  # , surrogatestyle=0	# 0
                      )

m.rp <- rpart(form, ds[train, vars], method=mthd, parms=prms, control=ctrl)

model  <- m.rp
m.type <- "rpart"
m.desc <- "Decision Tree"

# Basic model summary.

model

summary(model)

# Visually expose the discovered knowledge.

ggVarImp(model)

fancyRpartPlot(model)

## Evaluate Model on Validation Dataset ------------------

model %>%
  predict(newdata=ds[validate, vars], type="class") %T>%
  {head(., 20) %>% print()} ->
va.class

model %>% # Assumes 2 class
  predict(newdata=ds[validate, vars])[,2] %T>%
  {head(., 20) %>% print()} ->
va.prob

# Basic confusion matrix.

table(va.target, va.class, useNA="ifany", dnn=c("Actual", "Predicted"))

# Compute basic performance information on validation dataset.

per  <- errorMatrix(va.target, va.class)
pred <- prediction(va.prob, va.target)

# Basic performance.

sprintf("Overall accuracy percentage = %s%%\n",
        100*round(sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Overall error percentage = %s%%\n",
        100*round(1-sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Averaged class error percentage = %s%%\n",
        100*round(mean(per[,"Error"], na.rm=TRUE), 2)) %>% cat()

sprintf("Area under the curve = %s%%\n",
        100*round(attr(performance(pred, "auc"), "y.values")[[1]], 2)) %>% cat()

# Display the error matrix.

round(100*per, 0)

# Visual evaluation.

riskchart(va.prob,
          va.target,
          va.risk, 
          title="Risk Chart " %s+% m.desc %s+% " Test Dataset",
          risk.name=risk, recall.name=target,
          show.lift=TRUE, show.precision=TRUE, legend.horiz=FALSE)

rocChart(va.prob, va.target)

## Tune Model on Training Dataset ------------------

# Splitting function: "anova" "poisson" "class" "exp"

mthd <- "class"

# Splitting function parameters.

prms <- list(split="information"   # "information" "gini" 
         # , prior=c(0.5, 0.5)     # Sum to 1.
         # , loss=matrix(c(0,10,1,0), byrow=TRUE, nrow=2)
             )

# Control the training.

ctrl <- rpart.control(maxdepth=30	# 30
                    , minsplit=9	# 20
                  # , minbucket=7	# minsplit/3
                    , cp=0.001		# Complexity 0.01
                  # , maxcompete=4	# 4
                  # , maxsurrogate=5    # 5
                  # , usesurrogate=2	# 2
                  # , xval=10		# 10
                  # , surrogatestyle=0	# 0
                      )

m.rp <- rpart(form, ds[train, vars], method=mthd, parms=prms, control=ctrl)

model  <- m.rp
m.type <- "rpart"
m.desc <- "Decision Tree"

# Basic model summary.

model

summary(model)

# Visually expose the discovered knowledge.

ggVarImp(model)

fancyRpartPlot(model)

## Evaluate Model on Validation Dataset ------------------

model %>%
  predict(newdata=ds[validate, vars], type="class") %T>%
  {head(., 20) %>% print()} ->
va.class

model %>%  # Assumes 2 class
  predict(newdata=ds[validate, vars])[,2] %T>%
  {head(., 20) %>% print()} ->
va.prob

# Basic confusion matrix.

table(va.target, va.class, useNA="ifany", dnn=c("Actual", "Predicted"))

# Compute basic performance information on validation dataset.

per <- errorMatrix(va.target, va.class)

# Basic performance.

sprintf("Overall accuracy percentage = %s%%\n",
        100*round(sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Overall error percentage = %s%%\n",
        100*round(1-sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Averaged class error percentage = %s%%\n",
        100*round(mean(per[,"Error"], na.rm=TRUE), 2)) %>% cat()

sprintf("Area under the curve = %s%%\n",
        100*round(attr(performance(pred, "auc"), "y.values")[[1]], 2)) %>% cat()

# Display the error matrix.

round(100*per, 0)

# Visual evaluation.

riskchart(va.prob,
          va.target,
          va.risk, 
          title="Risk Chart " %s+% m.desc %s+% " Validation Dataset",
          risk.name=risk, recall.name=target,
          show.lift=TRUE, show.precision=TRUE, legend.horiz=FALSE)

rocChart(va.prob, va.target)

## Final Evaluation on Test Dataset ------------------

model %>%
  predict(newdata=ds[test, vars], type="class") %T>%
  {head(., 20) %>% print()} ->
te.class

model %>%  # Assumes 2 class
  predict(newdata=ds[test, vars])[,2] %T>%
  {head(., 20) %>% print()} ->
te.prob

# Basic confusion matrix.

table(te.target, te.class, useNA="ifany", dnn=c("Actual", "Predicted"))

# Compute basic performance information on test dataset.

per  <- errorMatrix(te.target, te.class)
pred <- prediction(va.prob, va.target)

# Basic performance.

sprintf("Overall accuracy percentage = %s%%\n",
        100*round(sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Overall error percentage = %s%%\n",
        100*round(1-sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Averaged class error percentage = %s%%\n",
        100*round(mean(per[,"Error"], na.rm=TRUE), 2)) %>% cat()

sprintf("Area under the curve = %s%%\n",
        100*round(attr(performance(pred, "auc"), "y.values")[[1]], 2)) %>% cat()

# Display the error matrix.

round(100*per, 0)

# Visual evaluation.

riskchart(te.prob,
          te.target,
          te.risk, 
          title="Risk Chart " %s+% m.desc %s+% " Test Dataset",
          risk.name=risk, recall.name=target,
          show.lift=TRUE, show.precision=TRUE, legend.horiz=FALSE)

rocChart(te.prob, te.target)

# Welcome to the Togaware Data Science Model Template.
#
# Australian Weather Dataset.
# Random Forest Classification.
#
# File: 64_randomForest.R
#
# This template provides a starting point for the 
# data scientist build analytic models. By no means
# is it the end point of the data science journey.
#
# This R script is automatically extracted from a knitr
# file with a .Rnw extension. That file includes a broader 
# narrative and explanation of the journey through our data.
# Before our own journey into literate programming we can
# make use of these R scripts as our templates for data science.
# 
# The template is under regular revision and improvement
# and is provided as is. It is published as an appendix to the 
# book, Quick Start Data Science in R from CRC Press (pending).
#
# Copyright (c) 2014-2016 Togaware.com
# Authored by and feedback to Graham.Williams@togaware.com
# License: Creative Commons Attribution-ShareAlike CC BY-SA 
#
# Version: 20161016T072816

#### RANDOM FOREST ------------------------------------

library(randomForest) # Model: randomForest() na.roughfix().

## Build Model on Training Dataset ------------------

m.rf <- randomForest(form
                   , ds[train, vars]
                   , ntree=50			# 500
                 # , mtry=4			# sqrt(nvars)
                   , importance=TRUE		# FALSE
                   , na.action=na.roughfix	# na.fail()
                   , replace=FALSE		# TRUE
                     )
  
model  <- m.rf
m.type <- "randomForest"
m.desc <- "Random Forest"

# Basic model summary.

model

importance(model)

# Visually expose the discovered knowledge.

ggVarImp(model)

## Evaluate Model on Validation Dataset ------------------

model %>%
  predict(newdata=ds[validate, vars], type="class") %T>%
  {head(., 20) %>% print()} ->
va.class

model %>% # Assumes 2 class
  predict(newdata=ds[validate, vars], type="prob")[,2] %T>%
  {head(., 20) %>% print()} ->
va.prob

# Basic confusion matrix.

table(va.target, va.class, useNA="ifany", dnn=c("Actual", "Predicted"))

# Compute basic performance information on validation dataset.

per  <- errorMatrix(va.target, va.class)
pred <- prediction(va.prob, va.target)

# Basic performance.

sprintf("Overall accuracy percentage = %s%%\n",
        100*round(sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Overall error percentage = %s%%\n",
        100*round(1-sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Averaged class error percentage = %s%%\n",
        100*round(mean(per[,"Error"], na.rm=TRUE), 2)) %>% cat()

sprintf("Area under the curve = %s%%\n",
        100*round(attr(performance(pred, "auc"), "y.values")[[1]], 2)) %>% cat()

# Display the error matrix.

round(100*per, 0)

# Visual evaluation.

riskchart(va.prob,
          va.target,
          va.risk, 
          title="Risk Chart " %s+% m.desc %s+% " Validation Dataset",
          risk.name=risk, recall.name=target,
          show.lift=TRUE, show.precision=TRUE, legend.horiz=FALSE)

rocChart(va.prob, va.target)

## Tune Model on Training Dataset ------------------

# Splitting function: "anova" "poisson" "class" "exp"

mthd <- "class"

# Splitting function parameters.

prms <- list(split="information"   # "information" "gini" 
         # , prior=c(0.5, 0.5)     # Sum to 1.
         # , loss=matrix(c(0,10,1,0), byrow=TRUE, nrow=2)
             )

# Control the training.

ctrl <- rpart.control(maxdepth=30	# 30
                    , minsplit=9	# 20
                  # , minbucket=7	# minsplit/3
                    , cp=0.001		# Complexity 0.01
                  # , maxcompete=4	# 4
                  # , maxsurrogate=5    # 5
                  # , usesurrogate=2	# 2
                  # , xval=10		# 10
                  # , surrogatestyle=0	# 0
                      )

m.rp <- rpart(form, ds[train, vars], method=mthd, parms=prms, control=ctrl)

model <- m.rp
m.type <- "rpart"
m.desc <- "Decision Tree"

# Basic model summary.

model

# Visually expose the discovered knowledge.

fancyRpartPlot(model)

## Evaluate Model on Validation Dataset ------------------

va.class <- 
  predict(model, newdata=ds[validate, vars], type="class") %T>%
  {head(., 20) %>% print()}

va.prob  <- # Assumes 2 class
  predict(model, newdata=ds[validate, vars])[,2] %T>%
  {head(., 20) %>% print()}

# Basic confusion matrix.

table(va.target, va.class, useNA="ifany", dnn=c("Actual", "Predicted"))

# Compute basic performance information on validation dataset.

per  <- errorMatrix(va.target, va.class)
pred <- prediction(va.prob, va.target)

# Basic performance.

sprintf("Overall accuracy percentage = %s%%\n",
        100*round(sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Overall error percentage = %s%%\n",
        100*round(1-sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Averaged class error percentage = %s%%\n",
        100*round(mean(per[,"Error"], na.rm=TRUE), 2)) %>% cat()

sprintf("Area under the curve = %s%%\n",
        100*round(attr(performance(pred, "auc"), "y.values")[[1]], 2)) %>% cat()

# Display the error matrix.

round(100*per, 0)

# Visual evaluation.

riskchart(va.prob,
          va.target,
          va.risk, 
          title="Risk Chart " %s+% m.desc %s+% " Validation Dataset",
          risk.name=risk, recall.name=target,
          show.lift=TRUE, show.precision=TRUE, legend.horiz=FALSE)

rocChart(va.prob, va.target)

## Final Evaluation on Test Dataset ------------------

te.class <- 
  predict(model, newdata=ds[test, vars], type="class") %T>%
  {head(., 20) %>% print()}

te.prob  <- # Assumes 2 class
  predict(model, newdata=ds[test, vars])[,2] %T>%
  {head(., 20) %>% print()}

# Basic confusion matrix.

table(te.target, te.class, useNA="ifany", dnn=c("Actual", "Predicted"))

# Compute basic performance information on test dataset.

per  <- errorMatrix(te.target, te.class)
pred <- prediction(va.prob, va.target)

# Basic performance.

sprintf("Overall accuracy percentage = %s%%\n",
        100*round(sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Overall error percentage = %s%%\n",
        100*round(1-sum(diag(per), na.rm=TRUE), 2)) %>% cat()

sprintf("Averaged class error percentage = %s%%\n",
        100*round(mean(per[,"Error"], na.rm=TRUE), 2)) %>% cat()

sprintf("Area under the curve = %s%%\n",
        100*round(attr(performance(pred, "auc"), "y.values")[[1]], 2)) %>% cat()

# Display the error matrix.

round(100*per, 0)

# Visual evaluation.

riskchart(te.prob,
          te.target,
          te.risk, 
          title="Risk Chart " %s+% m.desc %s+% " Test Dataset",
          risk.name=risk, recall.name=target,
          show.lift=TRUE, show.precision=TRUE, legend.horiz=FALSE)

rocChart(te.prob, te.target)

# Welcome to the Togaware Data Science Model Template.
#
# Australian Weather Dataset.
# Mixed Effects Regression Model.
#
# File: 72_lmer.R
#
# This template provides a starting point for the 
# data scientist build analytic models. By no means
# is it the end point of the data science journey.
#
# This R script is automatically extracted from a knitr
# file with a .Rnw extension. That file includes a broader 
# narrative and explanation of the journey through our data.
# Before our own journey into literate programming we can
# make use of these R scripts as our templates for data science.
# 
# The template is under regular revision and improvement
# and is provided as is. It is published as an appendix to the 
# book, Quick Start Data Science in R from CRC Press (pending).
#
# Copyright (c) 2014-2016 Togaware.com
# Authored by and feedback to Graham.Williams@togaware.com
# License: Creative Commons Attribution-ShareAlike CC BY-SA 
#
# Version: 20161016T072816

#### MIXED EFFECTS REGRESSION MODEL ------------------------------------

library(lme4) # Model: lme().

# Predict amount of rain tomorrow so it is a different formula.

rvars   <- id
reffect <- "(1|" %s+% rvars[1] %s+% ")+(1|" %s+% rvars[2] %s+% ")"
fvars   <- setdiff(vars, target) %T>% print()
feffect <- paste(fvars, collapse="+")
form    <- formula(risk %s+% "~" %s+% reffect %s+% "+" %s+% feffect) %T>% print()

## Build Model on Training Dataset ------------------

m.lmer <- lmer(form
             , ds[train, c(inputs, id, risk)]
               )
  
model <- m.lmer
m.type <- "lmer"
m.desc <- "Linear Mixed Effect Model"

# Basic model summary.

model

#### DIAGONOSE MODEL ------------------------------------

# Draw residual plot.

m.res <- resid(model)
m.fit <- fitted(model)
plot(m.res ~ m.fit)

# Calculate R-square.

cor(m.fit, model@frame$scale_score)^2

# Compare impact of effects.

summary(model, cor=FALSE)

## Forecast ------------------

# We define the function that we will use for forecasting.

lmeForecast <- function(model, data) 
{
  # Variables in the functions: student_id, school_code, test_year,
  # test_year_level, scale_score.  i.e., id, target, test_year_level.
  
  require(dplyr)
  require(lme4)
  
  data %<>%
    arrange(student_id, test_year_level) %>%
    group_by(student_id) %>%
    filter(row_number() == n(),         # Keep final test result for each student
           test_year_level != "9") %>%  # only if student is not already in year 9.
    do({
      yearLevel <- as.numeric(as.character(.$test_year_level))[1]
      year <- as.numeric(as.character(.$test_year))
      newRows <- (9 - yearLevel)/2 + 1
      out <- .[rep(1, newRows), ]
      yearLevel <- seq(yearLevel, to=9, by=2)
      out$test_year <- year + yearLevel - yearLevel[1]
      out$test_year_level <- factor(yearLevel, levels=c(3, 5, 7, 9))
      out
    })
  dim
  
  # Get predicted scores without student effect.
  
  data <- tibble(data,
                     pred=predict(model, data, allow.new.levels=TRUE, re.form=~(1|school_code)))
  
  # adjust predicted scores based on most recent test result, keep only forecasted rows
  
  left_join(data,
            data %>%
              group_by(student_id) %>%
              summarise(adj=(scale_score - pred)[1], n=n()),
            by="student_id") %>%
    mutate(predictedScore=pred + adj, scale_score=NA) %>%
    group_by(student_id) %>%
    select(-pred, -adj, -n) %>%
    filter(row_number() != 1)
}

# Select observations in specific corhort.

testcohort <- subset(ds, school_code == "556")

# Forecast for the data in the corhort.

testcohort.fcast <- lmeForecast(model, testcohort)

# Review forecasting result.

head(testcohort.fcast)

tail(testcohort.fcast)

summary(testcohort.fcast)

# NOTE: scale_score are all equal to NA?

