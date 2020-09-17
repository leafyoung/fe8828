birth_ratio <- rep(0,500)
for (mm in 1:500){
  girls <- rep(0,10)
  for(nn in 1:10){
    while(rbinom(1,1,0.5) == 0){
      girls[nn] <- girls[nn] + 1
    }
  }
  # YY: boys are always 10
  birth_ratio[mm] <- sum(girls) / (sum(girls) + 10)
}

hist(birth_ratio)
mean(birth_ratio)
