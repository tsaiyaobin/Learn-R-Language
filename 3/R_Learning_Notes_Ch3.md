# R 語言筆記：Factor、List、Dataframe 與資料匯入匯出

> 整理自 `3_1.R` ~ `3_8.R` 及作業 `HW2.R` 練習內容,依概念重新分類,方便複習與查閱。

[TOC]

---

## 一、Factor 類別變數

**factor()**:「類別變數」(categorical variable) 是統計學上的一種資料類型,指的是把資料分成不同的類別或組別。

```r
yy <- factor(c(1:7,5:9,8:3),      # 1 2 3 4 5 6 7 5 6 7 8 9 8 7 6 5 4 3
             levels=c(9:1))       # 9 個不同的類別

table(yy)   # table() 會計算每個 level 出現的次數
```

`factor()` 也支援字串,並可用 `ordered()` 建立「有順序」的類別變數:

```r
x <- c("B","F","A","C","A","C","B","A","F","D")
x1 <- as.factor(x)
x2 <- ordered(x, levels=c("B","F","A","C","D"))
x2[x2 >= "A"]   # A C A C A D，順序依 levels 給定的排列，而非字母順序
```

### levels vs labels(容易搞混)

```r
rfac <- sample(9, 20, replace = T)
rfac <- factor(rfac, labels = letters[1:9])   # 用 labels 把數字換成字母標籤
rfac
```

> - `levels`:指定「有哪些類別、順序如何」(例如 `levels = c(9:1)`)
> - `labels`:把類別重新命名成別的名字(這裡把 1~9 改叫 a~i)

**常見地雷**:`labels` 的長度必須等於實際出現的 level 數量。若抽樣中剛好有某個數字一次都沒出現(機率不高但存在),直接寫 `levels = 1:9` 而不指定 `labels`,就算某數字沒出現也安全,頻率會顯示 0;但若同時指定 `labels` 且長度對不上實際 level 數,就會直接報錯。

```r
str(factor(c(1:7,5:9,8:3), levels=c(9:1)))   # str() 可同時看出型別與內容摘要
```

### summary() 與 table() 的關係

```r
summary(rfac)   # 對 factor 做 summary，得到的是各類別的出現次數，跟 table() 效果相同

rvec <- sample(9, 20, replace = T)
summary(rvec)   # 對數值向量做 summary，得到的是最小值/四分位數/平均數等統計量
```

> `summary()` 會依物件型別給出完全不同的結果:factor 給次數分布,numeric 給描述統計。這是初學者常忽略的差異。

---

## 二、List 清單

**list()**:清單,可以裝不同型態、不同長度的東西,是 R 最彈性的容器。

```r
## 向量轉 list
vec <- 1:9
lis <- as.list(vec)
str(lis)

## 混裝不同型態
xx <- list("a", TRUE, c = 1:3)
xx[1:2]      # 取「子清單」(保留 list 結構)
xx[[3]]      # 取「純值」(取出內部內容)
xx[["c"]]    # 用名字取內容
xx$c         # $ 是 [[ ]] 用名字取值的簡寫
```

### 具名 list 存取範例

```r
ListEx <- list(name = "Fred", wife = "Mary",
               no.children = 3, child.ages = c(4, 7, 9))
ListEx[[3]]            # 取 no.children 的值
ListEx$no.children     # 效果相同

ListEx[[4]][1]         # 取 child.ages 的第一個值
ListEx$child.ages[1]   # 效果相同
```

> `[ ]`、`[[ ]]`、`$` 的差異是初學者常見的困惑點:`[ ]` 保留結構(回傳同型別容器),`[[ ]]` 只取出內部的值本身,`$` 是 `[[ ]]` 用名稱取值的簡寫,僅適用於具名物件。

---

## 三、Dataframe 與 Matrix

### 建立與檢視

```r
accounts <- data.frame(state = c("PA", "CA", "MA"),
                        income = c(1000, 1100, 900),
                        married = c(T, F, F))
accounts

attributes(accounts)   # 看屬性(欄位名、列名、class)
str(accounts)          # 每欄的型態、內容概覽
```

### matrix 轉 dataframe

