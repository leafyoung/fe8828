# YY: Use <- not = in R.
# sprintf only prints to string/character
# Un-learn a bit of C? :-)

Brithday_Probability <- function(Birthday_Month,Birthday_Year,MonthList,DaysList)
{
  DaysIndex=match(Birthday_Month,MonthList)
  if(Birthday_Year%%4==0)
    {
      if (Birthday_Year%%100==0&Birthday_Year%%400!=0) 
        {
        probability=as.numeric(DaysList[DaysIndex])/365
        }
    else
        {
        DaysList[2]=29
        probability=as.numeric(DaysList[DaysIndex])/366
        }
    }
  else
    {
    probability=as.numeric(DaysList[DaysIndex])/365
    }
    return(probability)
}

MonthList=list("January","February","March","April","May","June","July","August","September","October","November","December")
DaysList=list(31,28,31,30,31,30,31,31,30,31,30,31)
Datelist=list(MonthList,DaysList)
Probability_Array=c()

for(i in 1:12)
{
SampleMonth=sample(MonthList,1,replace=TRUE)
SampleYear=sample(1:3000, 1, replace = TRUE)
Probability_Array[i]=Brithday_Probability(SampleMonth,SampleYear,MonthList,DaysList)
DaysList[2]=28

# sprintf only prints to string/character
print(paste0(
  sprintf("SampleMonth: %s",SampleMonth), " ",
  sprintf("SampleYear: %d",SampleYear), " ",
  sprintf("Probability: %s",Probability_Array[i])))
}
  
