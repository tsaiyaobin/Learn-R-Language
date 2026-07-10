x <- c(1, 2, 3)
y <- c(4, 5, 6)

w = rbind(x, y)    # 利用 row 合併
w

z = cbind(x, y)    # 利用 col 合併
z

array(x, c(1, 3))  # c(1, 3) 代表產生 1x3 陣列
array(x, c(2, 3))  # c(2, 3) 代表產生 2x3 陣列
array(x, c(3, 3))  # c(3, 3) 代表產生 3x3 陣列


matrix(c(1:3), nrow = 1, ncol = 3)                     # 預設按照 col 填資料
matrix(c(1:3), nrow = 2, ncol = 3)
matrix(c(1:3), nrow = 3, ncol = 3)
matrix(c(1:3), nrow = 3, ncol = 3, byrow = TRUE)       # 改為 row 填資料
                 


# 提取資料
w[1, ]
w[, 1]
w[1, 1:3]

length(z)        # array 元素個數
dim(z)           # 維度
ncol(z)          # col 數量
nrow(z)          # row 數量
aperm(z)         # 轉置
t(z)             # 轉置

rownames(z)      # 修改 or 查詢 row 的名稱
colnames(z)      # 修改 or 查詢 row 的名稱

rownames(z) <- c('第一列', '第二列', '第三列')
colnames(z) <- c('第一行', '第二行')
z

m <- c(sample(1:100, 9))
m = matrix(m, 3, 3)
m

solve(m)         # 傳回矩陣的反矩陣
eigen(m)         # 計算矩陣的特徵向量
m %*% m          # 矩陣相乘

# 進階
x <- 1:20
dim(x) <- c(4, 5)          # 把向量轉成 4×5 矩陣
x <- array(1:20, dim = c(4, 5))  # 等效寫法


mdat <- matrix(c(1, 2, 3, 11, 12, 13),                       # matrix() 進階:按列填 + 命名列欄 
               nrow = 2, ncol = 3,
               byrow = TRUE,                
               dimnames = list(c("row1", "row2"),
                               c("C.1", "C.2", "C.3")))

x[c(2, 4), ]   # 取第 2、4 列(逗號後留空 = 所有欄)
mdat["row1", "C.2"]  # 有命名時可用名字索引


# which():回傳符合條件的「位置索引」
a <- c(1, 2, 3, 4, 5)
which(a > 3)   # 4 5(是索引,不是值)


# sort() vs order() vs rank()
aa <- c(94, 86, 18, 79, 28, 68, 7, 27, 84, 10)

sort(aa)   # 排序後的值
order(aa)  # 排序後的原始索引
rank(aa)   # 每個元素的名次

# 找出「小於等於第 30 百分位數」的元素位置
quantile(aa, 0.3)
bb <- which(aa <= quantile(aa, 0.3))

# 若要移除這些最低 30% 的資料:
aa_trimmed <- aa[-bb]




























