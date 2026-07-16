source("/Users/austin/Desktop/Learn_R/Learn-R-Language/function/min_max_normalize.R")
data <- matrix(sample(100, 50)) # simulat gene samples
data <- min_max_normalize(data)

col_lab <- c(rep(1, 10), rep(2, 10), rep(3, 10), rep(4, 10), rep(5, 10))

plot(data, col = col_lab, pch = col_lab, xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scarrer Plots of ",length(data), "Synthetic Samples", sep = ""))

# locator(1) 抓到的座標當作圖例(legend)左上角要放置的位置
# paste("Group", 1:5):產生圖例要顯示的文字標籤
# cex 參數控制整體大小(文字跟符號會一起縮放)
legend(locator(1), paste("Group", 1:5), col = 1:5, pch = 1:5, cex = 0.5)

legend(2, 0.8, "2, 0.8", cex = 0.5)
legend(45, 0.18, "45, 0.18", cex = 0.5)
legend(39, 0.1, "39, 0.1", cex = 0.5)
