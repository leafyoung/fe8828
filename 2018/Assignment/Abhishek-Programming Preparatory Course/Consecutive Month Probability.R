MonthList=c("January","February","March","April","May","June","July","August","September","October","November","December")
MonthsGenerate=c()
AverageProbability=c()
len=0
ProbabilityCalc<-function(MonthList,MonthsGenerate)
{
count=0
 while(len<12)
 {
   count=count+1
   MonthsGenerate[count]=sample(MonthList,1,replace=TRUE)
   len=length(intersect(MonthList,MonthsGenerate))
 }
return(count)
}
AverageProbability=replicate(100000,ProbabilityCalc(MonthList,MonthsGenerate))
mean(AverageProbability)
hist(AverageProbability)

  