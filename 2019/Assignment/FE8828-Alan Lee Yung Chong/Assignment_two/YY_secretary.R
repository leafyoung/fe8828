
make_choice <- function(N, split_number){
  input_list <-sample(c(1:N))
  eval <- input_list[1:split_number]
  # YY: use (split_number+1):N
  # selection <- input_list[split_number+1:N]
  selection <- input_list[(split_number+1):N]
  
  # eval larger than 
  best_in_eval <- min(eval) # best number
  
  # YY: This is not right. We can continue to look for the better one in the selection group.
  for (ss in selection) {
    if (ss < best_in_eval){
      return(ss)
    }
  }
  # return last item
  return(input_list[N])
  
  if (FALSE) {
    first_in_select <- selection[1]
    if (first_in_select >= best_in_eval){
      return(first_in_select)
    } else {
      return (-1) # return -1 to prevent no output
    }
  }
}

#Main driver code for running make_choice
counter <- 5000
N_counter <- 0 # only increase if make_choice return 1
for (i in 1:counter){
  result <- make_choice(100,50)
  # YY: Above, you have use the small number to represent better, I use 1 here, instead of 100.
  if(result == 1){
    N_counter <- N_counter + 1
  }
}
print(N_counter/counter)

#part 2
find_optimal <-function(){
  N<- 100
  split_size <- N/2
  counter <- 5000
  N_counter <- 0
  l <- list()
  
  for (i in 1:split_size){
    N_counter <- 0
    for (j in 1:counter){
      # YY: use i here
      # result <- make_choice(N, split_size)
      result <- make_choice(N, i)
      # YY: Use 1 here
      if (result==1){
        N_counter <- N_counter + 1
      }
    }
    prob <- N_counter/counter
    # store this prob
    l[[i]] <- prob
  }
  
  # return(which.max(l)) # returns the index of the minimum position.
  return(l)
  # the index will coincide with the split_num.
}

dd <- find_optimal()
which.max(dd)
plot(unlist(dd))
