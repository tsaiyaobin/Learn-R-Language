?iris
data(iris)   # 載入資料集到工作環境
iris         # 整個dataframe


iris[1,1]
iris[c(1, 9, 150), ]

iris[, 1] > 6
iris[iris[, 1] > 6, ]
str(iris)

# 三維陣列
