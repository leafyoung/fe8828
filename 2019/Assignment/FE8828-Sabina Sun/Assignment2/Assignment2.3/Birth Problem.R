gender <- function(){
  ratio<-sample(0:1,2,replace = F)
  return(ratio[1])
} 
gender()
familyratio <- function(family){
  child=c(0,0)
  for (x in 1:family) {
    while (gender()==1) {
      child[1]=child[1]+1 #additional girl
    }
    child[2]=child[2]+1 #stops with 1 boy
  }
   return(child[1]/sum(child))
}

trials=1000
result=NULL
for (x in 1:trials) {
  result=c(familyratio(10),result)
}

hist(result,main = paste("Ratio of girls to total population"))
mean(result)
