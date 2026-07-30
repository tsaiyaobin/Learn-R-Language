# 加分題 A
# 對 cycleData_peak.txt 中的每個基因，自己寫一個函式，依「非缺失值（non-NA）的比例」把資料品質分類：
#     "High"：non-NA values ≥ 80%
#     "Medium"：non-NA values ≥ 50% 且 < 80%
#     "Low"：non-NA values < 50%

data <- read.delim("cycleData_peak.txt") # 讀檔
dim(data) # 觀察維度

# 撰寫函式搭配 apply 
count_NA <- function(x){
    length(x) - sum(is.na(x))
}
row_Non_NA_nums <- apply(data, 1, count_NA)

# 完成以下：
# 1.把這個函式套用到每一列，統計各品質類別的基因數。
count_Non_NA_percent <- function(x, N){
    x / N * 100
}

Non_NA_percent <- count_Non_NA_percent(row_Non_NA_nums, ncol(data))
Non_NA_percent

# 2.有多少基因被分為 High、Medium、Low？
count_quality <- list(high = 0, medium = 0, low = 0) # 存放各種品質有幾個
quality_list <- list() # 存放哪一列是哪一種品質

for (i in 1:length(Non_NA_percent)){
    if (Non_NA_percent[i] >= 80){ # 如果 >= 80%，high的個數加 1
        
        count_quality[['high']] <- count_quality[['high']] + 1 
        quality_list[[i]] <- 'high'
        
    }else if(50 <= Non_NA_percent[i] & Non_NA_percent[i] < 80){
        # 如果 < 80% and >= 50%，medium 的個數加 1
        count_quality[['medium']] <- count_quality[['medium']] + 1
        quality_list[[i]] <- 'medium'
        
    }else{
        # <50, low 個數加 1
        count_quality[['low']] <- count_quality[['low']] + 1
        quality_list[[i]] <- 'low'
        
    }
}
t(count_quality)
t(quality_list)

# 3.哪一個 peak category（尖峰類別）的 High 品質基因比例最高？
## 用 list 存有哪些類別，這些類別有幾個 High 品質基因

peak_category <- list()
for (i in 1:nrow(data)){
    category <- data[i, ncol(data)] # 現在的 peak category
    if (!(data[i, ncol(data)] %in% names(peak_category))){ # category 還沒出現過就初始化
        peak_category[[category]] <- c(0, 0) # 向量 1 用來存 high 出現的次數; 2 存總數
    }
    if (quality_list[[i]] == 'high'){ # 計算有幾個 high 品質
        peak_category[[category]][1] <- peak_category[[category]][1] + 1
    }
    # 計算總數
    peak_category[[category]][2] <- peak_category[[category]][2] + 1
}
peak_category

# 計算 High 品質基因比例，並回傳最大值的索引
count_max_high_percent_peak_category <- function(lst){
    max_percent = 0
    idx = 1
    for (i in 1:length(lst)){
        if (lst[[i]][1] / lst[[i]][2] > max_percent){
            max_percent <- lst[[i]][1] / lst[[i]][2]
            idx <- i
        } 
    }
    return(idx) 
}
# 找到 High 品質基因比例最高的類別索引
max_high_percent_peak_category <- count_max_high_percent_peak_category(peak_category)
# 輸出類別
names(peak_category)[max_high_percent_peak_category]

# ------------------------------------------------------------------------------

# 加分題 B
# SRBCT_train.txt 的樣本分屬四個類別（EWS / BL / NB / RMS，由欄名前綴判斷）。
# 請對每個 gene，分別算出它在每一類別的 mean 與 sd。
# 也就是產生一個「gene × 類別」的 mean 表與 sd 表（各 4 欄，對應 4 類別）。

## prompt : R 有跟 python 的 split() 一樣的函式嗎
##     AI : R 對應的函數是 strsplit(), 但 . 在 regex 裡代表「任何一個字元」
##         ，不是字面上的句點，用跳脫符號 \\. 表示「字面上的句點」
SRBCT_col_name <- strsplit(names(data2[,c(-1,-2)]), "\\.")

## 我用來存放每個類別的起始與終止的索引 
four_category_start_end <- list(EWS = c(0, 0), BL = c(0, 0), NB = c(0, 0), RMS = c(0, 0))
## 存放四類別的平均值與標準差
four_category_mean_sd <- array(vector("list", nrow(data2_without_ch) * 4), dim = c(nrow(data2_without_ch), 4))

# 尋找每個類別的起始與終止的索引 
for (i in 1:ncol(data2_without_ch)){
    if (SRBCT_col_name[[i]][1] == "EWS" & four_category_start_end[["EWS"]][1] == 0){
        four_category_start_end[["EWS"]][1] <- i
    }else if(SRBCT_col_name[[i]][1] == "EWS"){
        four_category_start_end[["EWS"]][2] <- i
    }
    if (SRBCT_col_name[[i]][1] == "BL" & four_category_start_end[["BL"]][1] == 0){
        four_category_start_end[["BL"]][1] <- i
    }else if(SRBCT_col_name[[i]][1] == "BL"){
        four_category_start_end[["BL"]][2] <- i
    }
    if (SRBCT_col_name[[i]][1] == "NB" & four_category_start_end[["NB"]][1] == 0){
        four_category_start_end[["NB"]][1] <- i
    }else if(SRBCT_col_name[[i]][1] == "NB"){
        four_category_start_end[["NB"]][2] <- i
    }
    if (SRBCT_col_name[[i]][1] == "RMS" & four_category_start_end[["RMS"]][1] == 0){
        four_category_start_end[["RMS"]][1] <- i
    }else if(SRBCT_col_name[[i]][1] == "RMS"){
        four_category_start_end[["RMS"]][2] <- i
    }
}

# 計算平均值與標準差
for (i in 1:nrow(data2_without_ch)){
    for (j in 1:4){
        strat_idx <- four_category_start_end[[j]][1]
        end_idx <- four_category_start_end[[j]][2]
        m <- mean(data2_without_ch[i, strat_idx : end_idx])
        s <- sd(data2_without_ch[i, strat_idx : end_idx])
        four_category_mean_sd[[i, j]] <- c(m, s)
    }
}

# AI
# 存成表
mean_table <- data.frame("gene" = data2[, 1], 
                         'EWS' = sapply(four_category_mean_sd[, 1], function(x) x[1]),
                         'BL' = sapply(four_category_mean_sd[, 2], function(x) x[1]), 
                         'NB' = sapply(four_category_mean_sd[, 3], function(x) x[1]),
                         'RMS' = sapply(four_category_mean_sd[, 4], function(x) x[1]),
                         row.names = NULL)


# 存成表
sd_table <- data.frame("gene" = data2[, 1], 
                       'EWS' = sapply(four_category_mean_sd[, 1], function(x) x[2]),
                       'BL' = sapply(four_category_mean_sd[, 2], function(x) x[2]), 
                       'NB' = sapply(four_category_mean_sd[, 3], function(x) x[2]),
                       'RMS' = sapply(four_category_mean_sd[, 4], function(x) x[2]),
                       row.names = NULL)

# ------------------------------------------------------------------------------
# 加分題 C
# 對 cycleData_peak.txt：用 apply + is.na 算出每一欄的 NA 個數，再用 which.max() 找出 NA 最多的那一欄是哪一欄。

count_NA <- function(x){
    sum(is.na(x))
}

NA_nums <- apply(data, 2, count_NA)
max_NA_col <- which.max(NA_nums)
max_NA_col

