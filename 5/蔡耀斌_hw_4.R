# 1. Remove genes with name starting AFFX...(控制探針,共 49 個)
MLL_train <- read.delim("MLL_train.txt")
data <- MLL_train[-c(1:49), ]

# 正規化
min_max_norm <- function(x){
    (x - min(x)) / (max(x) - min(x))
}


# 2. Normalize data by each row(0~1)
data_norm <- t(apply(data[, 3:ncol(data)], 1, min_max_norm))

## 取得欄位名稱
col_name <- colnames(data_norm)
col_name # 觀察

## 清理欄位名
labels <- sub("_.*", "", col_name)
table(labels) # 觀察

# 3. Find top 10 differentially expressed genes using t-test, 每組一次(該組 vs 其他),
#    條件:mean(該組) > mean(其他)
#    • 三組各 10 個 → 合併成 30 selected genes

# 對每一 row 計算 t-test
count_t <- function(group_a, group_b){
    t_value <- numeric(nrow(group_a))
    for(i in 1:nrow(group_a)){
        t_value[[i]] <- t.test(group_a[i, ], group_b[i, ])$statistic
    }
    return(t_value) 
}

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

# 檢查是否有重複挑選的基因
selected_genes <- unique(selected_genes)   
selected_genes
length(selected_genes)

# 4. Use SVM to classify (條件:training data 同時當 testing data)
BiocManager::install("e1071")
library("e1071")

# 訓練模型
train_data <- data_norm[selected_genes, ]
x_train <- t(train_data)
y_train <- factor(labels)
svm_model <- svm(x_train, y_train)
pred <- predict(svm_model, x_train) 

# 5. Make confusion matrix
confusion_matrix <- table(Predicted = pred, Actual = y_train)
confusion_matrix

