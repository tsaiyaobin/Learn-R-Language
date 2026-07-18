path = "/Users/austin/Desktop/Learn_R/Learn-R-Language/data/"
data_SRBCT <- read.delim(paste(path, "SRBCT_train.txt", sep = ""))
data1 <- as.matrix(data_SRBCT[ , -c(1:2)])
name1 <- data_SRBCT[,1]

# Normalize data by each row (let values b/w 0~1)
source("/Users/austin/Desktop/Learn_R/Learn-R-Language/function/min_max_normalize.R")
data1_norm <- t(apply(data1, 1, min_max_normalize))

# – Perform scatter plots for Image ID “770394”, “814260”, and “491565”

plot_data1 <- rbind(data1_norm[which(name1 == 770394), ],
                    data1_norm[which(name1 == 814260), ], 
                    data1_norm[which(name1 == 491565), ])

plot(plot_data1[1, ], type = "n", xlab = "Gene", ylab = "Normalized Expression")

for (i in 1:3){
    plot(plot_data1[i, ], col = i+i, pch = i+i, cex = 0.8, xlab = "Gene", ylab = "Normalized Expression")
}

# – Perform scatter plots for Image ID “770394” vs “236282”, and “812105” vs “784224”

plot_data2 <- rbind(data1_norm[which(name1 == 770394), ],
                    data1_norm[which(name1 == 236282), ])

plot_data3 <- rbind(data1_norm[which(name1 == 812105), ],
                    data1_norm[which(name1 == 784224), ])


plot(plot_data2[1, ], type = "n", xlab = "Gene", ylab = "Normalized Expression")
for (i in 1:2){
    points(plot_data2[i, ], col = i+i, pch = i+i, cex = 0.8)
}
legend(locator(1), c("770394", "236282"), col = c(2, 4),  pch = c(2, 4), cex = 0.5)


plot(plot_data3[1, ], type = "n", xlab = "Gene", ylab = "Normalized Expression")
for (i in 1:2){
    points(plot_data3[i, ], col = i+i, pch = i+i, cex = 0.8)
}
legend(locator(1), c("812105", "784224"), col = c(2, 4),  pch = c(2, 4), cex = 0.5)

# – Diff. colors, symbols & legends for samples in diff. categories





