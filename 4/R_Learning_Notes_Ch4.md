# R 語言筆記：基礎繪圖(plot)、圖形裝置與顏色系統

> 整理自 `4_1.R` ~ `4_10.R` 練習內容，依概念重新分類，方便複習與查閱。每個函式皆附上函式簽名(Usage)與參數說明(Arguments)，格式仿照 R 官方說明文件。

[TOC]

---

## 一、plot() 基礎散佈圖

**plot()**：R 最基本的繪圖函數，依資料型態自動決定畫法。對兩欄數值資料，預設畫出散佈圖(scatter plot)。

**函式簽名**

```r
plot(x, y,
     type = "型態",     # 繪圖型態,預設 "p"(詳見「七、plot() 的 type 參數」)
     col  = "顏色",      # 點或線的顏色
     pch  = 點形狀代碼,   # 點的形狀,預設 1(空心圓)
     bg   = "填色",      # 點內部填色,僅 pch 21~25 適用
     cex  = 縮放倍率,     # 點或文字的縮放倍率,預設 1
     xlab = "x軸標籤",
     ylab = "y軸標籤",
     main = "主標題")
```

**參數說明**

| 參數 | 型態 | 說明 |
|---|---|---|
| `x` | 向量、矩陣、data.frame 欄位 | x 軸資料。若傳入 1 欄矩陣，則整個矩陣被當成 y，x 自動用索引 |
| `y` | 向量 | y 軸資料；若 `x` 已是兩欄矩陣或 data.frame，可省略 |
| `type` | 字元 | 繪圖型態，可為 `"p"`、`"l"`、`"b"`、`"c"`、`"o"`、`"h"`、`"s"`、`"S"`、`"n"` |
| `col` | 數字、字串、向量 | 點或線的顏色，可傳入單一值或跟資料等長的向量 |
| `pch` | 數字、向量 | 點的形狀代碼(0~25) |
| `bg` | 數字、字串 | 點的內部填色，只有 `pch = 21~25` 有效 |
| `cex` | 數字、向量 | 點或文字的縮放倍率 |
| `xlab`、`ylab` | 字串 | x 軸、y 軸標籤文字 |
| `main` | 字串 | 圖表主標題 |

```r
path <- "/Users/austin/Desktop/Learn_R/Learn-R-Language/data/"
aa <- read.delim(paste(path, "test_data.txt", sep = ""))
plot(aa$area, aa$price)   ## plot area versus price
```

### plot() 認得的矩陣形狀

```r
source("min_max_normalize.R") # call function

data <- matrix(sample(100, 50))   # simulate gene samples
data <- min_max_normalize(data)

plot(data, xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scatter Plots of ", length(data), "Synthetic Samples", sep = ""))
```

> `plot()` 直接傳入矩陣時，只認得兩種形狀：
> - 1 欄(`ncol = 1`)：當成一組 y 值，x 軸自動用 `1, 2, 3...`(index)
> - 2 欄(`ncol = 2`)：第一欄當 x，第二欄當 y，畫成一組 (x, y) 點

---

## 二、圖形裝置(Graphic Device)與檔案匯出

R 的繪圖分成兩步：先「開啟一個圖形裝置」，接著在裝置上畫圖，最後用 `dev.off()` 關閉裝置、完成輸出。

**函式簽名**

```r
jpeg(filename = "檔案路徑",
     units  = "單位",     # 預設 "px",可改 "in"、"cm"、"mm"
     width  = 寬度,
     height = 高度,
     res    = 解析度)     # pixels per inch,預設 72

bmp(filename = "檔案路徑",
    units  = "單位",
    width  = 寬度,
    height = 高度,
    res    = 解析度)
```

**參數說明**

| 參數 | 說明 |
|---|---|
| `filename` | 輸出檔案的完整路徑(含副檔名) |
| `units` | 尺寸單位，預設 `"px"`。改成 `"in"`(或 `"cm"`、`"mm"`)後，`width`/`height` 代表實際物理尺寸；搭配 `res` 決定輸出的像素尺寸(例如 6.4in × 300ppi = 1920px) |
| `width`、`height` | 圖檔的寬、高，單位依 `units` 而定 |
| `res` | 每英吋像素數(pixels per inch)，預設 72，常見印刷品質為 300 |

