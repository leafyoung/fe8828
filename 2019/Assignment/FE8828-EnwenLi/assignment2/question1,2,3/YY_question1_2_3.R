#question1: count_biz_days

# Actually, I find that my results are different from the bizdays package.
# Which means that my count_bizday doesn't equal to bizdays("year-01-01", "year-12-31", "weekends").
# This is because that the bizdays("year-01-01", "year-12-31", "weekends") doesn't include "year-12-31".
# YY:
# 

count_bizday <- function(year) {
  start_day=as.Date(paste0(year,"-01-01"), format = "%Y-%m-%d")#start date of the year.
  end_day=as.Date(paste0(year,"-12-31"), format = "%Y-%m-%d")#end date of the year.
  temp<-seq.Date(from=start_day,to=end_day,by="day")#generate date sequence of the whole year.
  bizday=0
  for(i in (1:length(temp))){
    t=floor((12-month(temp[i]))/10)
    y=year(temp[i])-t
    m=month(temp[i])+12*t
    c=floor(y/100)
    Y=y %% 100
    weekday=(day(temp[i])+Y+floor(Y/4)+floor(c/4)+5*c+floor((26*(m+1)/10)))%%7
    # when it is saturday, weekday=0; when it is sunday, weekday = 1.
    if(weekday!=0 && weekday!=1){
      bizday = bizday+1
    }
  }
  bizday
}

count_bizday(2000)
count_bizday(2005)
count_bizday(2019)

#question 2: secretary probelm

#first- form the choice making function 
make_choice <- function(N, split_number){
  group<-sample(1:N,N,replace=FALSE)
  evaluation_group = group[1:split_number]
  selection_group = group[(split_number+1):N]
  best = max(evaluation_group)
  # YY: use a variable to see whether we can find a better one in selection_group
  selected <- FALSE
  for(data in selection_group){
    if(data > best || data==best){
      best=data
      selected <- TRUE
      break
    }
  }
  
  # YY: If we can't find a better one, we return the last item.
  if (!selected) {
    return(group[N])
  } else {
    return(best)  
  }
}
#second- form the finding optimal function 
find_optimal<- function(N){
  prob_of_all<-rep(0,N/2)#This is to store all the prob in a list.
  for(i in (1:N/2)){
    prob=0 #the probability of choosing the best.
    for(j in(1:1000)){
      best=make_choice(N,i)
      if(best==100){
        prob=prob+(1/N)
      }
    }
    prob_of_all[i]<-prob
  }
  optimal_number=match(max(prob_of_all),prob_of_all)
  return(optimal_number)
}

# YY: test code
find_optimal(100)

#question3

#we first simulate one family.
one_family<-function(){
  count=1
  child=sample(c("G","B"),1)#G represents girl while B represents boy.
  while(child == "G"){
    child=sample(c("G","B"),1)
    count=count+1
  }
  ## YY: Good
  return(count)#count is the total children one family have, and girls = count-1
}

#simulate n families
n_family<-function(n){
  sum=0
  for(i in(1:n)){
    count=one_family()
    sum=sum+count
  }
  girl_ratio=(sum-n)/sum
  number_of_girl=sum-n
  return(c(number_of_girl,girl_ratio))
}
#get the distribution of the ratio.
#In our distribution, the x is probability and y is the number of girls.
#We simulated n times to plot the distribution.
distribution_of_ratio<-function(number_of_family,simulation){
  #simulation is the simulation times of an experiment.
  library(ggplot2)#install ggplot2
  library(tidyverse)#install tidyverse
  number_of_girl<-rep(1,simulation)
  girl_ratio<-rep(1,simulation)
  for(i in (1:simulation)){
    n_family_data=n_family(number_of_family)
    number_of_girl[i]=n_family_data[1]
    girl_ratio[i]=n_family_data[2]
  }
  distribution<-data.frame(Number=number_of_girl,Ratio=girl_ratio)
  cumulated_distribution<-unique(distribution[order(distribution$Number,decreasing=FALSE),])#Order the unique distribution by number.
  prob_of_ratio<-rep(1,length(cumulated_distribution$Number))  
  for(i in (1:length(cumulated_distribution$Number))){
    z=is.na(match(distribution$Number,cumulated_distribution$Number[i]))
    count_ratio=length(z[z==FALSE])#count the number when girl's number equals to i
    prob_of_ratio[i]=count_ratio/simulation#calculate the probability of one ratio
  }
  cumulated_distribution$Prob_ratio=prob_of_ratio
  cumulated_distribution$Cum_prob=cumsum(cumulated_distribution$Prob_ratio)#calculate the cumulated probability
  return(list(distribution, cumulated_distribution))
}

cumulated_distribution=distribution_of_ratio(10,500)
ggplot(cumulated_distribution, aes(Ratio,Cum_prob))+ geom_point()+ geom_smooth(method = "loess", se = FALSE)#cdf of ratio, namely the distribution of ratio.
