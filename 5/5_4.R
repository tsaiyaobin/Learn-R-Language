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


t.test.R <- t.test(x[which(GTclass.labels == 1)],
                   x[which(GTclass.labels == 2)])

str(t.test.R)
t.test.R $ p.value
w.test.R <- wilcox.test(x[which(GTclass.labels == 1)],
                        x[which(GTclass.labels == 2)])
str(w.test.R)
w.test.R $ p.value