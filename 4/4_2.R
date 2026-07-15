# import min_max_normalize.R
source("/Users/austin/Desktop/Learn_R/Learn-R-Language/function/min_max_normalize.R")
data <- matrix(sample(100, 50)) # simulat gene samples
data <- min_max_normalize(data)
plot(data, xlab = "Samples", ylab = "Gene Expression values",
        main = paste("Scarrer Plots of ",length(data), "Synthetic Samples", sep = ""))
graphics.off()   # 關閉所有圖形裝置,重置

# plot() 認得的矩陣形狀只有兩種:
## 1 欄(ncol = 1) : 當成一組 y 值,x 軸自動用 1, 2, 3...(index)。
## 2 欄(ncol = 2) : 第一欄當 x, 第二欄當 y, 畫成一組 (x, y) 點。

    