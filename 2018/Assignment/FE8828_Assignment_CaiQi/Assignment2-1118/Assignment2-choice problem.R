make_choice<-function(N,split_number){
  input_list<-sample(1:N,N,replace = FALSE)
  best_n<-max(input_list[1:split_number])
  if(best_n==N) return(input_list[N])
  else{
  for (i in (split_number+1):N) {
    if(best_n<input_list[i]){
      return(input_list[i])
      break
    }
  }
}}

find_optimal<-function(N,run_time){
#N<-100
#run_time<-1000
choice_mean<-c()
prob_opt<-c()
for (split_numer in 1:(N-1)) {
  count_opt<-0
  choice_res<-c()
  for (i in 1:run_time) 
    choice_res[i]<-make_choice(N,split_numer)
  count_opt<-sum(ifelse(choice_res==N,1,0))
  choice_mean[split_numer]<-mean(choice_res)
  prob_opt[split_numer]<-count_opt/run_time
}

best_split<-0
best_mean<-0
for (i in 1:(N-1)) {
  if(prob_opt[i]==max(prob_opt))
    best_split<-i
  if(choice_mean[i]==max(choice_mean))
    best_mean<-i
}
#plot(choice_mean)
#plot(prob_opt)
#max(prob_opt)
#best_split
#best_mean
return(best_split)
}

best_split_num<-c()
for (i in 1:10) {
  best_split_num[i]<-find_optimal(100,1000)
}
plot(best_split_num)
mean(best_split_num)
