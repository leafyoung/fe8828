## Run as mainFn(<Number of Folds>)
assignFold<-function(vec,N)
{
  if(N==1)
    {
      return(vec)
    }
  else
    {
      l<-length(vec)
      new_vec<-c(rep(0,(2*l)+1))
      flag<-1
      count<-1
      for(i in 1:(2*l+1))
      {
        if(i%%2 == 0)
        {
          new_vec[i]<-vec[count]
          count<-count+1
        }
        else
        {
          new_vec[i]<-(1-flag)
          flag<-1-flag
        }
      }
      return(assignFold(new_vec,N-1))
    }
}

mainFn<-function(N)
{
  fold_vec<-assignFold(c(1),N)
  for(i in seq_along(fold_vec))
  {
    cat(i,paste(". "),ifelse(fold_vec[i]==1,"Convex","Concave"),"\n")
  }
}