bank_new_y <- filter(bank_new, y == "y")
bank_new_n <- filter(bank_new, y == "n")

idx_n <- sample(1:nrow(bank_new_n), nrow(bank_new) * 0.1 / 2)
idx_y <- sample(1:nrow(bank_new_y), nrow(bank_new) * 0.1 / 2)

train_special <- bind_rows(bank_new_n[idx_n,], bank_new_y[idx_y,])

log_fit <- train(y ~ .,
                 data = train_special,
                 method = "glm",
                 family = binomial,
                 trControl = train_control)

# Worse result from special training
predictions <- predict(log_fit, newdata = train_special)
confusionMatrix(predictions, train_special$y)

predictions <- predict(log_fit, newdata = bank_train)
confusionMatrix(predictions, bank_train$y)
