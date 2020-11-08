# Secretary Problem
# WU Hongsheng G2000655A

make_choice <- function(N, split_number){
  input_list <- sample(1:N, replace = FALSE)
  eval_group <- input_list[1:split_number]
  sel_group <- input_list[split_number+1:N]
  sel_group <- na.omit(sel_group)
  best_eval <- max(eval_group)
  target <- best_eval
  #print(eval_group)
  #print(sel_group)
  for(i in 1:length(sel_group)){
    if(sel_group[i] > best_eval){
      target <- sel_group[i]
      break
    }
  }
  if(max(sel_group) < best_eval){
    target <- 0
  }
  c(target, max(input_list))
}
make_choice(3, 1)

p_find_best <- function(n=100, N, split_number){
  count <- 0
  for(i in 1:n){
    result <- make_choice(N, split_number)
    #print(result)
    if((result[1]) == (result[2])){
      count = count + 1
    }
    p <- count/n
  }
  p
}
p_find_best(n, 3, 1)

find_optimal <- function(N){
  p <- list()
  for(i in 1:N/2){
    p[i] <- p_find_best(n, N, i)
  }
  opt <- which.max(p)
  plot(x=1:length(p), y=p)
  return(c(opt, p[opt]))
}

find_optimal(3)    # (1, 0.5083)
find_optimal(10)   # (4, 0.3958)
find_optimal(100)  # (39, 0.3797)
