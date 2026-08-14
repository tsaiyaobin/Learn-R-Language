library(tidyr)
library(dplyr)
library("ggplot2")
library(ggrepel) 
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


# Normalize data by each row(0~1)
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

# PCA
my_data_prcomp <- prcomp(t(my_data), scale = T, retx = T)
pv <- summary(my_data_prcomp)$importance[2, 1:2] * 100 

xlab_txt <- paste0("PC1 (", round(pv[1], 1), "%)")
ylab_txt <- paste0("PC2 (", round(pv[2], 1), "%)")

# ── 1. 準備基因的分組（順序要和 selected_genes 一致：ALL→MLL→AML）──
gene_group <- rep(c("ALL", "MLL", "AML"), each = 10)

# ── 2. 矩陣轉 long format，並加上輔助欄位 ──
plot_df <- as.data.frame(my_data) %>%
    mutate(
        gene       = rownames(my_data),
        gene_group = factor(gene_group, levels = c("ALL", "MLL", "AML")),
        gene_key   = factor(seq_len(nrow(my_data)))   # 用列順序當唯一 key，避免基因名稱重複造成合併
    ) %>%
    pivot_longer(
        cols = -c(gene, gene_group, gene_key),
        names_to  = "sample",
        values_to = "expression"
    ) %>%
    mutate(
        sample_class = factor(sub("_.*", "", sample),
                              levels = c("ALL", "MLL", "AML"))
    )

# y 軸要顯示「基因名稱」，但排序用 gene_key，所以做一個對照表
gene_labels <- plot_df %>% distinct(gene_key, gene) %>% arrange(gene_key)

# ── 3. 畫圖 ──
ggplot(plot_df, aes(x = sample, y = gene_key, fill = expression)) +
    geom_tile() +
    facet_grid(gene_group ~ sample_class,
               scales = "free", space = "free") +   # 關鍵：讓每個 panel 只放自己的基因/樣本
    scale_fill_viridis_c(option = "inferno",
                         limits = c(0, 1),
                         name = "Normalized\nexpression") +
    scale_y_discrete(limits = rev,                   # 反轉，讓第一個基因排在最上面
                     labels = setNames(gene_labels$gene, gene_labels$gene_key)) +
    labs(title    = "Top One-vs-Rest Differentially Expressed Genes",
         subtitle = "Each gene was normalized to 0–1; 10 genes selected per cancer class",
         x = NULL, y = NULL) +
    theme_minimal(base_size = 9) +
    theme(
        axis.text.x      = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 5),# 字從橫的變直的
        axis.ticks.x     = element_blank(),
        panel.grid       = element_blank(),
        panel.spacing    = unit(2, "pt"),
        strip.background = element_rect(fill = "grey85", color = NA),
        plot.title = element_text(face = "bold")
    )


# ========== Volcano plot：ALL vs MLL（沿用已定義的 ALL_data / MLL_data）==========

# 逐 gene 計算 mean difference 與 p-value（風格比照你的 count_t）
mean_diff <- numeric(nrow(ALL_data))
p_value   <- numeric(nrow(ALL_data))
for(i in 1:nrow(ALL_data)){
    a <- ALL_data[i, ]
    b <- MLL_data[i, ]
    tt <- tryCatch(t.test(a, b), error = function(e) NULL)  # 變異數為0時不中斷
    mean_diff[i] <- mean(a) - mean(b)
    p_value[i]   <- if(is.null(tt)) NA else tt$p.value
}

# BH 校正
fdr <- p.adjust(p_value, method = "BH")

# 整理成 data.frame（gene 標籤用 data 第2欄，位置和 ALL_data 的列一一對應）
volcano_df <- data.frame(
    gene          = data[, 2],
    mean_diff     = mean_diff,
    fdr           = fdr,
    neg_log10_fdr = -log10(fdr)
)
volcano_df <- volcano_df[!is.na(volcano_df$fdr), ]

# 先看 x 軸範圍再決定門檻（你的資料是 0~1 正規化，差異會落在 -1~1）
range(volcano_df$mean_diff)

# 分類（紅 / 藍 / 灰）
diff_cut <- 0.3     # ← 依上面 range 調整，正規化資料通常 0.2~0.4 之間
fdr_cut  <- 0.05

volcano_df$category <- "Not significant"
volcano_df$category[volcano_df$fdr < fdr_cut & volcano_df$mean_diff >  diff_cut] <- "Higher in ALL"
volcano_df$category[volcano_df$fdr < fdr_cut & volcano_df$mean_diff < -diff_cut] <- "Higher in MLL"
volcano_df$category <- factor(volcano_df$category,
                              levels = c("Higher in ALL", "Higher in MLL", "Not significant"))

# 每方向挑最顯著的幾個做標註
top_label <- volcano_df %>%
    filter(category != "Not significant") %>%
    arrange(fdr) %>%
    group_by(category) %>%
    slice_head(n = 8) %>%
    ungroup()

# 繪圖
ggplot(volcano_df, aes(x = mean_diff, y = neg_log10_fdr, color = category)) +
    geom_point(size = 1.3, alpha = 0.8) +
    geom_vline(xintercept = c(-diff_cut, diff_cut), linetype = "dashed", color = "grey40") +
    geom_hline(yintercept = -log10(fdr_cut),        linetype = "dashed", color = "grey40") +
    geom_text_repel(data = top_label, aes(label = gene),
                    size = 2.5, max.overlaps = Inf, show.legend = FALSE) +
    scale_color_manual(values = c("Higher in ALL"   = "#d73027",
                                  "Higher in MLL"   = "#4575b4",
                                  "Not significant" = "grey70")) +
    labs(title    = "Exploratory Differential Expression: ALL vs MLL",
         subtitle = "Welch t-test with Benjamini–Hochberg correction",
         x = "Mean expression difference: ALL − MLL",
         y = expression(-log[10](FDR)),
         color = NULL) +
    theme_minimal(base_size = 11) +
    theme(legend.position  = "top",
          panel.grid.minor = element_blank(),
          plot.title = element_text(face = "bold"))
# ==============================================================================
# prcomp$x 就是每個樣本在各主成分上的座標
pca_df <- data.frame(
    sample = rownames(my_data_prcomp$x),          # 樣本名（來自 my_data 的欄名）
    PC1    = my_data_prcomp$x[, 1],
    PC2    = my_data_prcomp$x[, 2]
)

# 從樣本名取癌別當顏色分組（和你前面 labels 的邏輯一模一樣）
pca_df$class <- sub("_.*", "", pca_df$sample)
pca_df$class <- factor(pca_df$class)
ggplot(pca_df, aes(x = PC1, y = PC2, color = class)) +
    stat_ellipse(aes(fill = class),               # 外圈的半透明橢圓
                 geom = "polygon", alpha = 0.15,
                 color = NA, type = "norm", level = 0.9) +
    geom_point(size = 2.5) +
    geom_text_repel(aes(label = sample),          # 樣本標籤
                    size = 2.5, max.overlaps = Inf,
                    show.legend = FALSE) +
    labs(title    = "PCA Based on Selected Class-Specific Markers",
         subtitle = paste(nrow(my_data), "unique genes selected from one-vs-rest comparisons"),
         x = xlab_txt, y = ylab_txt,               # 用你已算好的軸標籤
         color = "Cancer class", fill = "Cancer class") +
    theme_minimal(base_size = 11) +
    theme(panel.grid.minor = element_blank(),
          plot.title = element_text(face = "bold"))