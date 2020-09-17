# iterative summation problem
# library("combinat")
# get_dist <-function(){
#   no_terms <- 100 #n
#   k <- 100 #100 families as the limit
#   result_v <- c()
#   for (ker in 1:k){
#     result <- 0
#     for (n in 0:no_terms){
#       #find out the nCr equivalent. May use when k and n is known
#       comb <- factorial(n+ker-1)/(factorial(ker-1)*factorial(n))
#       indivd_term <- (comb/2^(n+ker))*(n/(n+ker))
#       result <- result + indivd_term
#     }
#     
#     print(result)
#     # store in vector.
#     result_v[ker] <- result
#   }
#   hist(result_v)
# }

get_dist <- function(){
  #k=10 families
  k<-10
  #no of simulations
  sim_no = 1000
  # ratio_vec to collect birth ratio
  ratio_vec <- c()
  for (sim in 1:sim_no){
    ind_sim_counter_b <-0
    ind_sim_counter_g <-0
    for (fam in 1:k){
      #vector of child get renewed everytime
      child_v <- c()
      get_boy <- FALSE
      ind_counter <- 1
      while (!get_boy){
        # genenate random number if 1=boy, 0=girl
        child <- sample(1:100, 1)%%2
        if (child==1){
          get_boy <- TRUE #To break the loop
          child_v[ind_counter] <- child
        } else if (child==0){
          child_v[ind_counter] <- child
        }
        ind_counter <- ind_counter +1
      }
      # count the number of boys and girls, append the ratio to vector
      ind_sim_counter_b <- ind_sim_counter_b + sum(child_v==1)
      ind_sim_counter_g <- ind_sim_counter_g + sum(child_v==0)
    }
    # Birth ratio =girls / sum of girls and boys
    ratio_vec[sim] <- ind_sim_counter_g/(ind_sim_counter_g +ind_sim_counter_b)
  }
  hist(ratio_vec, xlab="Birth ratio", ylab = "Frequency",
       main="Histogram of Birth Ratio. (Girls/ Sum of Girls and Boys)", xlim=c(0,1), breaks=20, col="gold", border=NULL)
  return (ratio_vec)
}

get_dist()
