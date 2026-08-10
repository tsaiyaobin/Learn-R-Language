# KNN & PCA(續) : 基因投影結果

## 酵母菌細胞週期資料:第 1 欄 = 基因名稱,第 2~78 欄 = 表達數據,第 79 欄 = 細胞週期高峰階段(peak)
data <- read.table("cycleData_peak.txt", sep = "\t", header = T, as.is = T)
# sep="\t"     以 tab 分隔欄位
# header=T     第一列是欄位名稱
# as.is=T      文字欄位維持字串,不自動轉成 factor

#### 缺失值填補(KNN, K 近鄰法)
BiocManager::install("impute")   # 從 Bioconductor 安裝 impute 套件(只需執行一次)
library(impute)                  # 載入套件


data[, 2:78] <- impute.knn(as.matrix(data[, 2:78])) $ data

#### PCA:投影「基因」
data.prcomp2 <- prcomp(data[, 2:78], scale = T, retx =  T)
# 注意這裡「沒有」轉置 t() → 以「基因」為列(分析單位是基因)
# scale=T 標準化; retx=T 回傳投影座標
summary(data.prcomp2)   # 各主成分的變異比例
str(data.prcomp2)       # 物件內部結構

# 先畫出空白座標軸(範圍取自所有基因在前兩個主成分的最大最小值)
plot(c(min(data.prcomp2 $ x[, 1]), max(data.prcomp2 $ x[, 1])),
       c(min(data.prcomp2 $ x[, 2]), max(data.prcomp2 $ x[, 2])),
       type = "n", xlab = "1st PC", ylab = "2nd PC")

# 依第 79 欄的細胞週期階段標籤,分別把不同階段的基因標上數字與顏色
text(data.prcomp2$x[data[, 79] == "G1", 1], 
     data.prcomp2$x[data[, 79] == "G1", 2], 1, col = 1)  # G1   階段 → 標「1」,顏色 1(黑)

text(data.prcomp2$x[data[, 79] == "S", 1], 
     data.prcomp2$x[data[, 79] == "S", 2], 2, col = 2)  # S    階段 → 標「2」,顏色 2(紅)

text(data.prcomp2$x[data[, 79] == "S/G2", 1], 
     data.prcomp2$x[data[, 79] == "S/G2", 2], 3, col = 3)  # S/G2 階段 → 標「3」,顏色 3(綠)

text(data.prcomp2$x[data[, 79] == "G2/M", 1], 
     data.prcomp2$x[data[, 79] == "G2/M", 2], 4, col = 4)  # G2/M 階段 → 標「4」,顏色 4(藍)

text(data.prcomp2$x[data[, 79] == "M/G1", 1], 
     data.prcomp2$x[data[, 79] == "M/G1", 2], 5, col = 5)  # M/G1 階段 → 標「5」,顏色 5(青)








