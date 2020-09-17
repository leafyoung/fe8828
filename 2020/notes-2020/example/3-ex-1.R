# 3-ex-1.R

df %>%
  mutate(try_date = as.Date(dt), nn = row_number()) %>%
  filter(is.na(try_date)) %>%
  .$nn %>%
  {
    cat(paste0("Wrong date in row ", paste0(., collapse = ","), "\n"))
  }