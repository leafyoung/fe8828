make_choice <- function(N, split_number) {
  input_list <- sample(1:N,N,replace=F)
  eval_list <- input_list[1:split_number]
  select_list <- input_list[-(1:split_number)]
  #cat(paste0(input_list),"\n")
  #cat(paste0(eval_list),"\n")
  #cat(paste0(select_list),"\n") 
  besteval <- max(eval_list)
  #cat(paste0(besteval),"\n")
  selected <- FALSE
  for (select in select_list) {
    if (select > besteval) {
      selected <- TRUE
      break
    }
  }
  # YY: if N is in the first group, selected is still FALSE, return the last item.
  if (!selected) {
    select <- input_list[N]
  }
  return(select)
}

N <- 100
total_run <- 10000
split_number <- sample(2:N-1,1)
split_number <- 20
for (run in 1:total_run) {
  # YY: include this in the for loop, so getNcount is always got initialized to 0.
  if (run == 1) { getNcount <- 0 }
  #cat(paste0(split_number),"\n")
  if (make_choice(N,split_number)==N) {
    getNcount <- getNcount+1
  }
  #cat(paste0(getNcount),"\n")
}
cat(paste0("split_number:", split_number, " probability:", getNcount/total_run))

find_optimal <- function(N) {
  bestsplitcount <- -1
  bestsplit <- -1
  for (split in 1:(N/2)) {
    getNcount <- 0
    for (run in 1:10000) {
      if (make_choice(N,split)==N) {
        getNcount <- getNcount+1
      }
    }
    
    if (getNcount > bestsplitcount) {
      bestsplitcount <- getNcount
      bestsplit <- split
    }
  }
  return(list(bestsplit = bestsplit, bestsplitcount = bestsplitcount))
}

cat(find_optimal(100))
  