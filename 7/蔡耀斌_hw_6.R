# 安裝套件
BiocManager::install("ggplot2")
install.packages("tidyr")
install.packages("dplyr")

# 讀檔
data_SRBCT <- read.delim("SRBCT_train.txt")
data1 <- as.matrix(data_SRBCT[ , -c(1:2)])

# 提取 Image_id
Image_id <- data_SRBCT[,1]
Image_id

# 正規化
min_max_norm <- function(x){
    (x - min(x)) / (max(x) - min(x))
}

data1_norm <- t(apply(data1, 1, min_max_norm))

# 取得所有欄位名稱
cols <- colnames(data1)
labels <- sub("\\..*", "", cols)
table(labels)


# 幫四種類別設定顏色跟點類型
categories = c("EWS", "BL", "NB", "RMS")
color <- c("EWS" = "blue", "BL" = "green", "NB" = "red", "RMS" = "black") 
pch <- c("EWS" = 15, "BL" = 16, "NB" = 17, "RMS" = 18) 

# 套用到每一欄
col_color <- color[labels]
col_pch <- pch[labels]
col_color
col_pch

## 準備想要視覺化的資料
## 從 data1_norm 提取 Image_id = 770394、814260、491565 那列的值
plot_data1 <- rbind(data1_norm[which(Image_id == 770394), ],
                    data1_norm[which(Image_id == 814260), ], 
                    data1_norm[which(Image_id == 491565), ])


## 標題列
title_lst1 <- c("Image ID : 770394", "Image ID : 814260", "Image ID : 491565")

# 匯入套件
library(tidyr)
library(dplyr)
library("ggplot2")

# 請用 ggplot2 函式重做以下三組圖:
# 1. Scatter plot for Image ID 770394(HW3)
for (i in 1:3){
    d <- data.frame(
        sample   = seq_len(ncol(plot_data1)),
        value    = plot_data1[i, ],      
        category = labels
    )
    
    p <- ggplot(d, aes(x = sample, y = value,
                       color = category, shape = category)) +
        geom_point(size = 2) +
        scale_color_manual(values = color) +
        scale_shape_manual(values = pch) +
        labs(title = title_lst1[i], x = "Sample index",
             y = "Normalized expression") +
        ylim(0, 1) +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5)) 
    
    print(p)   # 迴圈裡一定要 print 才會畫出來
}

# ------------------------------------------------------------------------------
# 2. Scatter plot 770394 vs 236282(HW3)
Image_id_770394 <- data1_norm[which(Image_id == 770394), ] 
Image_id_236282 <- data1_norm[which(Image_id == 236282), ]

d <- data.frame(
    x        = Image_id_770394,   
    y        = Image_id_236282,   
    category = labels             
)

p <- ggplot(d, aes(x = x, y = y,
                   color = category, shape = category)) +
    geom_point(size = 2) +
    scale_color_manual(values = color) +
    scale_shape_manual(values = pch) +
    labs(title = "Image ID : 770394 vs 236282",
         x = "770394", y = "236282") +
    xlim(0, 1) + ylim(0, 1) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))

print(p)

# ------------------------------------------------------------------------------
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

# 3. 2D MDS & PCA plots(HW5)

color <- c("ALL" = "#EECB27", "MLL" = "#E13239", "AML" = "#1F1762")
pch <- c("ALL" = 16, "MLL" = 17, "AML" = 18)
col_list <- color[labels]

# PCA
my_data_prcomp <- prcomp(t(my_data), scale = T, retx = T)
pv <- summary(my_data_prcomp)$importance[2, 1:2] * 100 

xlab_txt <- paste0("PC1 (", round(pv[1], 1), "%)")
ylab_txt <- paste0("PC2 (", round(pv[2], 1), "%)")

d <- data.frame(
    x        = my_data_prcomp$x[, 1],   
    y        = my_data_prcomp$x[, 2],   
    category = labels             
)


p <- ggplot(d, aes(x = x, y = y,
                   color = category, shape = category)) +
    geom_point(size = 2) +
    scale_color_manual(values = color) +
    scale_shape_manual(values = pch) +
    labs(title = "PCS",
         x = xlab_txt, y = ylab_txt) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))

print(p)

# MDS
my_data_mds <- cmdscale(dist(t(my_data)), k = 2, eig = TRUE)

# 特徵值 → 每個維度解釋的比例
eig <- my_data_mds$eig
pv_mds <- eig[1:2] / sum(eig[eig > 0]) * 100   # 只用正特徵值當分母

xlab_mds <- paste0("MDS1 (", round(pv_mds[1], 1), "%)")
ylab_mds <- paste0("MDS2 (", round(pv_mds[2], 1), "%)")

d <- data.frame(
    x        = my_data_mds$points[, 1],   
    y        = my_data_mds$points[, 2],   
    category = labels             
)

p <- ggplot(d, aes(x = x, y = y,
                   color = category, shape = category)) +
    geom_point(size = 2) +
    scale_color_manual(values = color) +
    scale_shape_manual(values = pch) +
    labs(title = "PCS",
         x = xlab_mds, y = ylab_mds) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))

print(p)












