df <-read.csv(file = "C:/Users/JY Toh/Downloads/GE.csv")

#Assignment 2

GEClose <- df$GEClose[1:250] # extract column
XOMClose <- df$XOMClose[1:250] # extract column
SBUXClose <- df$SBUXClose[1:250] # extract column
MCDClose <- df$MCDClose[1:250] # extract column
AAPLClose <- df$AAPLClose[1:250] # extract column

#daily return
#       t+1...tn       /t...tn
GEret <- log(GEClose [-1] /GEClose[-length(GEClose)])
XOMret <- log(XOMClose [-1] /XOMClose[-length(XOMClose)])
SBUXret <- log(SBUXClose [-1] /SBUXClose[-length(SBUXClose)])
MCDret <- log(MCDClose [-1] /MCDClose[-length(MCDClose)])
AAPLret <- log(AAPLClose [-1] /AAPLClose[-length(AAPLClose)])

M <- cbind(GEret, XOMret, SBUXret, MCDret, AAPLret)

cov(M)


#Assignment 3

#30day return
GEret30 <- log(GEClose [-1:-29] /GEClose[-length(GEClose)+28:-length(GEClose)])
XOMret30 <- log(XOMClose [-1:-29] /XOMClose[-length(XOMClose)+28:-length(XOMClose)])
GEvol <- sd(GEret30)*sqrt(30)
XOMvol <- sd(XOMret30)*sqrt(30)

GEhedgeratio <- GEvol * GEClose
XOMhedgeratio <- XOMvol * XOMClose
