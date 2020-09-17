df <- data.frame(a=1:10, b= 10:1)
# Structure
str(df)
# Select
df[which(df$a == 3 | df$b ==3),,drop = T]
df[match(3,df$a), ,drop = T]
df[,match("b",colnames(df)),drop = T]
# Insert
rbind(df,df)
# Delete
df[-which(df$a == 3 | df$b ==3),,drop = T]
# Update
df[which(df$a == 3 | df$b ==3),2]<-3

bank <- read.csv("https://goo.gl/PBQnBt", sep = ";")
save("bank",file = "/Users/violetqu97/Desktop/NTU/bank.Rda")
load(file = "/Users/violetqu97/Desktop/NTU/bank.Rda")

library(dplyr)
# All distinct values
distinct(bank, job, education)

# Select - by columns
subset <- select(bank, marital)
subset <- select(bank, 1)
subset <- select(bank, -1)
subset <- select(bank, -job)
subset <- select(bank, -(job:education))
subset <- select(bank, starts_with("p"))
subset <- select(bank, ends_with("p"))
subset <- select(bank, contains("p"))
job_first <- select(bank, job, everything()) # 调整列的顺序

# Filter - by rows
young <- dplyr::filter(bank, age < 40)
another_young <- dplyr::filter(bank, age < 20 & marital == "married")
just_young <- dplyr::filter(bank, age < 20 & marital == "single")
young2 <- dplyr::filter(bank, age >= 20 & age < 30)
another_young2 <- dplyr::filter(bank, age >= 20 & age < 30 & marital ==
                                  "married")
just_young2 <- dplyr::filter(bank, age >= 20 & age < 30 & marital == "single")
  # %in% to match multiple
second_upper <- dplyr::filter(bank, education %in% c("tertiary", "secondary"))
  # filter out NA value.
no_na <- dplyr::filter(bank, !is.na(balance) & balance > 0)

# rename(new name = old)
df <- rename(bank, young_age = age)
df <- rename(bank, `Age in Bank` = age)

# arrange
arrange(bank, job)
arrange(bank, default, job)
  # descending
arrange(bank, desc(day))
arrange(bank, desc(as.Date(day, format="%d", origin = Sys.Date())))
  # all missing values to the start
duration <- arrange(bank, !is.na(duration))

# Mutate
# +, -, *, /: ordinary arithmetic operator
# %/% (integer division) and %% (remainder), where x == y * (x %/% y) + (x %% y)
# x / sum(x): compute the proportion of all things
# y - mean(y): computes the difference from the mean.
# log2(), log(), log10():
# lead(), lag(): compute running differences (e.g. x - lag(x)) or find when values change (x !=lag(x)
# rolling sum, prod, min, max: cumsum(), cumprod(), cummin(), cummax(); and dplyr provides cummean()
# row_number()/min_rank()/ntile(,n)
  # ifelse is to check condition.
df1 <- mutate(bank, y = ifelse(y == "yes", T, F))
  # Add a new column.
df2 <- mutate(bank, duration_diff = duration - mean(duration, na.rm = TRUE))
  # case_when is a function to deal multiple choices.
df2_age_group <- mutate(bank, age_group = case_when(
  age < 20 ~ "youth",
  age < 40 ~ "middle-age",
  age < 50 ~ "senior",
  TRUE ~ "happy"
))

# transmute: remove all other columns after mutation, only keeping the new variable.
df5 <- transmute(bank,
                 duration_trend = duration - mean(duration, na.rm = TRUE),
                 balance_trend = balance - mean(balance, na.rm = TRUE))
df2_age_group_res <-
  group_by(df2_age_group, age_group) %>%
  summarise(mean_age = mean(age)) %>%
  transmute(mean_age_diff = mean_age - lag(mean_age))

# Pipe %>%
x %>% first(.) %>% second(.) %>% third(.) # . represents the input
c(1, 3, 7, 9) %>% {
  print(.)
  mean(.)
} %>% { . * 3 } %>% {
  print(.)
  sample(round(., 0))
} #每层的最后输出结果作为下一层的输入

# Environment
  # local() to isolate
x <- 3
local({
  print(x)
  x <- 1
  print(x)
})
x
  # assign data to global environment
x <- 1
pass_out_global <- function() {
  assign("x", 3, envir = .GlobalEnv)
}

# Join 哪个为base哪个就在前面
data_day1 <- data.frame(a=1:10, b= 10:1)
data_day2 <- data.frame(a=8:12, c= 6:2)
anti_join(data_day2, data_day1, by = "a") # in day2 but not in day1
inner_join(data_day2, data_day1, by = "a") # all combinations 
left_join(data_day1, data_day2, by = "a")  
right_join(data_day1, data_day2, by = "a")
left_join(data_day2, data_day1, by = "a") 

# Group_by/Summarize
# Group_by
  # mutate + group_by
df <- group_by(data.frame(a = 1:10), quantile = ntile(a, 2)) %>%
  mutate(b = a / sum(a))
  # filter + group_by