```r
jpeg(paste(path, "houseinfo.jpg", sep = ""),
     units = "in", width = 6.4, height = 4.8, res = 300)

plot(aa$area, aa$price, xlab = "area", ylab = "price")
title("house information")

dev.off()   ## 關閉圖形裝置,完成繪圖

bmp(paste(path, "houseInfo.bmp", sep = ""),
    units = "in", width = 6.4, height = 4.8, res = 300)

plot(aa$area, aa$price, xlab = "area", ylab = "price")
title("house information")

dev.off()
```

> `title(main = "標題文字")` 可在既有圖上補加標題，不必重新畫圖。

### 一次關閉所有圖形裝置

**函式簽名**

```r
dev.off()         # 關閉「目前使用中」的圖形裝置
graphics.off()    # 關閉「所有」開啟中的圖形裝置並重置
```

```r
graphics.off()   # 關閉所有圖形裝置,重置
```

> `dev.off()` 只關閉「目前」的裝置，`graphics.off()` 則會把所有開啟中的圖形裝置全部關掉並重置，兩者用途不同，皆不需要參數。

---

## 三、點的顏色與形狀：col、pch

**points()**：在既有的圖上疊加新的點，常搭配 `plot(..., type = 'n')` 或現成的 `plot()` 圖層使用。

**函式簽名**

```r
points(x, y,
       col = "顏色代碼",   # 點的邊框顏色
       pch = 點形狀代碼,    # 點的形狀
       bg  = "填色代碼")   # 點的內部填色,僅 pch 21~25 適用
```

**參數說明**

| 參數 | 說明 |
|---|---|
| `x` | 新增點的 x 座標。**若只給一個向量，會被當成 y 值，x 自動用 `seq_along()` 生成索引** |
| `y` | 新增點的 y 座標(選填，視 `x` 而定) |
| `col` | 點的邊框顏色。R 內建數字對應色票：`1=黑`、`2=紅`、`3=綠`、`4=藍`、`5=青`、`6=洋紅`、`7=黃`、`8=灰`... |
| `pch` | 點的形狀代碼(plotting character)。`pch = 21` 是「實心圓圈，邊框和內部填色可以分開設定」；`pch 21~25`(圓形、方形、菱形、三角形等)才支援 `bg` 填色參數，其餘 `pch(0~20)` 只有單一 `col` 決定顏色 |
| `bg` | 點的內部填色，只有 `pch = 21~25` 有效 |

```r
plot(data, xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scatter Plots of ", length(data), "Synthetic Samples", sep = ""))

points(data[1:10], col = 1, pch = 21, bg = 2)
points(x = 11:20, y = data[11:20], col = 1, pch = 21, bg = 3)
```

**常見地雷**：`points(data[11:20], ...)` 只給了一個向量，R 會把它當成 y 值，x 座標自動用 `seq_along()` 生成，也就是 `1, 2, 3...10`——而不是想要的 `11~20`！結果這組點會畫到 x = 1~10 的位置，跟第一組樣本重疊。要畫在正確的 x 位置，必須明確指定 `x = 11:20`。

### 用向量一次指定多組顏色/形狀

```r
col_lab <- c(rep(1, 10), rep(2, 10), rep(3, 10), rep(4, 10), rep(5, 10))

plot(data, col = col_lab, pch = col_lab, 
     xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scatter Plots of ", length(data), "Synthetic Samples", sep = ""))
```

> `col`、`pch` 都可以直接傳入一個跟資料等長的向量，R 會逐點對應上色/換形狀，不必手動呼叫多次 `points()`。

---

## 四、點的大小：cex

**cex**(character expansion)：`plot()`、`points()`、`legend()` 等繪圖函數共用的參數，控制點或文字的縮放倍率，預設為 1。

**參數說明**

| 參數 | 說明 |
|---|---|
| `cex` | 縮放倍率，`1` 為原始大小，大於 1 放大、小於 1 縮小。可傳入單一值或跟資料等長的向量，逐點套用不同倍率 |

