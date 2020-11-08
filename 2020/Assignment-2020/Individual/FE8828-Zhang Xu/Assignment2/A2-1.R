


make_choice <- function(N,split_number){
  input_list <- sample(1:N,N,replace=FALSE)
  eva_group <- input_list[1:split_number]
  sel_group <- input_list[split_number+1:length(input_list)]
  best <- max(eva_group)
  if (best==N){
    return(N)
  }
  for(b in sel_group){
    if( b >= best ){
     return(b)
    }  
  }
}

find_optimal <- function(N){
  for(i in 1:ceiling(N/2)){
    
      selected <- purrr::map(1:500,make_choice(N,i))
      selected <- selected[]
    
  }
}

cat(make_choice(10,8))

