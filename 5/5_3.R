# MA Plot

data <- read.delim("a1_expression.txt", row.names=1)

# A（橫軸）兩樣本 log 值的平均這個基因表現量多高？（強度）
# M（縱軸）兩樣本 log 值的相減兩樣本之間差多少？（差異／fold change）
A <- (log2(data[, 1]) + log2(data[, 2])) / 2

M <- (log2(data[, 1]) - log2(data[, 2]))

plot( c(0, 13), c(-6, 6), type = "n", xlab = "A", ylab = "M") ### type (type of plot)

### pch (types of points plotted)
points(A, M, pch = ".") 

lines(c(0, 13), c(0,0), col=2)

title("M-A plot of all genes in array 'm' and 'n'")

### filter out genes with average intensity less than 100) ###
row.average <- apply(data, 1, mean)

# row.average >= 100 產生一串 TRUE/FALSE
# (1:nrow(data))[...] 用這串邏輯值把符合條件的列編號挑出來，存到 index
index <- (1:nrow(data))[row.average >= 100]

new.data <- data[index, ]

A <- (log2(new.data[, 1]) + log2(new.data[, 2])) / 2

M <- (log2(new.data[, 1]) - log2(new.data[, 2]))

plot( c(min(A), max(A)), c(min(M), max(M)), type = "n", xlab = "A", ylab = "M")

points(A, M, pch = ".")

lines(c(0, 13), c(0, 0), col = 2)

title("M-A plot of filtered genes in array 'm' and 'n'")
