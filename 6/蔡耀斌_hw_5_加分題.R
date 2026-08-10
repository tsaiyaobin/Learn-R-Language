# HW4 的 30 個 DE genes
MLL_train <- read.delim("MLL_train.txt")
data <- MLL_train[-c(1:49), ]

# 正規化
min_max_norm <- function(x){
    (x - min(x)) / (max(x) - min(x))
}

# 對每一 row 計算 t-test
count_t <- function(group_a, group_b){
    t_value <- numeric(nrow(group_a))
    for(i in 1:nrow(group_a)){
        t_value[[i]] <- t.test(group_a[i, ], group_b[i, ])$statistic
    }
    return(t_value) 
}

# 2. Normalize data by each row(0~1)
data_norm <- t(apply(data[, 3:ncol(data)], 1, min_max_norm))

col_name <- colnames(data_norm)
labels <- sub("_.*", "", col_name)
table(labels)

# ALL
ALL_data <- data_norm[, which(labels == "ALL")]          # 只有 ALL 的欄位資料
ALL_others_data <- data_norm[, -which(labels == "ALL")]  # 除了 ALL 的欄位資料

ALL_mean <- apply(ALL_data, 1, mean)                      # 計算只有 ALL 欄位的每一列平均值
ALL_others_data_mean <- apply(ALL_others_data, 1, mean)   # 計算除了 ALL 欄位的每一列平均值

# 只保留 mean(該組) > mean(其他)
ALL_data_filter <- ALL_data[which(ALL_mean > ALL_others_data_mean), ] 
ALL_others_data_filter <- ALL_others_data[which(ALL_mean > ALL_others_data_mean), ]

# 計算t-test
ALL_t <- count_t(ALL_data_filter, ALL_others_data_filter)

# 由大到小排列
ALL_t_sort <- order(ALL_t, decreasing = TRUE)

# 透過 order 回傳的前十個索引找到在 ALL_data_filter 的 gene
ALL_top_10_genes <- ALL_data_filter[ALL_t_sort[1:10], ]
ALL_top_10_genes

## 以下同理

# MLL
MLL_data <- data_norm[, which(labels == "MLL")]
MLL_others_data <- data_norm[, -which(labels == "MLL")]

MLL_mean <- apply(MLL_data, 1, mean)                      # 計算只有 MLL 欄位的每一列平均值
MLL_others_data_mean <- apply(MLL_others_data, 1, mean)   # 計算除了 MLL 欄位的每一列平均值

# 只保留 mean(該組) > mean(其他)
MLL_data_filter <- MLL_data[which(MLL_mean > MLL_others_data_mean), ] 
MLL_others_data_filter <- MLL_others_data[which(MLL_mean > MLL_others_data_mean), ]

MLL_t <- count_t(MLL_data_filter, MLL_others_data_filter)
MLL_t_sort <- order(MLL_t, decreasing = TRUE)

MLL_top_10_genes <- MLL_data_filter[MLL_t_sort[1:10], ]
MLL_top_10_genes

# AML
AML_data <- data_norm[, which(labels == "AML")]
AML_others_data <- data_norm[, -which(labels == "AML")]

AML_mean <- apply(AML_data, 1, mean)                      # 計算只有 MLL 欄位的每一列平均值
AML_others_data_mean <- apply(AML_others_data, 1, mean)   # 計算除了 MLL 欄位的每一列平均值

# 只保留 mean(該組) > mean(其他)
AML_data_filter <- AML_data[which(AML_mean > AML_others_data_mean), ] 
AML_others_data_filter <- AML_others_data[which(AML_mean > AML_others_data_mean), ]

AML_t <- count_t(AML_data_filter, AML_others_data_filter)
AML_t_sort <- order(AML_t, decreasing = TRUE)

AML_top_10_genes <- AML_data_filter[AML_t_sort[1:10], ]
AML_top_10_genes

# 將三組各 10 個 → 合併成 30 selected genes
selected_genes <- c(rownames(ALL_top_10_genes),
                    rownames(MLL_top_10_genes),
                    rownames(AML_top_10_genes))

my_data <- data_norm[selected_genes, ]

# ⭐ ⭐ ⭐ 加分題 A
# 1. 用 limma 依 ALL / MLL / AML 三組挑出差異表現基因, 每組各取 top 10、條件為該 target class 的平
# 均表現較高 → 合併成 30 個基因
# 2. 用這 30 個基因做一張 2D UMAP(非線性降維), 用三種不同顏色分別代表 ALL / MLL / AML

# 安裝套件
if (!require("BiocManager")) install.packages("BiocManager")
BiocManager::install("limma")
install.packages("umap")
library("limma")

# 讀檔
MLL_train <- read.delim("MLL_train.txt")
data <- MLL_train[-c(1:49), ]

# 正規化
min_max_norm <- function(x){
    (x - min(x)) / (max(x) - min(x))
}

