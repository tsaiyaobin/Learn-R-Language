# factor() : 「類別變數」（categorical variable）是統計學上的一種資料類型，指的是把資料分成不同的類別或組別
 
yy <- factor(c(1:7,5:9,8:3)     # 1 2 3 4 5 6 7 5 6 7 8 9 8 7 6 5 4 3
           , levels=c(9:1))     # 9 個不同的類別

# table() 會計算每個 level 出現的次數
table(yy) 

x <- c("B","F","A","C","A","C","B","A","F","D")
x1 <- as.factor(x)
x2 <- ordered(x, levels=c("B","F","A","C","D"))
x2[x2 >= "A"] # A C A C A D

# list() : 清單，可以裝不同型態、不同長度的東西。

## 向量 轉 list
vec <- 1:9
lis <- as.list(vec)
lis

## 混裝不同型態
xx <- list("a", TRUE, c = 1:3)
xx[1:2]
xx[[3]]
xx[["c"]]  # 用名字取內容
xx$c      # $ 是 [[ ]] 用名字取值的簡寫

# Exaple
ListEx <- list(name = "Fred", wife = "Mary",
               no.children = 3, child.ages = c(4, 7, 9))
# 取 no.children 的值
ListEx[[3]]
ListEx$no.children

# 取 child.age 的第一個值
ListEx[[4]][1]
ListEx$child.ages[1]