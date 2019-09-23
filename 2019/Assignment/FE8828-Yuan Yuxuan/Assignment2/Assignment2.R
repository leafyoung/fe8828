#Question: Secretary Problem

#Step1
make_choice <- function(N, split_number){
  input_list <- sample(1:N, N, replace = FALSE)
  evaluation_group = input_list[0:split_number]
  selection_group = input_list[(split_number+1):(length(input_list))]
  max_score = 0
  for(e in evaluation_group){
    if(e>max_score){
      max_score = e
    }
  }
  
  for(s in selection_group){
    if(s >= max_score){
      return(s)
    }
  }
}