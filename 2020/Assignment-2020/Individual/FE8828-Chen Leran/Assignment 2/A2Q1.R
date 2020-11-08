make_choice <- function(N, split_number){
  count = 0
  for (i in 1:1000) {
    input_list = sample(1:N,N,replace = FALSE)
    evaluation = input_list[1:split_number]
    best = max(evaluation)
    curr = split_number+1
    for (j in curr:N) {
      if (input_list[j] >= best){
        if(input_list[j]==N){
          count = count + 1
        }
        break
      }
    }
  }
  count / 100
}

find_optimal <- function(N){
  curr_max_split = -1
  curr_max_p = -1
  for (i in 1:floor(N/2)) {
    if(make_choice(N,i) > curr_max_p){
      curr_max_p = make_choice(N,i)
      curr_max_split = i
    }
  }
  curr_max_split
}

print(paste0("N=3 best split: ", find_optimal(3)))
print(paste0("N=10 best split: ", find_optimal(10)))
print(paste0("N=100 best split: ", find_optimal(100)))



