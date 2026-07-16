source("/Users/austin/Desktop/Learn_R/Learn-R-Language/function/min_max_normalize.R")
data <- matrix(sample(100, 50)) # simulat gene samples
data <- min_max_normalize(data)
plot(data, xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scarrer Plots of ",length(data), "Synthetic Samples", sep = ""))

# color
# col:點的顏色(邊框顏色)。R 內建數字對應色票:1=黑、2=紅、3=綠、4=藍、5=青、6=洋紅、7=黃、8=灰... 這裡 col = 1 是黑色
# pch:點的形狀代碼(plotting character)。pch = 21 是「實心圓圈,邊框和內部填色可以分開設定」。
# pch 21~25 這幾種形狀(圓形、方形、菱形、三角形等)才支援 bg 填色參數,其餘 pch(0~20)只有單一 col 決定顏色。
points(data[1:10], col = 1, pch = 21, bg = 2)
points(x = 11:20, y = data[11:20], col = 1, pch = 21, bg = 3)

# points(data[11:20], ...) 只給了一個向量,R 會把它當成 y 值,x 座標自動用 seq_along() 生成,也就是 1, 2, 3...10 —— 
# 而不是你要的 11~20 !結果這 10 個綠色圓點會畫到 x=1~10 的位置,跟第一組樣本重疊,不是你原本 11~20 的位置。