```r
mat <- matrix(data = 1:35, nrow = 5, ncol = 7)   # 欄、列都是 [1,] [2,]...
dat <- as.data.frame(mat)                        # 有欄名(V1,V2...) 與列號(1,2...)
dat
```

### 取值方式的差異(重點比較)

| 操作 | dataframe | matrix |
|---|---|---|
| 看結構 | `str(dat)` → `5 obs. of 7 variables` | 無此用法 |
| 取整欄 | `dat$V1` 等價於 `dat[,1]` | `mat[, 1]` |
| 欄名 | 預設就有(V1, V2...) | 預設為 `NULL`,需手動 `colnames(mat) <- ...` |
| 用名稱取值 | 可用 `$` | 即使加了欄位名,也**無法**用 `$` 取值,只能 `mat[, "V1"]` |

```r
colnames(mat) <- paste("V", 1:dim(mat)[2], sep = "")
mat[, "V1"]
```

---

## 四、iris 資料集與三維陣列

`iris` 是 R 內建的經典範例資料集,常用來練習 dataframe 的索引與篩選:

```r
data(iris)          # 載入資料集到工作環境
iris[1,1]            # 第 1 列第 1 欄的單一值
iris[c(1, 9, 150), ] # 取指定的多個列

iris[, 1] > 6            # 邏輯向量：第一欄哪些 > 6
iris[iris[, 1] > 6, ]    # 用邏輯向量篩選出符合條件的列
```

`iris3` 則是同名的三維陣列版本,常用來理解多維索引:

```r
data(iris3)
str(iris3)
iris3[1:5, , 3]   # 第三維(第三個切面)的前 5 列，逗號留空 = 該維度全取
```

---

## 五、抽樣模擬與頻率統計練習

### 找出出現頻率最高的前 3 個數字

```r
n100 <- sample(9, 100, replace = T)

# 方法一：分兩步
fac_n100 <- sort(summary(factor(n100, levels = 1:9)))
fac_n100 <- tail(fac_n100, 3)

# 方法二：一步到位，用 decreasing 直接取前 3
fac_n100 <- sort(summary(factor(n100, levels = 1:9)), decreasing = TRUE)[1:3]

# 進階寫法：用 table() 取代 factor+summary，一行寫完
n100 <- sort(table(n100), decreasing = TRUE)[1:3]
```

**常用取值函數備忘**

```r
# x[length(x)]   # 最後一個
# tail(x, 1)     # 最後一個
# tail(x, 3)     # 最後三個
# head(x, 1)     # 第一個
```

### 多欄位頻率統計(逐欄迴圈練習)

```r
m <- matrix(0, nrow = 100, ncol = 4)
for (i in 1:100){
    m[i, ] <- sample(9, 4, replace = T)
}

for (i in 1:4){
    m_sort <- sort(table(m[,i]), decreasing = T)[1:3]
    print(m_sort)
}
```

> 這題把「單欄找前 3 高頻」的邏輯,用 `for` 迴圈套用到矩陣的每一欄,是 factor/table 與迴圈結合的典型應用。

---

## 六、資料匯入與匯出

### 寫入資料

```r
write.table(iris, "iris.txt")
write.table(iris, "iris2.txt", quote=F, row.names=F)
write.table(iris, "iris3.txt", quote=F, row.names=F, col.names=F)
```

| 參數 | 效果 |
|---|---|
| `quote = F` | 字串不加雙引號(預設 `"setosa"` 會變 `setosa`) |
| `row.names = F` | 不寫列編號 |
| `col.names = F` | 不寫欄名稱 |

### 讀取資料:read.table vs read.delim

```r
demodata <- read.table("iris.txt")
demodata <- read.delim("iris.txt")
```

> - `read.table()`:R 讀取表格型文字檔的基礎函數,預設「任意空白」會把連續的空格或 tab 當成一個分隔符
> - `read.delim()`:每一個 tab 都是分隔符,資料有空欄位時差很多

### 批次匯入多個檔案(list.files + lapply)

```r
files.n <- list.files(path="/Users/austin/Desktop/Learn_R/Learn-R-Language/3", ".txt", full.names=T)
files.l <- lapply(files.n, read.table, header = T)
files.l
```