```r
plot(data, pch = 21, bg = col_lab, 
     cex = col_lab, xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scatter Plots of ", length(data), "Synthetic Samples", sep = ""))
```

> 這裡把 `cex = col_lab` 直接用分組標籤(1~5)當縮放倍率，同一組的點顏色(`bg`)跟大小(`cex`)一起變化，方便肉眼區分不同群組。

---

## 五、圖例：legend()

**legend()**：替圖表加上圖例，說明每種顏色/形狀代表的意義。位置可以用「座標」或「關鍵字」兩種方式指定。

**函式簽名**

```r
legend(x, y,                # 座標位置,或用關鍵字如 "topleft" 取代 x,y
       legend = "圖例文字向量",
       col   = "顏色向量",
       pch   = 點形狀向量,
       cex   = 縮放倍率,
       title = "圖例標題",
       inset = 內縮距離)
```

**參數說明**

| 參數 | 說明 |
|---|---|
| `x`、`y` | 圖例左上角的座標。可用數值座標，也可用 `locator(1)` 讓使用者手動點選，或用關鍵字字串(見下方)取代 |
| `legend` | 圖例要顯示的文字，通常是字串向量(如 `paste("Group", 1:5)`) |
| `col` | 每個圖例項目對應的顏色，通常跟 `plot()` 裡的 `col` 對應 |
| `pch` | 每個圖例項目對應的點形狀，通常跟 `plot()` 裡的 `pch` 對應 |
| `cex` | 圖例整體的縮放倍率(文字跟符號會一起縮放) |
| `title` | 圖例框上方的標題文字 |
| `inset` | 圖例框往繪圖區域內縮的距離比例，只在用關鍵字定位時常用 |

### 用座標指定位置(含滑鼠互動 locator())

```r
plot(data, col = col_lab, pch = col_lab, 
     xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scatter Plots of ", length(data), "Synthetic Samples", sep = ""))

# locator(1):讓使用者在圖上點一下滑鼠，回傳該點座標,當作 legend 左上角要放置的位置
# paste("Group", 1:5):產生圖例要顯示的文字標籤
# cex 參數控制整體大小(文字跟符號會一起縮放)
legend(locator(1), paste("Group", 1:5), col = 1:5, pch = 1:5, cex = 0.5)

legend(2, 0.8, "2, 0.8", cex = 0.5)
legend(45, 0.18, "45, 0.18", cex = 0.5)
legend(39, 0.1, "39, 0.1", cex = 0.5)
```

> `legend()` 的第一個參數可以是座標(x, y)，也可以用 `locator(1)` 讓使用者手動點選位置，不必猜測數值。

### 用關鍵字指定位置

```r
x <- 0:64 / 64
y <- sin(3 * pi * x)
plot(x, y, type = 'n')   # type = 'n' 表示「不畫任何點或線」,圖是空白的,只有座標軸跟框線

legend("bottomright", "(x,y)", pch = 1, title = "bottomright")
legend("bottom",      "(x,y)", pch = 1, title = "bottom")
legend("bottomleft",  "(x,y)", pch = 1, title = "bottomleft")
legend("left",        "(x,y)", pch = 1, title = "left")
legend("topleft",     "(x,y)", pch = 1, title = "topleft, inset = .05", inset = .05)
legend("top",         "(x,y)", pch = 1, title = "top")
legend("topright",    "(x,y)", pch = 1, title = "topright, inset = .02", inset = .02)
legend("right",       "(x,y)", pch = 1, title = "right")
legend("center",      "(x,y)", pch = 1, title = "center")
```

> - R 支援的關鍵字位置有：`"topleft"`、`"top"`、`"topright"`、`"left"`、`"center"`、`"right"`、`"bottomleft"`、`"bottom"`、`"bottomright"`，對應繪圖區域的九宮格位置
> - `inset`：讓圖例框往繪圖區域內縮一點距離，避免貼到邊框

---

## 六、顏色系統：colors()、gray.colors()、rainbow()、rgb()

R 提供多種方式產生顏色，適合不同情境。

