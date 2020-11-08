
#Let 1 be the worst secretary and 100 be the best
make_choice <- function(N, split_number){
  input_list <- c(sample(1:N,N,replace=FALSE))
  #eval_list=(from) input_list[[1]][[1]] (to) input_list[[1]][[split_number]]
  eval_list<-input_list[1:split_number]
  #sele_list=(from) input_list[[1]][[split_number+1]] (to) input_list[[1]][[N]]
  sele_list<-input_list[split_number+1:N]
  best_eval<-max(eval_list)
  
  for(b in sele_list)
    if(best_eval==N){
      best_sele<-0
      break
    }else if(b>best_eval){
      best_sele<- b
      break
    }
  best_sele
}


prob_simu <- function(N,split_number) {
  count<-0
  for (i in 1:5000){
    ppp<-c()
    ppp[[i]]<-make_choice(N,split_number)
    count<-count+ifelse(ppp[[i]]==N,1,0)
  }
  count/5000
}

find_optimal<-function(N){
  qqq<-c()
  for(i in (1:ceiling(N/2))){
    qqq[i]<-prob_simu(N,i)
  }
  order(qqq,decreasing=TRUE)[1]
}

splitnumber<-find_optimal(100)
splitnumber
probability<-prob_simu(100,splitnumber)
probability