# bank/age/job

group_by(bank, age, job) %>%
  summarise(cc = n()) %>%
  ungroup() %>%
{
  ggplot(.) +
    geom_point(aes(age, job, size = cc)) +
    scale_y_discrete(limit = rev(levels(bank$job)))
}

ggplot(bank, aes(age, job)) +
  geom_point() +
  scale_y_discrete(limit = rev(levels(bank$job)))

ggplot(bank, aes(job, age)) +
  geom_violin() + coord_flip() +
  scale_x_discrete(limit = rev(levels(bank$job)))

