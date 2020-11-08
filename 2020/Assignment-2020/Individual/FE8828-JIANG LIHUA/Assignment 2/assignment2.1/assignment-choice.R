#assignment:how far to make a choice
make_choice<-function(N,split_number){
  x<-sample(1:N,N,replace = FALSE)
  input_list<-as.list(x)
  evaluation<-list()
  selection<-list()
  for(i in 1:split_number){
    evaluation[[i]]<-input_list[[i]]
  }
  for(i in 1:(N-split_number)){
    selection[[i]]<-input_list[[i+split_number]]
  }
  max_eva<-evaluation[[1]]
  for(i in 1:split_number){
    if(max_eva < evaluation[[i]]){
      max_eva <- evaluation[[i]]
    }
  }
  for(i in 1:(N-split_number)){
    if(selection[[i]]>max_eva){
      return(selection[[i]])
      break
    }
    else{
      return(max_eva)
    }
  }
}

prob_N<-function(N,split_number){
  count<-0
  for(j in 1:100){
    a<-make_choice(N,split_number)
    #print(a)
    if(a==N){
      count<-count+1
    }
  }
  prob<-count/N
  return(prob)
}

N<-100
split_number<-30
prob_N(N,split_number)

max_prob<-0
prob_sequence<-rep(0,(N/2))
for(i in 1:(N/2)){
  p<-prob_N(N,i)
  prob_sequence[i]<-p
  if(p>max_prob){
    max_prob<-p
  }
}
for(i in 1:(N/2)){
  if(prob_sequence[i]==max_prob){
    print(i)
  }
}


find_optimal<-function(){
  max_prob<-0
  prob_sequence<-rep(0,(N/2))
  for(i in 1:(N/2)){
    p<-prob_N(N,i)
    prob_sequence[i]<-p
    if(p>max_prob){
      max_prob<-p
    }
  }
  for(i in 1:(N/2)){
    if(prob_sequence[i]==max_prob){
      return(i)
    }
  }
}


N<-3
result1<-find_optimal()
N<-10
result2<-find_optimal()
N<-100
result3<-find_optimal()

