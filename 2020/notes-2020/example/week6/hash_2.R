# hash.R
# FE8828
# Author: Yang Ye

# install.packages("openssl")
library(openssl)

# Rainbow attack

sha256("123")
# a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3
sha256("124")
# 6affdae3b3c1aa6aa7689e9b6a7b3225a636aa1ac0025f490cca1285ceaf1487

sha256(sha256("123"))
# "173af653133d964edfc16cafe0aba33c8f500a07f3ba3f81943916910c257705"

sha256(sha256("124"))
# "0c60bfa8e6f9f5d9e86c72832c1936ce551c8f47adb61ba949eb638668c0205a"

# page 1
paste0("a=",list(a = 1))
page1_hash <- sha256(paste0("a=",list(a = 1)))

# page2
paste0("b=",list(b = 1))
paste0("prev_hash=",page1_hash,"b=",list(b = 1))
page2_hash <- sha256(paste0("prev_hash=",page1_hash,"b=",list(b = 1)))
page2_hash

1 -> 2

1 -> ( hash of 1, 2 ) -> ( hash of 2, 3 )

1 -> ( hash of 1, 2 ) -> ( hash of ( hash of 1, 2), 3 ) -> (n-th page, )

Recursive data structure.


