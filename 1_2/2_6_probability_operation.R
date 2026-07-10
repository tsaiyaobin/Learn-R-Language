# NA 為缺值
x <- c(1, 2, NA, 4, 5)

is.na(x)                  # 檢查那些位置有缺值

mean(x)                   # 預設不允許缺值，結果會是 NA
mean(x, na.rm = T)        # 加上 na.rm=T，忽略 NA 後再計算平均


# 變異數
y <- c(10.4, 5.6, 3.1, 6.4, 21.7)

var(y)                                    # 內建函式
sum((y - mean(y))**2 / (length(y)-1))     # 手動計算


# 空向量、自動補植
v <- numeric()            # 建立空向量
v[3] <- 7                 # 自動補長
v                         # NA NA  7

# 隨機數產生 與 直方圖

## rnorm(抽樣數量, 平均值, 標準差) ->  random + normal

a <- rnorm(1000, 5, 1)                                          # 常態分布，平均=5，標準差=1
hist(a, nclass = 30)                                            # 分 30 組
hist(a, breaks = 30)                                            # 類似，R 自動調整成漂亮數字
hist(a, breaks = seq(min(a), max(a), (max(a) - min(a)) / 30))   # 手動指定組距


## 常用機率分布函式
### rnorm(抽樣數量, 平均值, 標準差)
### runif(抽樣數量, 最小值, 最大值)
### rt(抽樣數量, 自由度df)
### rchisq(抽樣數量, 自由度df)
### rexp(抽樣數量, 發生率rate)
### rbeta(抽樣數量, 形狀參數α, 形狀參數β)
### rgamma(抽樣數量, 形狀參數shape, 速率參數rate)

rnorm(100, 0, 1)     # 常態分布
runif(100, 0, 1)     # 均勻分布
rt(100, df = 5)      # t 分布
rchisq(100, df = 5)  # 卡方分布
rexp(100, rate = 1)  # 指數分布
rbeta(100, 2, 5)     # Beta 分布
rgamma(100, 2, 1)    # Gamma 分布

## p = probability（機率），norm = normal（常態分布）
### 給你一個數值 x，告訴你在常態分布裡，隨機抽到的數字 ≤ x 的機率是多少

pnorm(1.96)       # 累積機率(probability)  ≈ 0.975，在標準常態分布(平均=0, 標準差=1)裡，隨機抽一個數字，它小於等於 1.96 的機率是 97.5%

# d = density（密度)，給你一個 x 值，告訴你那個點上的曲線高度是多少

dnorm(0)          # 機率密度(density)      ≈ 0.3989
dnorm(0.8)

# q = quantile（分位數），是 pnorm 的反函式，給你一個機率，告訴你對應的 x 值是多少

qnorm(0.975)      # 1.96，累積機率 97.5% 對應的 x 值
qnorm(0.5)        # 0，累積機率 50% 對應的 x 值(正中間)
qnorm(0.025)      # -1.96，累積機率 2.5% 對應的 x 值

# pnorm 跟 qnorm 互為反函式
pnorm(1.96)     # → 0.975（給x，求機率）
qnorm(0.975)    # → 1.96 （給機率，求x）









