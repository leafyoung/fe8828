N=100

#function 
make_choice <- function(N, split_number)
{
  input_list=sample(1:N,N,replace = FALSE)#generate whole list
  
  #generate two list
  evaluation_group=list()
  selection_group=list()
  for(i in 1:split_number)
  {
    evaluation_group[[i]]=input_list[[i]]
  }
  for(j in (split_number+1):N)
  {
    selection_group[[(j-split_number)]]=input_list[[j]]
  }
  
  #find the best in the evaluation group
  max=evaluation_group[[1]]
  for(i in 1:split_number)
  {
    if(evaluation_group[[i]]>max)
    {
      max=evaluation_group[[i]]
    }
  }
  
  #find the first number(>=max)
  #If no one is bigger than max, set fn as 0
  fn=0
  for(j in 1:length(selection_group))
  {
    if(selection_group[[j]]>=max)
      {
      fn=j
      break
      }
  }
  
  if(fn==0)
    return(0)
  else
    return(selection_group[[fn]])
}

#calculate the probability of getting N
prob=list()

for(q in 1:(N/2))
{
  countall=0
  countN=0 #count the times getting N

  for(k in 1:300)
  {
    a=make_choice(100,q)
    countall=countall+1
    if (a == 100)
    {
      countN=countN+1
    }
  }
  prob_get_N=countN/countall
  prob[q]=prob_get_N
}


max_get_N=1
for(i in 1:length(prob))
{
  if(prob[[i]]>prob[[max_get_N]])
  {
    max_get_N=i
  }
}

#the highest probability of getting N
prob[[max_get_N]]
#the corresponding splite number
max_get_N
