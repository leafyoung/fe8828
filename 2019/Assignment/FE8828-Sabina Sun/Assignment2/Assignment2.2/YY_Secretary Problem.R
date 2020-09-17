make_choice <- function(N, split_number){
  input_list <- sample(1:N,N,replace = F)
  
  # YY: below can be replaced by 
  max <- max(input_list[1:split_number])
  if (FALSE) {
    max<-input_list[1]
    if (split_number!=1) {
      for (x in 2:split_number) {
        if (input_list[x]>max) {
          max<-input_list[x]
        }
      }
    }  
  }

  if (max == N) {
    result = input_list[N]
  } else {
    result <- -1
    for (x in (split_number+1):(N)) {
      if (input_list[x]>max) {
        result = input_list[x]
      }
    }
    # YY: if 100 appears in the first group, return the last item.
    if (result == -1) {
      result = input_list[N]
    }
  }

  if (FALSE) {
    if (split_number!=N) {
      for (x in (split_number+1):(N)) {
        if (input_list[x]>max) {
          result = input_list[x]
        }
      }
    }
  }
  
  return(result)
}

make_choice(100,10)

find_optimal<- function(N){
  maxcounter=0  
  optimal=1
  for (n in 1:N) { #did not stop at N/2 since there exist probability that optimal is at N
    trials =200
    counter=0
    for (x in 1:trials) {
      if (make_choice(N,n)==N) {
        counter<-counter+1
      }
    }
    if (counter>maxcounter) {
      maxcounter=counter
      optimal=n
    }
  }
  return(optimal)
}

find_optimal(100)

trials = 100
events = 100
x = c()

for (n in 1:trials) {
  x= c(find_optimal(events),x)
}

hist(x)

# YY: after my correction, it is closer to mathematical solution
sum(x)/trials #approximate solution

1/exp(1)*events #mathematical solution

