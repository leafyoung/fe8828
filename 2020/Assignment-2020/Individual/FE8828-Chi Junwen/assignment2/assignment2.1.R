######assignment1


######step1
make_choice<-function(N,split_number){
  input_list<-sample(1:N,N,replace=F)
  selection_group<-input_list[1:split_number]
  evaluation_group<-input_list[(split_number+1):N]
  min_num<-min(selection_group)
  for (i in seq_along(evaluation_group)){
    if(evaluation_group[i]<min_num){return(evaluation_group[i])}
  }
  return(0)
}


result1<-sapply(1:10000, function(x) {make_choice(100,24)})

prob<-length(which(result1==1))/10000
prob


####step2
find_optimal<-function(N){
  prob<-c()
  for (i in 1:ceiling(N/2)){
    result1<-sapply(1:10000, function(x) {make_choice(N,i)})
    prob<-c(prob,length(which(result1==1))/10000)
    
  }
  return(which(prob==max(prob)))}
  


find_optimal(3)
find_optimal(10)
find_optimal(100)