**函式簽名**

```r
colors()                                  # 列出所有內建顏色名稱,無參數
gray.colors(n = 顏色數量)                  # 產生 n 階灰階色階
rainbow(n = 顏色數量)                      # 產生 n 種色相均勻分布的彩虹色階
rgb(red, green, blue,
    maxColorValue = 數值範圍上限)          # 依 RGB 數值組合自訂顏色
```

**參數說明**

| 函數 | 參數 | 說明 |
|---|---|---|
| `colors()` | 無 | 回傳 R 內建全部顏色名稱的字串向量 |
| `gray.colors(n)` | `n` | 要產生的灰階顏色數量 |
| `rainbow(n)` | `n` | 要產生的顏色數量，色相會平均分布一圈 |
| `rgb(red, green, blue, maxColorValue)` | `red`、`green`、`blue` | 三原色的數值，預設範圍 0~1 |
| | `maxColorValue` | 告訴 R 上面數值的範圍上限，設為 `255` 代表用 0~255(而非預設 0~1 小數)表示 |

```r
# colors():R 內建色彩名稱表
length(colors())   # 共有幾種內建顏色名稱
colors()[1:10]     # 看前 10 個顏色名稱

# gray.colors():產生指定數量的灰階色階
gray.colors(2)
gray.colors(5)

# rainbow():產生指定數量、色相均勻分布的彩虹色階,適合區分多個類別
rainbow(3)
rainbow(8)

# rgb():用 R/G/B 三原色數值自訂顏色
# maxColorValue = 255:告訴 R，你給的數值範圍是 0~255(而不是預設的 0~1 小數)
rgb(0, 0, 0, maxColorValue = 255)         # 黑色
rgb(255, 255, 255, maxColorValue = 255)   # 白色
```

| 函數 | 用途 | 回傳 |
|---|---|---|
| `colors()` | 列出 R 內建的顏色名稱 | 字串向量(如 `"white"`、`"aliceblue"`...) |
| `gray.colors(n)` | 產生 n 階灰階顏色 | 十六進位色碼字串向量 |
| `rainbow(n)` | 產生 n 種色相均勻分布的顏色，適合分類配色 | 十六進位色碼字串向量 |
| `rgb(r, g, b, maxColorValue = 255)` | 依 RGB 數值自訂單一顏色 | 單一十六進位色碼字串 |

---

## 七、plot() 的 type 參數

**type**：控制 `plot()` 要把資料畫成「點」還是「線」，或兩者都畫。前面章節用過的 `type = 'n'`(不畫任何東西，只留座標軸)只是其中一種，完整簽名見「一、plot() 基礎散佈圖」。

```r
x <- 0:64 / 64
y <- sin(3 * pi * x)

plot(x, y, type = 'n')   # 不畫點也不畫線，只留座標軸跟框線，常用來先佈局再手動加圖例/圖形
plot(x, y, type = 'p')   # 預設值:只畫點(points)
plot(x, y, type = 'l')   # 只畫線(lines),把點依序連起來
plot(x, y, type = 'b')   # both:點跟線都畫,線不會蓋過點
plot(x, y, type = 'c')   # 跟 'b' 類似,但線在點的位置會斷開，只留點之間的連線
plot(x, y, type = 'o')   # overplotted:點跟線畫在一起且重疊(線會穿過點)
plot(x, y, type = 'h')   # histogram-like:從 x 軸畫垂直線到每個點(類似長條圖的線條版)
plot(x, y, type = 's')   # 階梯狀，先橫後縱(stair steps,階梯的角在右邊)
plot(x, y, type = 'S')   # 階梯狀，先縱後橫(階梯的角在左邊)
```

| type 值 | 說明 |
|---|---|
| `"p"` | 只畫點(預設值) |
| `"l"` | 只畫線 |
| `"b"` | 點與線都畫，線不覆蓋點 |
| `"c"` | 同 `"b"`，但線在點的位置斷開 |
| `"o"` | 點與線重疊畫在一起 |
| `"h"` | 從 x 軸畫垂直線到每個點(直方線) |
| `"s"` | 階梯狀，階梯的角在右邊 |
| `"S"` | 階梯狀，階梯的角在左邊 |
| `"n"` | 不畫點也不畫線，只留座標軸 |

