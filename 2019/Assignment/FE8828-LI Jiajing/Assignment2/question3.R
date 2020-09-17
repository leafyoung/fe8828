library(ggplot2)

universe <- function(){
  sum_girl <- 0
  for(k in 1:10){               #each of the 10 families do a simulation 
    random <- sample(1:10000, size = 100, replace = TRUE, prob = NULL)
    g <- 0
    thefirstone <- 0     #regard the first number>=5000 as the appearance of the boy
    for(i in random){
      if(i >= 5000){
        thefirstone <- i
        break
      }
    }
    for(j in 1:1000){         #the location of the first boy
      if(random[[j]] == thefirstone){
        g <- j-1              #before the boy are all girls
        break
      }
    }
    sum_girl <- sum_girl+g    #add up the number of girls in each of the 10 families
  }
  ratio <- sum_girl/(10+sum_girl)        #the girl/boy ratio of the 10 families as a whole
  ratio               
}


x <- c()
for(u in 1:1000){             #do the above test many(1000) times 
  x[[u]] <- universe()        #to find the distribution 
}                             #of the birth ratio of 10 families as a whole


X <- data.frame(x)  
X


ggplot(X, aes(x)) + 
  geom_line(stat = "density")