# 2. Normalize data by each row(0~1)
data_norm <- t(apply(data[, 3:ncol(data)], 1, min_max_norm))

col_name <- colnames(data_norm)
labels <- sub("_.*", "", col_name)
table(labels)

# 前提:
#   expr  = 表現矩陣 (rows = genes, cols = samples)
#   group = factor,levels 為 "ALL", "MLL", "AML",長度 = 樣本數
group <- factor(group, levels = c("ALL", "MLL", "AML"))

# 1. design matrix(不含 intercept,直接用組平均)
design <- model.matrix(~ 0 + group)
design
colnames(design) <- levels(group)

# 2. one-vs-other contrasts:各組 vs 其餘兩組平均
cont <- makeContrasts(
    ALL_vs_other = ALL - (MLL + AML) / 2,
    MLL_vs_other = MLL - (ALL + AML) / 2,
    AML_vs_other = AML - (ALL + MLL) / 2,
    levels = design
)

# 3. 擬合
fit  <- lmFit(data_norm, design)
fit2 <- eBayes(contrasts.fit(fit, cont))

# 4. 每組取 top 10,條件:target class 平均較高 → logFC > 0
pick_top <- function(fit, coef, n = 10) {
    tt <- topTable(fit, coef = coef, number = Inf, sort.by = "P")
    tt <- tt[tt$logFC > 0, ]          # 只留該組較高的基因
    head(rownames(tt), n)
}

top_ALL <- pick_top(fit2, "ALL_vs_other")
top_MLL <- pick_top(fit2, "MLL_vs_other")
top_AML <- pick_top(fit2, "AML_vs_other")

# 5. 合併成 30 個
selected_genes <- c(top_ALL, top_MLL, top_AML)
data_norm[selected_genes, ]
length(selected_genes)   # 30

install.packages("umap")   # 只需裝一次
library(umap)

# expr = 你的表現矩陣 (rows = genes, cols = samples)
# UMAP 預設「一列 = 一個樣本」,但你的矩陣是「一列 = 一個基因」
# 所以要先轉置 t(),讓每一列變成一個病人
mat <- t(data_norm)

# UMAP 有隨機性,固定種子才能重現同一張圖
set.seed(777)               
um <- umap(mat)

# 結果的座標放在 um$layout,兩欄分別是 X、Y
coords <- um$layout
head(coords)

color <- c("ALL" = "#EECB27", "MLL" = "#E13239", "AML" = "#1F1762")
col_list <- color[labels]

plot(coords, col = col_list, pch = 16, xlab = "UMAP1", ylab = "UMAP2")

# bty = "n" : 不畫外框
legend("topright", legend = names(color), col = color[names(color)],
       pch = 16, bty = "n", cex = 0.8)




# ⭐ 加分題 B — 隨機基因對照

set.seed(777) # 固定隨機種子(必做)
idx_rand <- sample(nrow(data_norm), 30) # mat = 全部基因的表現矩陣(同 HW4 的命名)
mat_rand <- data_norm[idx_rand, ] # 隨機 30 個基因

pca <- prcomp(t(mat_rand))
pv <- summary(pca)$importance[2, 1:2] * 100 # PC1, PC2 的百分比

xlab_txt <- paste0("PC1 (", round(pv[1], 1), "%)")
ylab_txt <- paste0("PC2 (", round(pv[2], 1), "%)")

plot(pca$x[, 1], pca$x[, 2], col = col_list, pch = 17,
     xlab = xlab_txt, ylab = ylab_txt)

legend("topright", legend = names(color), col = color[names(color)], pch = 17, cex = 0.8)


# ⭐ 加分題 C
# 把 heatmap 的 linkage 從 average 改成 complete(distance 維持 euclidean),另外畫一張。
# 接著用 cutree() 把樹切成 3 群,並做兩組對照:
# 1. linkage 對照:average vs complete(都用 HW4 挑選的 30 個基因)—— 用 table() 交叉表判讀有
#    幾個樣本被分到不同群
# 2. 基因來源對照:同樣的 average linkage,改用共用的 mat_rand(隨機 30 個基因)再切 3 群 —— 和
#    挑選版比,分群結果變得多不一樣?

# 1) linkage 對照(挑選版的 30 個基因)
d <- dist(t(my_data), method = "euclidean")
c1 <- cutree(hclust(d, method = "average"), k = 3)
c2 <- cutree(hclust(d, method = "complete"), k = 3)
table(c1, c2) # 對角線以外就是分法不同的樣本
names(c1)[c1 != c2] # 注意:群編號本身可能只是換號,需先對齊再比

# 2) 基因來源對照(隨機版,linkage 固定 average)
d_rand <- dist(t(mat_rand), method = "euclidean")
c_rand <- cutree(hclust(d_rand, method = "average"), k = 3)


table(c1, labels) # 挑選版 vs 真實標籤
table(c_rand, labels) # 隨機版 vs 真實標籤











