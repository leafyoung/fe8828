dice=c(1,2,3,4,5,6)
winnings=c()
Expected_Value=mean(dice)
for (i in 1:1000) 
  {
  roll=sample(dice,1,replace=TRUE)
  if(roll<Expected_Value)
    {
    roll=sample(dice,1,replace=TRUE)
    winnings[i]=roll
    }
  winnings[i]=roll
  }
AverageWinnings=mean(winnings)

# YY: above is not right. my correction below
dice=c(1,2,3,4,5,6)
winnings=c()
Expected_Value=mean(dice)
for (i in 1:100000) 
  {
  roll=sample(dice,1,replace=TRUE)
  if(roll<Expected_Value)
    {
    roll=sample(dice,1,replace=TRUE)
    winnings[i]=roll
    } else { # YY: missing else here
      winnings[i]=roll
    }
  }
AverageWinnings=mean(winnings)

print(AverageWinnings)