> `type = 'n'` 很常用來「先畫出空的座標系統」，再用 `points()`、`lines()`、`legend()` 等函數手動疊圖層，取得更精細的排版控制。

---

## 八、一個視窗畫多張圖：par(mfrow/mfcol) 與 layout()

### 用 par(mfrow/mfcol) 畫規則的多圖版面

**par()**：設定繪圖參數，`mfrow`/`mfcol` 可以把一個繪圖視窗切成 n×m 的網格，依序把每次 `plot()` 畫到下一格。

**函式簽名**

```r
par(mfrow = c(列數, 欄數))   # 依「列」方向依序填格(row-wise)
par(mfcol = c(列數, 欄數))   # 依「欄」方向依序填格(column-wise)
```

**參數說明**

| 參數 | 說明 |
|---|---|
| `mfrow` | 長度 2 的向量 `c(nrow, ncol)`，把視窗切成 nrow×ncol 網格，新圖依「橫向」順序依序填入 |
| `mfcol` | 長度 2 的向量 `c(nrow, ncol)`，網格大小同 `mfrow`，但新圖依「縱向」順序依序填入 |

```r
data <- rnorm(50, 0.5, 0.2)
types <- c("p", "l", "b", "c", "o", "h", "s", "n")

par(mfrow = c(2, 4))   # 切成 2 列 4 欄,依「列」方向依序填格(先填滿第一列再換下一列)
for (i in 1:8){
    plot(data, type = types[i])
}

par(mfcol = c(2, 4))   # 切成 2 列 4 欄,依「欄」方向依序填格(先填滿第一欄再換下一欄)
for (i in 1:8){
    plot(data, type = types[i])
}
```

> - `mfrow` 與 `mfcol` 切出來的網格大小相同，差別只在「填格順序」：`mfrow` 橫向優先(row-wise)，`mfcol` 縱向優先(column-wise)
> - 這個範例同時把「七、plot() 的 type 參數」的八種畫法一次全部畫出來比較

### 用 layout() 畫不規則的多圖版面

**layout()**：比 `par(mfrow/mfcol)` 更彈性，可以自訂每張圖佔用的格子大小與比例，常用來畫「主圖 + 邊際直方圖」這類版面。

**函式簽名**

```r
layout(mat,               # 版面配置矩陣,數字代表第幾張圖畫在該格,0 = 留空
       widths  = 各欄寬度比例,
       heights = 各列高度比例)
```

**參數說明**

| 參數 | 說明 |
|---|---|
| `mat` | 一個矩陣，用數字描述版面配置——矩陣裡的數字代表「第幾個畫的圖要放在這一格」，`0` 表示該格留空 |
| `widths` | 各欄的相對寬度比例，長度需等於 `mat` 的欄數 |
| `heights` | 各列的相對高度比例，長度需等於 `mat` 的列數 |

```r
attach(iris)
x.hist <- hist(Sepal.Length, breaks = 10, plot = F)
y.hist <- hist(Sepal.Width, breaks = 10, plot = F)

top <- max(c(x.hist$counts, y.hist$counts))

layout(matrix(c(2, 0, 1, 3), 2, 2, byrow = T),
       width = c(4, 1), heights = c(1, 2))
plot(Sepal.Length, Sepal.Width, main = "x-y distribution")

barplot(x.hist$counts, axes = F, ylim = c(0, top),
        space = 0, main = "x-axis histogram")

barplot(y.hist$counts, axes = F, xlim = c(0, top),
        space = 0, horiz = T, main = "y-axis histogram")
```

> - 畫圖順序要跟 `layout()` 矩陣裡的數字對應：先畫「1 號格」的圖，再依序畫「2 號格」「3 號格」的圖
> - `widths`、`heights` 讓主圖跟邊際圖的比例協調(這裡主圖比邊際直方圖大)

### 相同數字合併成大格

`layout()` 的核心概念：矩陣裡的數字代表「第幾張圖佔這一格」，**相同數字連在一起，就會合併成一個大格**，藉此拼出不對稱的版面。

