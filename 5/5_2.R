# Scatter Plot
data <- read.delim("a1_expression.txt", row.names=1)

# 設定圖為兩列一行
par(mfrow = c(2,1)) ## par: specify graph parameters before figure is plotted
plot(data[, 1], data[, 2], xlab = "1521m99hpp_av06", ylab = "1521n99hpp_av06")

# 第一個參數 c(0, 8000) — 這條線兩個端點的 x 座標
# 第二個參數 c(0, 8000) — 這條線兩個端點的 y 座標
lines(c(0, 8000), c(0, 8000), col = 2) ## col (color of the line)

# lm() : fit a linear model
# data[,2] ~ data[,1] — 這是 R 的公式（formula）寫法，波浪號 ~ 讀作「被…解釋」或「對應到」
# ~ 左邊是應變數（反應變數，y）：第 2 欄
# ~ 右邊是自變數（解釋變數，x）：第 1 欄
# 所以整句的意思是：用第 1 欄去預測第 2 欄，配適出一條直線 y = 截距 + 斜率 ×
## 這正好對應到你前面畫的散佈圖（x 是第 1 欄、y 是第 2 欄），lm 在幫你找出最能貫穿這些點的那條「最佳配適直線」
##（用最小平方法，讓所有點到線的垂直距離平方和最小）。
a <- lm(data[,2] ~ data[,1]) 

text(2000, 7000, paste("y=", round(a[[1]][1], 3), "+", 
                       round(a[[1]][2], 3), "x", sep=" "))

title("scatter plot of array 'm' and 'n'")

### log2 transformation ###
plot(log2(data[,1]), log2(data[,2]),
     xlab="1521m99hpp_av06", ylab="1521n99hpp_av06")

lines(c(0, 13), c(0, 13), col=2)

a <- lm(log2(data[,2])~log2(data[,1]))

text(2, 11, paste("y=", round(a[[1]][1], 3), "+", round(a[[1]][2], 3), "x", sep=""))

title("log-transformed scatter plot of array 'm' and 'n'")