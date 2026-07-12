# factor vs vector
## sample(抽取數字範圍, 抽取個數, 是否重複抽取)
rfac <- sample(9, 20, replace = T)

## 轉成 factor ,並用 labels 參數把數字換成字母標籤
### letters 是 R 內建的常數，就是 a~z 這 26 個小寫字母
rfac <- factor(rfac, labels = letters[1:9])
rfac

## 注意 labels 和 levels 的差別（很容易搞混）：
### levels：指定「有哪些類別、順序如何」（像最開始的 levels = c(9:1)）
### labels：把類別重新命名成別的名字（這裡把 1~9 改叫 a~i）

## summary()
### 對 factor 做 summary，得到的是各類別的出現次數（跟 table() 一樣）
summary(rfac)


rvec <- sample(9, 20, replace = T)
rvec

summary(rvec)

