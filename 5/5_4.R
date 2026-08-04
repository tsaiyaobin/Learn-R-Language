## Golub leukemia data, 1999 (Golub 白血病資料)
BiocManager::install("golubEsets")
library(golubEsets)
data(Golub_Train)

GTrain <- exprs(Golub_Train)         # 取出表現量矩陣（基因 × 樣本）
GTrow <- rownames(GTrain)            # 取出基因名稱 
GTpData <- phenoData(Golub_Train)    # 取出樣本的臨床/表型資料
str(GTpData)  # AnnotatedDataFrame——這是 Bioconductor 用的一種 S4 物件。

# 物件系統                取內部成員    用例子
# S3/ list/data.frame         $         df$欄位名
# S4                          @         物件@slot名
# 用 @ 取出 data 這個 slot
# 用 $ 取出 data 裡的 ALL.AML 這一欄
GTcol <- GTpData @ data $ ALL.AML    # 取出每個樣本是 ALL 還是 AML
GTclass.labels <- as.numeric(GTcol)  # 把 ALL/AML 轉成數字 1/2

str(GTrain)
x <- GTrain[2020, ]
x <- (x - min(x)) / (max(x) - min(x))

plot(x, col = GTclass.labels, pch = GTclass.labels, 
     xlab = "Samples", ylab = "Gene Expression Values")

# 核心概念:比較「差距」和「雜訊」
# t 統計量(t 值)可以想成一個比值:
#     t = 兩組平均值的差距 / 數據本身的波動(雜訊)
# 分子(差距大)→ 兩組平均差很多 → t 值變大
# 分母(波動小)→ 每組數據很集中、不亂跳 → t 值變大
# 所以:
#     |t 值| 很大 → 兩組差異明顯又穩定 → 這個基因「有鑑別力」,能區分兩種病人 
#     |t 值| 接近 0 → 兩組平均差不多,或數據太亂 → 這個基因「沒鑑別力」

t.test.R <- t.test(x[which(GTclass.labels == 1)],
                   x[which(GTclass.labels == 2)])

str(t.test.R)
t.test.R $ p.value
w.test.R <- wilcox.test(x[which(GTclass.labels == 1)],
                        x[which(GTclass.labels == 2)])
str(w.test.R)
w.test.R $ p.value