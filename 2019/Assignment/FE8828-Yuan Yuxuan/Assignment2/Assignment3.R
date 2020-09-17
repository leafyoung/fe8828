#Question: Birth ratio question
#Simulate for 10 families, get the distribution of the ratio.

#This method returns the simulated number of boys total family 
give_birth <- function(family_count){
  #1 refers to boy, 0 refers to girl
  baby_gender = sample(c(0,1), size=family_count, replace=TRUE)
  boy_count = length(which(1 == baby_gender))
  return(boy_count)
}

simulation <- function(total_family){
  total_girl = 0
  total_boy = 0
  while (total_family>0) {
    new_boy = give_birth(total_family)
    total_girl = total_girl+total_family-new_boy
    total_boy = total_boy+new_boy
    total_family = total_family-new_boy
  }
  #Girl Ratio is defiled as "the number of girl per boy"
  #Not using the official "sex ratio" concept which defined as "number of boy per girl" because number of girl may be 0, which will cause Infinity value
  girl_ratio = total_girl/(total_boy + total_girl)
  return(girl_ratio)
}

#Run simulation for 1000 times with 10 family
get_simulated_ratio <- function(){
  birth_rate_result = c()
  for(i in 1:1000){
    birth_rate_result[i] = simulation(10)
  }
  
  hist_graph = hist(birth_rate_result)
  return(mean(birth_rate_result))
}

#Run the following command to run result
ratio = get_simulated_ratio()

#Answer: by running the command above, we can see the ratio is around 1. Which means that the proportion of boys to girls is around 50:50
#Run "ratio = get_simulated_ratio()" to have better view on the result
