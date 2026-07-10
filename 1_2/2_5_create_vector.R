# 向量(vector)利用c(...) 建立向量，但切記向量元素必須是同個資料屬性
# character > complex > numeric > integer > logical

c(1, 2, 3)

c("a", 2, 2 + 2i)     # 都變 character

c(TRUE, 2, 2 + 2i)    # 都變 complex


x <- c(at = 100, sean = 95, kai = 90) # 類似 python 字典的鍵:值

x[1]                  # 回傳 x[1] 的所有元素

x[[1]]                # 回傳 x[1] 的值                

x["at"]               # 回傳 "鍵" 名稱的所有元素

x[["at"]]             # 回傳 "鍵" 名稱的 "值"

x[1: 2]               # 取多向量元素

# seq(起始值, 結束, 間隔)

1:5                   # 1 ~ 5
 
seq(1, 5)             # 1 ~ 5

seq(1, 5, 0.3)

# rep(要重複循環的值, times = 循環次數, each = 要重複循環的值內部要循環幾次)

rep(1, times = 3)

rep(1:3, times = 3, each = 3)

rep(seq(1, 5, 2), times = 3, each = 2)

rep(c(1, 3, 5), times = 3, each = 2)

