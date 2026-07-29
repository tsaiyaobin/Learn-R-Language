# 題目一：對 cycleData_peak.txt：Count how many not “NA” in each row.
data <- read.delim("cycleData_peak.txt") # 讀檔
dim(data) # 觀察維度

# 撰寫函式搭配 apply 
count_NA <- function(x){
    length(x) - sum(is.na(x))
}
row_Non_NA_nums <- apply(data, 1, count_NA)
row_Non_NA_nums

# ------------------------------------------------------------------------------
# 題目二：對 SRBCT_train.txt：
# Normalize data by each row（let values b/w 0~1，min-max）
data2 <- read.delim("SRBCT_train.txt")
data2_without_ch <- as.matrix(data2[,-c(1,2)])
dim2 <- dim(data2_without_ch)
dim2

## min_max 
min_max_norm <- function(x){
    (x - min(x)) / (max(x) - min(x))
}

## 使用 apply
min_max_each_row <- t(apply(data2_without_ch, 1, min_max_norm))
min_max_each_row

# Normalize data by each column (mean = 0, sd = 1)
# z-score
z_norm <- function(x){
    (x - mean(x)) / sd(x)
}

## 使用 apply
z_score_each_col <- apply(data2_without_ch, 2, z_norm)
z_score_each_col


