vec <- 1:9
str(vec)

fac <- factor(c(1:7,5:9,8:3)     # 1 2 3 4 5 6 7 5 6 7 8 9 8 7 6 5 4 3
             , levels=c(9:1))     # 9 個不同的類別
str(fac)

lis <- as.list(vec)
str(lis)
