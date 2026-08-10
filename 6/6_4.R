## 酵母菌細胞週期資料:第 1 欄 = 基因名稱, 第 2~78 欄 = 表達數據, 第 79 欄 = 細胞週期高峰階段(peak)
data <- read.table("cycleData_peak.txt", sep = "\t", header = T, as.is = T)
# sep="\t"     以 tab 分隔欄位
# header=T     第一列是欄位名稱
# as.is=T      文字欄位維持字串,不自動轉成 factor

#### 缺失值填補(KNN, K 近鄰法)
BiocManager::install("impute")   # 從 Bioconductor 安裝 impute 套件(只需執行一次)
library(impute)                  # 載入套件

data[, 2:78] <- impute.knn(as.matrix(data[, 2:78])) $ data

#### 1. 投影「樣本」####
data.mds1 <- cmdscale(dist(t(data[, 2:78])), 2)
# t(...)         轉置矩陣 → 讓「樣本」變成列(以樣本為分析單位)
# dist(...)      計算兩兩之間的距離(預設為歐氏距離),得到距離矩陣
# cmdscale(d, 2) 古典多維尺度法,把距離矩陣降到 2 維,回傳每個樣本的 2D 座標
row.names(data.mds1)   # 查看各列(樣本)的名稱

## alpha 實驗(第 5~22 欄,共 18 個時間點)##
plot(c(min(data.mds1[, 1]), max(data.mds1[, 1])),
     c(min(data.mds1[, 2]), max(data.mds1[, 2])),
     type = "n", xlab = "1st direction", ylab = "2nd direction")

# 先用兩端點界定 x、y 軸範圍, type="n" 只畫「空白座標軸」不畫點
text(data.mds1[5:22, 1], data.mds1[5:22, 2], 1:18)
# 在第 1、2 維座標位置, 標上編號 1~18(對應 18 個時間點)

## cdc 實驗(第 23~63 欄,共 41 個時間點)##
plot(c(min(data.mds1[,1]), max(data.mds1[,1])),
     c(min(data.mds1[,2]), max(data.mds1[,2])),
     type = "n", xlab = "1st direction", ylab = "2nd direction")
text(data.mds1[23:63, 1], data.mds1[23:63, 2], 1:41)
# 同上,標出 cdc 實驗的 41 個時間點編號


#### 2. 投影「基因」####
data.mds2 <- cmdscale(dist(data[, 2:78]), 2)
# 注意這裡「沒有」轉置 t() → 以「基因」為列(分析單位是基因)
# dist(...) 算基因兩兩距離,cmdscale(,2) 降到 2 維
plot(c(min(data.mds2[,1]), max(data.mds2[,1])),
     c(min(data.mds2[,2]), max(data.mds2[,2])),
     type = "n", xlab = "1st direction", ylab = "2nd direction")

# 依第 79 欄的細胞週期階段標籤,分別把不同階段的基因標上數字與顏色
text(data.mds2[data[,79]=="G1",   1], 
     data.mds2[data[,79]=="G1",   2], 1, col=1)  # G1   階段 → 標「1」,顏色 1(黑)

text(data.mds2[data[,79]=="S",    1], 
     data.mds2[data[,79]=="S",    2], 2, col=2)  # S    階段 → 標「2」,顏色 2(紅)

text(data.mds2[data[,79]=="S/G2", 1], 
     data.mds2[data[,79]=="S/G2", 2], 3, col=3)  # S/G2 階段 → 標「3」,顏色 3(綠)

text(data.mds2[data[,79]=="G2/M", 1], 
     data.mds2[data[,79]=="G2/M", 2], 4, col=4)  # G2/M 階段 → 標「4」,顏色 4(藍)

text(data.mds2[data[,79]=="M/G1", 1], 
     data.mds2[data[,79]=="M/G1", 2], 5, col=5)  # M/G1 階段 → 標「5」,顏色 5(青)



