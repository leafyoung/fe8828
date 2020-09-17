#Birth Ratio problem using random sampling

birth_ratio <- function(families)
{
  #Let 1 denote a boy and 2 denote a girl
  boy <- 0
  girl <- 0
  child <- sample(1:2,10,replace=TRUE)
  boy <- length(which(child==1))
  girl <- length(which(child==2))
  for(i in child)
  {
    if(i==2)
    {
      while(TRUE)
      {
        new_kid <- sample(1:2,1,replace=TRUE)
        #cat(paste0(" new kid is ",new_kid,"\n"))
        if(new_kid==1)
        {
          boy <- boy+1
          break
        }
        else
        {
          girl <- girl +1
        }
      }
    }
  }
  #cat(paste0("boys ",boy," girls ",girl," \n"))
  if(girl==0)
  {
    return(birth_ratio(10)) #Ignoring the case where first children for all families are boys
  }
  # return((boy/girl))
  return((girl/(girl + boy)))
}


#Driver Code
families <- 10 #No. of families
# We will repeat the process 10000 times
ratio <- c()
for(i in 1:10000)
{
  ratio <- c(ratio,birth_ratio(10))
}
#print(ratio)
rat <-mean(ratio)
cat(paste0("Average birth ratio for 10 families is ",round(rat,digits=4)," boys to every 1 girl.\n"))

