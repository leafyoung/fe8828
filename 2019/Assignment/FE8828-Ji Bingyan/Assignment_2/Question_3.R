library(ggplot2)
set.seed(123)
village <- function(){
    boys <- 0
    girls <- 0
    for (i in 1:10){
        first_child <- sample(1:2, 1)
        if (first_child == 1){
            girls <- girls + 1
        }else{
            boys <- boys + 1
        } # count the first child of a family
        family <- first_child
        is_girl <- ifelse(family[1] == 1, TRUE, FALSE)
        while(is_girl){ 
            new_child <- sample(1:2, 1)
            if (new_child == 1){
                girls <- girls + 1
            }else{
                boys <- boys + 1
            }
            family <- c(family, new_child)
            is_girl <- ifelse(new_child == 1, TRUE, FALSE)
        } # count the total number of boys and girls in a family
    } # accumulate the total number of boys and girls in 10 families
    girls/boys
}

simulation <- data.frame(girls_to_boys_ratio = numeric(1000))
for (i in 1:1000){
    simulation$girls_to_boys_ratio[i] <- village()
}

ggplot(simulation, aes(girls_to_boys_ratio)) + geom_density(kernel = "gaussian", color = "green", fill = "light green") +
    geom_vline(aes(xintercept = mean(simulation$girls_to_boys_ratio))) + 
    annotate("rect", xmin = 1.95, xmax = 3.05, ymin = 0.7, ymax = 0.8, fill = "springgreen1", colour = "tan") +
    annotate(geom = "text", x = 2.5, y = 0.75, label = paste0("Average Girl/Boy Ratio = ", mean(simulation$girls_to_boys_ratio))) +
    annotate("rect", xmin = 1.95, xmax = 3.05, ymin = 0.55, ymax = 0.65, fill = "springgreen2", colour = "tan") +
    annotate(geom = "text", x = 2.5, y = 0.6, label = paste0("Standard Deviation = ", round(sd(simulation$girls_to_boys_ratio), 4))) +
    annotate("rect", xmin = 2.1, xmax = 2.9, ymin = 0.4, ymax = 0.5, fill = "springgreen3", colour = "tan") +
    annotate(geom = "text", x = 2.5, y = 0.45, label = paste0("Min = ", min(simulation$girls_to_boys_ratio), "; Max = ", max(simulation$girls_to_boys_ratio))) +
    labs(x = "Girls/Boys Ratio", y = "Density", title = "Density Plot")
