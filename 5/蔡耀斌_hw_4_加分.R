# 1. Remove genes with name starting AFFX...(控制探針,共 49 個)
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

# 3. Find top 10 differentially expressed genes using t-test, 每組一次(該組 vs 其他),
#    條件:mean(該組) > mean(其他)
#    • 三組各 10 個 → 合併成 30 selected genes
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

BiocManager::install("e1071")
library("e1071")
#------------------------------ 以上主題目 -------------------------------------
# ⭐⭐⭐ 加分題 A(最難)
# 三輪跑完後請回報:
# 1. 每個 fold 中 ALL / MLL / AML 各有幾個樣本
# 2. 每一個 fold 的 confusion matrix
# 3. 整體(overall)的 confusion matrix
# 📌 這裡的 confusion matrix 同樣是三類別(3-class)的 3×3 表(ALL / MLL / AML)

fold <- data_norm[selected_genes, ]
# 依樣本的類別標籤 (ALL / MLL / AML) 分層把樣本切成 3 folds, 讓每個 fold 都包含三個類別的樣本,
# 且盡可能維持原本的類別比例。
# ALL 7/7/6、MLL 6/6/5、AML 7/7/6
ALL_fold1 <- fold[, 1:7]
ALL_fold2 <- fold[, 8:14]
ALL_fold3 <- fold[, 15:20]

MLL_fold1 <- fold[, 21:26]
MLL_fold2 <- fold[, 27:32]
MLL_fold3 <- fold[, 33:37]

AML_fold1 <- fold[, 38:44]
AML_fold2 <- fold[, 45:51]
AML_fold3 <- fold[, 52:57]

fold1 <- rbind(t(ALL_fold1), t(MLL_fold1), t(AML_fold1))
fold2 <- rbind(t(ALL_fold2), t(MLL_fold2), t(AML_fold2))
fold3 <- rbind(t(ALL_fold3), t(MLL_fold3), t(AML_fold3))

folds <- list(fold1, fold2, fold3)
folds_labels <- list(sub("_.*", "", row.names(fold1)),
                     sub("_.*", "", row.names(fold2)), 
                     sub("_.*", "", row.names(fold3)))

# 對每一輪 cross-validation:
# • 用兩個 fold 當 training set
# • 用剩下一個 fold 當 testing set
# • 只用 training 樣本訓練 SVM
# • 預測 testing fold 的類別標籤
# • 重複直到每個 fold 都當過一次 testing set

all_pred <- character(0)
all_true <- character(0)

for (i in 1:3){
    x_test  <- folds[[i]]
    y_test  <- folds_labels[[i]]
    
    x_train <- rbind(folds[-i][[1]], folds[-i][[2]])
    y_train <- c(folds_labels[-i][[1]], folds_labels[-i][[2]])
    y_train <- factor(y_train)
    
    svm_model <- svm(x_train, y_train)
    pred <- predict(svm_model, x_test)
    
    cat("====== Fold", i, "======\n")
    print(table(y_test))    
    cat("\n")
    print(table(Predicted = pred, Actual = y_test))         
    cat("\n")
    all_pred <- c(all_pred, as.character(pred))
    all_true <- c(all_true, as.character(y_test))
}

cat("====== Overall ======\n")
print(table(Predicted = all_pred, Actual = all_true))

# ==============================================================================
# ⭐ 加分題 B
# 改用 SRBCT_train.txt 這份資料(四類 : EWS 23 / RMS 20 / NB 12 / BL 8),
# 把主題目的 t-test 換成 Wilcoxon rank-sum test (wilcox.test, 無母數檢定)
# 來挑選差異表現基因,每類各取 top 10。 
# 提示:方向性(「該組表現較高」)可以直接用 alternative = "greater" 指定,不必再另外比較平
# 均值:
#     p <- apply(mat, 1, function(x)
#         wilcox.test(x[grp == g], x[grp != g], alternative = "greater")$p.value)
#     top10 <- order(p)[1:10]
# 
# t-test 是有母數(比較平均值)、Wilcoxon 是無母數(走 ranking)。這也是為什麼方向性不能再
# 靠 mean(該組) > mean(其他) 來判斷,而是交給 alternative 參數處理。
# 
# 小提醒:資料裡有些基因在組內數值大量重複,wilcox.test 會跳出 cannot compute exact p-
#     value with ties 的警告。這是正常的(R 自動改用常態近似),不影響作答。
# 
# 本題只用 SRBCT_train.txt,重點在「換一種檢定方法選基因」,不需要用到 test set(test set 是
#                                                     加分題 C 的事)。
data_SRBCT <- read.delim("SRBCT_train.txt")
data1 <- as.matrix(data_SRBCT[ , -c(1:2)])
Image_id <- data_SRBCT[,1]

min_max_norm <- function(x){
    (x - min(x)) / (max(x) - min(x))
}

data1_norm <- t(apply(data1, 1, min_max_norm))

# 取得所有欄位名稱
cols <- colnames(data1)
labels <- sub("\\..*", "", cols)

EWS_p <- apply(data1_norm, 1, function(x)
                    wilcox.test(x[which(labels == "EWS")], x[-which(labels == "EWS")], alternative = "greater")$p.value)
EWS_p_top10 <- order(EWS_p)[1:10]

BL_p <- apply(data1_norm, 1, function(x)
    wilcox.test(x[which(labels == "BL")], x[-which(labels == "BL")], alternative = "greater")$p.value)
BL_p_top10 <- order(BL_p)[1:10]

NB_p <- apply(data1_norm, 1, function(x)
    wilcox.test(x[which(labels == "NB")], x[-which(labels == "NB")], alternative = "greater")$p.value)
NB_p_top10 <- order(NB_p)[1:10]

RMS_p <- apply(data1_norm, 1, function(x)
    wilcox.test(x[which(labels == "RMS")], x[-which(labels == "RMS")], alternative = "greater")$p.value)
RMS_p_top10 <- order(RMS_p)[1:10]

EWS_top10_id <- Image_id[EWS_p_top10]
BL_top10_id  <- Image_id[BL_p_top10]
NB_top10_id  <- Image_id[NB_p_top10]
RMS_top10_id <- Image_id[RMS_p_top10]

# ⭐ 加分題 C
# 沿用主題目在 training set 上選出的 30 個基因與訓練好的 SVM 模型,套用到 MLL_test.txt 上做預測,
# 並做出 test set 的 confusion matrix(同樣是三類別的 3×3 表)。
# MLL_test.txt 共 15 個樣本(ALL 4 / MLL 3 / AML 8),基因列與 MLL_train.txt 完全對齊(同樣 12582
#                                                                      列、同樣順序),所以選出的基因可以直接用相同的列索引取出。
# 重點:基因的挑選與模型的訓練都只能用 training set;test set 只在最後拿來評估,不可以參與選基因
# 或訓練。
# 提示:test set 也要做同樣的前處理(移除 AFFX、逐列 normalize),否則和訓練時的尺度對不上。
# 這題其實是把加分題 A 的概念換個做法:A 是自己切 fold 做 CV,C 是直接用另外給的 test set。
# 做法上「重新餵一次資料」即可,不難,但不能偷看 test set 選基因這點要守住。
# 補充:MLL_test.txt 的欄名沒有 train 那邊的雙底線問題(MLL_18/MLL_19/MLL_20 都是單底線),
# 但樣本編號是接續 train 繼續編的(如 ALL_21、AML_24),不是從 1 重新開始。


















