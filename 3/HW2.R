# For the file “cycleData_peak.txt”
## Count how many not “NA” in each row.
path <-  "/Users/austin/Desktop/Learn_R/Learn-R-Language/data/"
my_data <- read.table(paste(path, "cycleData_peak.txt", sep = ""), header = TRUE)
str(my_data)
d <- dim(my_data)

row_NA_nums <- numeric(d[1]) # save how many NA in row

for (i in 1:d[1]){
    row_data <- my_data[i, ]
    row_NA_nums[i] <- d[2] - sum(is.na(row_data))
}
row_NA_nums

# For the file “SRBCT_train.txt”.
## Normalize data by each row (let values b/w 0~1)
my_data2 <- read.delim(paste(path, "SRBCT_train.txt", sep = ""))
my_data2 <- as.matrix(my_data2[,-c(1,2)])
d2 <- dim(my_data2)

min_max_norm <- function(lst){
    (lst - min(lst)) / (max(lst) - min(lst))
}

each_row_norm <- matrix(0, nrow = d2[1], ncol = d2[2])
each_row_norm

for (i in 1:d2[1]){
    each_row_norm[i, ] <- min_max_norm(my_data2[i, ])
} 
each_row_norm

# 進階寫法：一行解決
each_row_norm <- t(apply(my_data2, 1, min_max_norm))
each_row_norm

## Normalize data by each column (mean = 0, sd = 1)
z_norm <- function(lst){
    (lst - mean(lst)) / sd(lst)
}
each_col_norm <- matrix(0, nrow = d2[1], ncol = d2[2])

for (j in 1:d2[2]){
    each_col_norm[, j] <- z_norm(my_data2[, j])
}
each_col_norm

# 進階寫法：一行解決
each_col_norm <- apply(my_data2, 2, z_norm)
each_col_norm

## 驗證
### range(x) 會一次回傳最小值和最大值,是一個長度為 2 的向量
range(each_row_norm)                    # 應該是 0 1
### round(x, digits) 是四捨五入到指定的小數位數
round(colMeans(each_col_norm), 10)      # 應該全是 0
round(apply(each_col_norm, 2, sd), 10)  # 應該全是 1
# 和內建函數比對
all.equal(each_col_norm, unname(scale(my_data2)), check.attributes = FALSE)