> - `list.files()`:列出資料夾裡的檔案,`".txt"` 是 pattern,只挑檔名含 .txt 的;`full.names = T` 回傳完整路徑而非只有檔名
> - `lapply(向量, 函數, 額外參數)`:對向量的每個元素套用函數,等於對每個檔名跑一次 `read.table(檔名, header = T)`
> - `header = TRUE`:告訴 R「檔案的第一行是欄位名稱,不是資料」

---

## 七、實戰練習:NA 計數與資料常態化(HW2)

### 7.1 計算每列非 NA 的個數

```r
path <-  "/Users/austin/Desktop/Learn_R/Learn-R-Language/data/"
my_data <- read.table(paste(path, "cycleData_peak.txt", sep = ""), header = TRUE)
d <- dim(my_data)

row_NA_nums <- numeric(d[1])   # 儲存每列有幾個非 NA
for (i in 1:d[1]){
    row_data <- my_data[i, ]
    row_NA_nums[i] <- d[2] - sum(is.na(row_data))
}
row_NA_nums
```

### 7.2 資料常態化:依列 vs 依欄

**依每列常態化(min-max,值介於 0~1)**

```r
my_data2 <- read.delim(paste(path, "SRBCT_train.txt", sep = ""))
my_data2 <- as.matrix(my_data2[,-c(1,2)])
d2 <- dim(my_data2)

min_max_norm <- function(lst){
    (lst - min(lst)) / (max(lst) - min(lst))
}

each_row_norm <- matrix(0, nrow = d2[1], ncol = d2[2])
for (i in 1:d2[1]){
    each_row_norm[i, ] <- min_max_norm(my_data2[i, ])
}

# 進階寫法：一行解決
each_row_norm <- t(apply(my_data2, 1, min_max_norm))
```

**依每欄常態化(z-score,mean = 0, sd = 1)**

```r
z_norm <- function(lst){
    (lst - mean(lst)) / sd(lst)
}
each_col_norm <- matrix(0, nrow = d2[1], ncol = d2[2])
for (j in 1:d2[2]){
    each_col_norm[, j] <- z_norm(my_data2[, j])
}

# 進階寫法：一行解決
each_col_norm <- apply(my_data2, 2, z_norm)
```

> `apply(資料, MARGIN, 函數)` 是 for 迴圈的向量化替代方案:`MARGIN = 1` 依列(row)套用,`MARGIN = 2` 依欄(column)套用。同一件事,`apply` 版本比手寫 for 迴圈更簡潔。

### 7.3 驗證結果

```r
range(each_row_norm)                     # 應該是 0 1，range() 一次回傳最小值和最大值

round(colMeans(each_col_norm), 10)       # 應該全是 0，round(x, digits) 四捨五入到指定小數位
round(apply(each_col_norm, 2, sd), 10)   # 應該全是 1

# 和內建函數比對
all.equal(each_col_norm, unname(scale(my_data2)), check.attributes = FALSE)
```

> `scale()` 是 R 內建的 z-score 常態化函數,用 `all.equal()` 跟手寫版本比對,是驗證自訂函數正確性的好習慣。

---

## 重點速查表

| 主題 | 關鍵函式 |
|---|---|
| Factor | `factor` `levels` `labels` `ordered` `table` `summary` |
| List | `list` `as.list` `[ ]` `[[ ]]` `$` |
| Dataframe/Matrix | `data.frame` `matrix` `as.data.frame` `attributes` `str` `colnames` |
| 內建資料集 | `iris` `iris3` `data()` |
| 抽樣與統計 | `sample` `sort` `tail`/`head` `table` `factor+summary` |
| 迴圈與向量化 | `for` `apply` `lapply` |
| 資料匯入匯出 | `write.table` `read.table` `read.delim` `list.files` |
| 資料前處理 | 自訂 `min_max_norm`/`z_norm` `scale` `range` `colMeans` `all.equal` |

---

*本筆記依概念主題重新整理自 `3_1.R` ~ `3_8.R` 及 `HW2.R`*
