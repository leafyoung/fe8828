library(ggplot2)
ggplot (mtcars)  +  
  geom_text( aes ( mpg , wt , colour = factor ( cyl )), 
             label =  "CC" , 
             family =  "Symbols" , 
             size =  7)

ggplot (mtcars)  +  
  geom_point( aes ( mpg , wt , colour = factor ( cyl )), 
             size =  14, shape="square")