df <- group_by(bank, age) %>% filter(balance == max(balance))
# Summarise
df <- data.frame(a = c(1, 3, 4, NA))
summarise(df, total = sum(a, na.rm = TRUE)) # Add paramter na.rm, if there is NA among the data.
df <- summarise(bank,
                with_housing = sum(housing == "yes") / n(),
                age_min = min(age),
                duration_mean = mean(duration))
  # condition
df1 <- summarise_if(bank, is.numeric, mean)
# summarise + group_by
  # condition
d1 <- group_by(bank, job) %>%
  summarise(`balance > 500` = sum(balance > 500))
  # Example 1
bank_age <- group_by(bank, age) %>%
  summarise(balance_mean = mean(balance),
            count = n(), # number in each group
            default_count = sum(ifelse(default == "no", 0, 1)))
  # Example 2
df <- bank %>% # Find the maximum and minimum balance on each age.
  group_by(age) %>%
  filter(min_rank(balance) == 1 | min_rank(desc(balance)) == 1) %>%
  arrange(age, balance)
# ungroup
  # removes group definition
df_correct <- group_by(bank, age) %>%
  filter(balance == max(balance)) %>%
  ungroup %>%
  summarize(balance = mean(balance))
  # cannot remove age without ungroup
df2 <- group_by(bank, age) %>%
  filter(balance == max(balance)) %>%
  ungroup %>%
  select(-age) %>% head(n = 3)
# Rowwise:  every one row a group
df <- data.frame(throw_dices = 1:10)
df <- rowwise(df) %>% mutate( mean = mean(sample(1:6, throw_dices,replace = TRUE)))

# Combine
  # bind_rows
df <- arrange(bank, age) %>%
  { bind_rows(head(., n = 5), tail(., n = 5)) }
  # bind_cols =  left_join/select
dt1 <- bind_cols(select(bank, job), select(bank, education))
    # Example 1
d1 <- filter(bank, month == "sep") %>%
  summarize(duration = mean(duration)) %>%
  rename(`Duration Sep` = duration)
d2 <- filter(bank, month == "oct") %>%
  summarize(duration = mean(duration)) %>%
  rename(`Duration Oct` = duration)
d3 <- filter(bank, month == "nov") %>%
  summarize(duration = mean(duration)) %>%
  rename(`Duration Nov` = duration)
df <- bind_cols(d1, d2, d3)

# Wide <=> Long
library(tidyr)
  # Wide => Long 
    # gather(data,new_key_col_name,new_value_col_name,-columns_to_be_included_in_the_left)
wfmt <- group_by(bank, job) %>% summarize(yy = sum(ifelse(default =="yes", 1, 0)), nn = sum(ifelse(default == "no", 1, 0)))
df <- gather(wfmt, default, value, -job) %>% arrange(job, default)
    # 
  # Wide <= Long
  # spread(data, colname_to_be_header, value_to_be_filled_under_header)
lfmt <- group_by(bank, job, default) %>% summarize(nn = n())
df <- spread(lfmt, default, nn) # first column keeps the same
  # gather + spread
wfmt <- tibble(date = seq(from = as.Date("2019-01-01"), by = "day",
                              length.out = 5),
                   Copper_qty = round(runif(5) * 1000, 0),
                   Gold_qty = round(runif(5) * 1000, 0),
                   Silver_qty = round(runif(5) * 1000, 0))
df <- wfmt %>%
  gather(key, value, -date) %>%
  group_by(date) %>%
  summarize(value1 = sum(value)) %>%
  rename(value = value1) %>%
  mutate(key = "Total") %>%
  spread(key = key, value = value) %>%
  inner_join(wfmt, ., by = "date")

# unit: n columns -> 1 columns
df <- expand_grid(x = c("a", NA), y = c("b", NA)) # Create a tibble from all combinations of inputs
df %>% unite("z", x:y, remove = FALSE) # default sep is "_"
df %>% unite("z", x:y, na.rm = TRUE, remove = FALSE) # To remove missing values:
# seperate: n columns <- 1 columns
df <- data.frame(x = c(NA, "a.b", "a.d", "b.c"))
df %>% separate(x, c("A", "B"))
df %>% separate(x, c(NA, "B")) # only the second variable
  # different number of pieces -> extra and fill arguments 
df <- data.frame(x = c("a", "a b", "a b c", NA))
df %>% separate(x, c("a", "b")) # drops the c and warnings
df %>% separate(x, c("a", "b"), extra = "drop", fill = "right") # drops the c but no warnings
df %>% separate(x, c("a", "b"), extra = "merge", fill = "left") # split specified number

# convert = TRUE detects column classes
df <- data.frame(x = c("a:1", "a:2", "c:4", "d", NA))
df %>% separate(x, c("key","value"), ":") %>% str
df %>% separate(x, c("key","value"), ":", convert = TRUE)

# Argument col can take quasiquotation to work with strings
var <- "x"
df %>% separate(!!var, c("key","value"), ":")



# Exercise 2
answer1 <- dplyr::filter(bank,loan == "yes" & housing== "no")
answer2 <- dplyr::filter(bank,job != "unemployed" & age>=20 & age<=40)
unique(dplyr::select(bank,job))