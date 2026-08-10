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


# 1. 畫 2D MDS plot 與 2D PCA plot
# 三種顏色分別代表三類樣本(ALL / MLL / AML),並附上 legend
library(gplots)
color <- c("ALL" = "#EECB27", "MLL" = "#E13239", "AML" = "#1F1762")
col_list <- color[labels]

# PCA
my_data_prcomp <- prcomp(t(my_data), scale = T, retx = T)
pv <- summary(my_data_prcomp)$importance[2, 1:2] * 100 

xlab_txt <- paste0("PC1 (", round(pv[1], 1), "%)")
ylab_txt <- paste0("PC2 (", round(pv[2], 1), "%)")

plot(my_data_prcomp$x[, 1], my_data_prcomp$x[, 2], col = col_list, pch = 17,
     xlab = xlab_txt, ylab = ylab_txt)

legend("topright", legend = names(color), col = color[names(color)], pch = 17, cex = 0.8)

# MDS
my_data_mds <- cmdscale(dist(t(my_data)), 2)

plot(my_data_mds[, 1], my_data_mds[, 2], col = col_list, pch = 16,
     xlab = "MDS1", ylab = "MDS2")

legend("topright", legend = names(color), col = color[names(color)], pch = 16, cex = 0.8)


# 2. 用同樣的 30 個 DE genes,畫一張 heatmap + dendrogram
#   • 條件:Average linkage + Euclidean distance

my_dist <- function(x) {
    dist(x, method = "euclidean")
}
my_hclust <- function(d) {
    hclust(d, method = "average")
}

# heatmap.2(...., distfun = my.dist, hclustfun = my.hclust, ....)

heatmap.2(my_data,                       # ← 改成 my_data(底線)
          Rowv = TRUE, Colv = TRUE,
          dendrogram = "both",
          distfun  = my_dist,
          hclustfun = my_hclust,
          scale = "row",
          trace = "none",
          ColSideColors = col_list,      # 樣本上方加一條 ALL/MLL/AML 顏色條
          margins = c(6, 8),             # (欄邊界, 列邊界),避免標籤被切
          cexRow = 0.6,                  # 30 個基因名縮小才放得下
          cexCol = 0.7,
          xlab = "Samples", ylab = "Genes")

legend("topright", legend = names(color), fill = color,
       border = NA, bty = "n", cex = 0.8)
















