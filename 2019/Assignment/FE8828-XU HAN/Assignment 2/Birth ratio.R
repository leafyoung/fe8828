#boy is 1, and girl is 2
library(purrr) 
allratio=c()
test=function()
{
  Child <- purrr::map(1:10, function(x) { sample(1:2,1,prob =c(0.5,0.5)) })
  
  for(i in 1:10)#for ten families
  {
    #if they do not have boy, they will continue giving birth
    while(Child[[i]][length(Child[[i]])]==2)  
    {
          a=sample(1:2,1,prob =c(0.5,0.5))#give birth
          Child[[i]][length(Child[i])+1]=a
    }
  }

  #calculate the number of boys  
  count_boy=0
  for(i in 1:10)
  {
    for(j in 1:length(Child[[i]]))
    {
      if(Child[[i]][j]==1)
        count_boy=count_boy+1
    }
  }
  
  #calculate the number of boys  
  count_girl=0
  for(i in 1:10)
  {
    for(j in 1:length(Child[[i]]))
    {
      if(Child[[i]][j]==2)
        count_girl=count_girl+1
    }
  }
  
  ratio=count_boy/count_girl
  return(ratio)
}

for(i in 1:1000)
{
  allratio[i]=test()
}

hist(allratio,freq = F,main="The Distribution of Ratio of Boys to Girls",xlab = "Ratio")