**例子 1：左邊一張大圖，右邊兩張小圖**

```r
layout(matrix(c(1, 2,
                1, 3), nrow = 2, byrow = TRUE))
```

```text
+--------+-----+
|        |  2  |
|   1    +-----+
|        |  3  |
+--------+-----+
```

圖 1 佔左邊一整欄(因為兩格都是 1)，圖 2、3 各佔右邊上下。

**例子 2：上排 3 小張，下排 2 大張**

```r
layout(matrix(c(1, 1, 2, 2, 3, 3,
                4, 4, 4, 5, 5, 5), nrow = 2, byrow = TRUE))
```

```text
+----+----+----+
| 1  | 2  | 3  |
+----+----+----+
|   4    |   5   |
+--------+-------+
```

上排三張等寬(各佔 2 格)，下排兩張各佔 3 格、比上排寬，這就是不對稱版面。

**例子 3：一張主圖 + 周邊小圖**

```r
layout(matrix(c(1, 1, 2,
                1, 1, 3,
                4, 5, 6), nrow = 3, byrow = TRUE))
```

圖 1 佔左上 2×2 的大塊，其餘 2~6 是小圖環繞。

### 用 widths / heights 控制每格的相對大小

`layout()` 還能指定各列/欄的寬高比例，讓「等分的格子」拉成不等分：

```r
layout(matrix(c(1, 2,
                3, 4), nrow = 2, byrow = TRUE),
       widths  = c(2, 1),    # 左欄寬度是右欄的 2 倍
       heights = c(1, 2))    # 下列高度是上列的 2 倍
```

> `widths` 控制欄寬比例、`heights` 控制列高比例，兩者長度分別要等於矩陣的欄數、列數。

### 用 layout.show() 預覽版面

**函式簽名**

```r
layout.show(n = 區塊數量)   # n 為版面中共有幾個編號區塊
```

排版矩陣有點抽象，`layout.show()` 可以在真正畫圖前預覽格子編號和位置：

```r
layout(matrix(c(1, 1, 2, 2, 3, 3,
                4, 4, 4, 5, 5, 5), nrow = 2, byrow = TRUE))
layout.show(5)   # 5 = 有幾個區塊,會畫出標了編號的空格子
```

> 跑這行會顯示每個編號區塊的位置，確認版面對了再開始畫真正的圖。強烈建議每次設計新版面都先用 `layout.show()` 看一眼。

### 標準用法流程

```r
# 1. 設定版面
layout(matrix(c(1, 1, 2, 2, 3, 3,
                4, 4, 4, 5, 5, 5), nrow = 2, byrow = TRUE))

# 2. 依序畫圖,每個 plot() 自動填進下一個編號區塊
plot(...)   # 進區塊 1
plot(...)   # 進區塊 2
plot(...)   # 進區塊 3
plot(...)   # 進區塊 4
plot(...)   # 進區塊 5

# 3. 畫完重置,恢復成一個視窗一張圖
layout(1)
```

> `layout(1)`：把版面重置回預設的「一個視窗一張圖」，跟 `dev.off()`(關閉裝置)不同，`layout(1)` 只是取消多圖切割，裝置仍然開著。

---

## 重點速查表

| 主題 | 關鍵函式 |
|---|---|
| 基礎繪圖 | `plot`、`points`、`title` |
| 圖形裝置與匯出 | `jpeg`、`bmp`、`dev.off`、`graphics.off` |
| 點的樣式 | `col`、`pch`、`bg`、`cex` |
| 圖例 | `legend`、`locator` |
| 顏色系統 | `colors`、`gray.colors`、`rainbow`、`rgb` |
| 繪圖型態 | `type`(`"p"`、`"l"`、`"b"`、`"c"`、`"o"`、`"h"`、`"s"`、`"S"`、`"n"`) |
| 多圖版面 | `par(mfrow)`、`par(mfcol)`、`layout`、`layout.show`、`layout(1)`(重置) |

---

*本筆記依概念主題重新整理自 `4_1.R` ~ `4_10.R`*
