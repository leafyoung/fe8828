make_choice<-function(N,split_number)
{
  input_list<-sample(1:N,N,replace=FALSE)
  evaluation_group<-input_list[1:split_number]
  selection_group<-input_list[split_number+1:N]
  best<-max(evaluation_group)
  for(i in 1:(N-split_number)){
    if(selection_group[i]>best) {
      best<-selection_group[i]
      break
    }
  }
  return (best)
}

find_best<-function(N,split_number){
  flag=FALSE
  best<-make_choice(N,split_number)
  if(best!=N) { flag<-FALSE}
  else {flag<-TRUE}
  flag
}

res<-sapply(1:100,function(x){find_best(100,30)})
sum(res)/100     


find_optimal<-function(N){
  prob<-0
  number<-0
  for(i in 1:N/2) {
    res<-sapply(1:100,function(x){find_best(N,i)})
    prob1<-sum(res)/N
    if(prob1>prob) {
      prob=prob1
      number=i
      }
  }
  return (number)
}

find_optimal(3)
results<-sapply(3:100,function(x){find_optimal(x)})
tail(results)

