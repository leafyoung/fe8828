#count businessday
count_bizday <- function(year) {
  all_days<-seq(as.Date(paste0(as.character(year),"-01-01")),
      as.Date(paste0(as.character(year),"-12-31")),by="day")
  workdays<-all_days[!(weekdays(all_days) %in% c("Saturday","Sunday"))]
  return(length(workdays))
}

count_bizday(2005)
count_bizday(2019)

#secretary problems
make_choice <- function(N, split_number){
  candidates<-sample(1:N,replace = FALSE)
  evaluation_group<-candidates[1:split_number]
  selection_group<-candidates[(split_number+1):N]
  highest_mark<-max(evaluation_group)
  for (i in 1:(N-split_number)) {
    if(selection_group[i]>highest_mark){
      choice<-selection_group[i]
      return(choice)
    }
  }
  # YY: if N is in evaluation group, shall return the last item.
  return(candidates[N])
}

# YY: make total_run an optional parameter so we can set it when calling the function.
find_optimal<-function(N, total_run = 1000){
  all_Probs<-c()
  for(i in 1:(N%/%2)){
  all_choices<-replicate(total_run, make_choice(N,i))
  Prob_of_best_choice<-length(all_choices[all_choices==N])/length(all_choices)
  all_Probs<-c(all_Probs,Prob_of_best_choice)
  }
  optimal_number<-which(all_Probs==max(all_Probs))
  return(optimal_number)
}

#find the optimal split number of 100 candidates
find_optimal(100)

#Compute the average of 100 opitimal split numbers when there are N candidates.
#This function may take some time.
average_optimal<-function(N){
  all_result<-c()
  for(i in 1:100) {
    all_result<-c(all_result,find_optimal(N))
  }
  return(mean(all_result))
}

average_optimal(100)

#Birth Ratio Question

#1 family as a sample
infants<-function(){
  infants<-c()
  # YY: save time to just check the last element
  # while (length(infants[infants=="boy"])==0) {
  while (is.null(last(infants)) || last(infants) == "girl") {
    infants<-c(infants, sample(c("boy","girl"),1,replace=TRUE))
  }
  return(infants)
}

#10 families as a sample
generate_sample<-function(){
  return(replicate(10,infants()))
}

count_girl2boy_ratio<-function(sample){
  girls<-0
  # YY: make list "flattern" to a vector
  # We can skip the for loop
  sample <- unlist(sample)
  girls <- length(sample[sample == "girl"])

  # for (i in 1:length(sample)) {
    # girls<-girls+length(sample[[i]][sample[[i]]=="girl"])
    
  # }
  # YY: After unlist, length(smaple) is the total number of children.
  # Otherwise, it's 10 for the length of list.
  return(girls/length(sample))
}

#Distribution of N samples
distribution<-function(N){
  distribution<-c()
  data<-replicate(N,count_girl2boy_ratio(generate_sample()))
  for(i in 1:N){
    distribution<-c(distribution,data[[i]])
  }
    distribution<-as.data.frame(distribution)
    names(distribution)<-c("Girl_Boy_Ratio")
    return(distribution)
}     

library(ggplot2)

Distribution<-distribution(1000)

#Historgram of distribution of girl/boy ratio
ggplot(Distribution,aes(x=Girl_Boy_Ratio))+
  geom_histogram()  

#Density histogram and pdf
ggplot(Distribution,aes(x=Girl_Boy_Ratio))+
  geom_histogram(aes(y=..density..))+
    geom_density()
  
  






