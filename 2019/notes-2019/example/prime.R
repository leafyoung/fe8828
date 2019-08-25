prime = function(a){
  n <- c(2)
  i <- 3
  while (i <= a ) {
    r <- 0
    for(j in n[ n <= sqrt(i) ])
    {
      # cat(paste0("i: ", i, " j: ", j, "\n"))
      if (i%%j == 0) {
        r <- 1
        break
      }
    }
    
    if (r != 1) { n = c(n, i) }
    i <- i + 2
  }
  
  print(n)
}

prime(1e6)

allPrime <- function(n) {
  primes <- rep(TRUE, n)
  primes[1] <- FALSE
  for (i in 1:sqrt(n)) {
    if (primes[i]) primes[seq(i^2, n, i)] <- FALSE
  }
  which(primes)
}

allPrime(1e6)
