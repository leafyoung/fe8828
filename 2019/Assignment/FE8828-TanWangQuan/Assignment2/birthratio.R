library("dplyr")

getFemaleToMale <- function(){
  #Returns a list of number of female to number of male in a family.
  children = sample(c('Boy','Girl'),1)
  
  #As long as the child is a girl, continue having babies
  while (tail(children,1)=='Girl') {
    
    children=append(children, sample(c('Boy','Girl'),1))
  }
  d = c(as.numeric(sum(children %in% 'Girl')),1)
 
  return(d)
}

getDistribution<-function(){
  p <- c()
  maxFamily = 20
  cat(paste("Number of families to calculate:",maxFamily,"\n"))
  for (k in 1:maxFamily){
        ratioArr=NULL
        for(i in 1:2000){
          
          #declare empty data frame with 2 column.
          df=NULL
          df=data.frame(matrix(ncol = 2,nrow = 0))
          x <- c("Girls", "Boys")
          colnames(df) <- x
          
          #create distribution of k families
          for (j in 1:k){
            #for some reason rbind messes up the column name. This line adds the ratio for each family
            df[nrow(df)+1,] = getFemaleToMale()
          }
        
          #find the ratio
          numGirls = colSums(df)[1]
          total = colSums(df)[1] +colSums(df)[2] 
          ratio = as.numeric(numGirls / total)
          
          ratioArr = append(ratioArr,ratio)
        
        }
        cat(paste("Family no.",k,"completed\n"))
        p[k] = mean(ratioArr)
  }
  
  plot(1:maxFamily, p, type = "l", xlab = "No. of Families",
       ylab = "Probability of girls in the population",
       main = "The distribution of ratio")
}

getDistribution()

#Results
#Ratio converges to 0.5 as number of families increases

#Coding Lessons learnt: 
# 1. Dataframe cannot have variable rows 
# 2. Inserting vector into vector does not produce intended datastructure.
# 3. Need to declare empty matrix to initialize col name. 
# 4. rbind to empty dataframe will erase colname


