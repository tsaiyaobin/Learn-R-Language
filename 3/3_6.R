# Excerice : What are the top 3 numbers with highest frequencies?
n100 <- sample(9, 100, replace = T)
n100

# 我原本用label = c(1:9)
# labels 的長度必須等於實際出現的 level 數量。
# 如果 100 次抽樣中剛好有某個數字一次都沒出現(機率不高但存在),
# levels 只有 8 個,你給 9 個 labels 就會直接報錯
# fac_n100 <- factor(n100, levels = 1:9) # 這樣即使某數字沒出現也安全,頻率顯示 0
# fac_n100 <- summary(fac_n100)
# fac_n100 <- sort(fac_n100)
# fac_n100
# 方法一
fac_n100 <- sort(summary(factor(n100, levels = 1:9)))
fac_n100
fac_n100 <- tail(fac_n100, 3)
fac_n100

# 方法二
fac_n100 <- sort(summary(factor(n100, levels = 1:9)), decreasing = TRUE)[1:3]
fac_n100

# 進階：一行寫完
n100 <- sort(table(n100), decreasing = TRUE)[1:3]

# x[length(x)]        # 最後一個 → 40
# tail(x, 1)          # 最後一個 → 40
# tail(x, 3)          # 最後三個 → 20 30 40
# head(x, 1)          # 第一個