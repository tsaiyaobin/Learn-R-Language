data<-read.delim("MLL_train.txt")
dim(data)
data[1:3,]
# 把列名稱從 1,2,...,12582 改成第 1 col 的名稱
rownames(data) <- data[,1]

data1 <- read.delim("MLL_train.txt", row.names=1)
# 用這個邏輯向量去篩選 1:nrow(data)（也就是列的索引 1, 2, 3, ..., nrow(data)，
# 只留下對應 TRUE 的位置，回傳的是列的位置（第幾列），不是數量。
(1:nrow(data))[row.names(data) == "AFFX-DapX-3_at"]

# 在 data 的所有列名（row names）裡，尋找包含 "AFFX" 這個字串的列，
# 並回傳符合的索引位置（第幾列）
grep("AFFX", rownames(data))

#### correlation matrix ####
# 計算不同方向的相關係數矩陣
data2 <- data1[,-1]
cor1 <- cor(data2)
cor2 <- cor(t(data2))