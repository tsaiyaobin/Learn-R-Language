min_max_normalize <- function(x){
   (x - min(x)) / (max(x) - min(x)) 
}