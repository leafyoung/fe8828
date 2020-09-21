# 3-ex-2.R

bank_summary <- function(df) {
  df %>%
    group_by(job, education) %>%
      summarise(age_mean = mean(age), balance_mean = mean(balance)) %>%
      ungroup() %>% # after ungroup, job and education are "unlocked" to be converted to character
        mutate_if(is.factor, as.character)
}

df_1 <- bank %>%
  bank_summary()

df_2 <- bank %>%
  mutate(education = "+") %>% 
  bank_summary()

df_3 <- bank %>%
  mutate(education = "+", job = "+") %>%
  bank_summary()

bind_rows(df_1, df_2, df_3)
