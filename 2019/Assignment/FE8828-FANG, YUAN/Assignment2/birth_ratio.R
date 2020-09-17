library(purrr)
library(lattice)

birth_ratio <- function(N) {
  ## 1 if new-born was a boy and 0 if new-born was a girl
  sex <- sample(0:1, N, replace = TRUE)
  k = length(which(sex == 0))
  n_girl = k
  n_boy = N - k
  while (k != 0){
    sex <- sample(0:1, k, replace = TRUE)
    k_new = length(which(sex == 0));
    n_boy <- n_boy + k - k_new;
    n_girl <- n_girl + k_new;
    k = k_new
  }
  return(n_girl/(n_girl + n_boy))
}

mean(as.numeric(purrr::map(rep(10,5000), birth_ratio)))
histogram(as.numeric(purrr::map(rep(10,5000), birth_ratio)), xlab = 'Ratio: number of girls / number of boys', n = 20)
