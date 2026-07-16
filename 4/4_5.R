# draw different sizes of points

source("/Users/austin/Desktop/Learn_R/Learn-R-Language/function/min_max_normalize.R")
data <- matrix(sample(100, 50)) # simulat gene samples
data <- min_max_normalize(data)

col_lab <- c(rep(1, 10), rep(2, 10), rep(3, 10), rep(4, 10), rep(5, 10))

plot(data, pch = 21, bg = col_lab, cex = col_lab, xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scarrer Plots of ",length(data), "Synthetic Samples", sep = ""))
