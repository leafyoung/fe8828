fish_list <- sample(1:9, 9, replace = FALSE)
cat(paste0(paste0(fish_list, collapse = ", ")), "\n")

mx <- -1
for (nn in 2:9) {
  if (mx < fish_list[nn - 1]) {
    mx <- fish_list[nn - 1]
  }
  if (mx > fish_list[nn]) {
    fish_list[nn] <- 0
  }
}
fish_list
cat(paste0(paste0(fish_list, collapse = ", ")), "\n")
