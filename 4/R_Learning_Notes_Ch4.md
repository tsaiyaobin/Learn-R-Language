# R 語言筆記：基礎繪圖(plot)、圖形裝置與顏色系統

> 整理自 `4_1.R` ~ `4_8.R` 練習內容,依概念重新分類,方便複習與查閱。

[TOC]

---

## 一、plot() 基礎散佈圖

**plot()** : R 最基本的繪圖函數，依資料型態自動決定畫法。對兩欄數值資料，預設畫出散佈圖(scatter plot)。

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

> `plot()` 直接傳入矩陣時,只認得兩種形狀:
> - 1 欄(`ncol = 1`) : 當成一組 y 值，x 軸自動用 `1, 2, 3...` (index)
> - 2 欄(`ncol = 2`) : 第一欄當 x,第二欄當 y，畫成一組 (x, y) 點

---

## 二、圖形裝置 (Graphic Device) 與檔案匯出

R 的繪圖分成兩步 : 先「開啟一個圖形裝置」,接著在裝置上畫圖，最後用 `dev.off()` 關閉裝置、完成輸出。

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

| 參數 | 效果 |
|---|---|
| `res` | 每英吋像素數(pixels per inch),預設 72，常見印刷品質為 300 |
| `units` | 預設 `"px"`。改成 `"in"`(或 `"cm"`、`"mm"`)後，width/height 代表實際物理尺寸 ; 搭配 `res` 決定輸出的像素尺寸(例如 6.4in × 300ppi = 1920px) |

> `title()` 可在既有圖上補加標題,不必重新畫圖。

### 一次關閉所有圖形裝置

```r
graphics.off()   # 關閉所有圖形裝置,重置
```

> `dev.off()` 只關閉「目前」的裝置，`graphics.off()` 則會把所有開啟中的圖形裝置全部關掉並重置,兩者用途不同。

---

## 三、點的顏色與形狀 : col、pch

**points()** : 既有的圖上疊加新的點，常搭配 `plot(..., type = 'n')` 或現成的 `plot()` 圖層使用。

```r
plot(data, xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scatter Plots of ", length(data), "Synthetic Samples", sep = ""))

points(data[1:10], col = 1, pch = 21, bg = 2)
points(x = 11:20, y = data[11:20], col = 1, pch = 21, bg = 3)
```

> - `col` : 點的顏色(邊框顏色)。R 內建數字對應色票:`1 = 黑`、`2 = 紅`、`3 = 綠`、`4 = 藍`、`5 = 青`、`6 = 洋紅`、`7 = 黃`、`8 = 灰`...
> - `pch` : 點的形狀代碼(plotting character)。`pch = 21` 是「實心圓圈，邊框和內部填色可以分開設定」
>> - `pch 21~25` 這幾種形狀(圓形、方形、菱形、三角形等)才支援 `bg` 填色參數，其餘 `pch(0~20)` 只有單一 `col` 決定顏色

**常見地雷**:`points(data[11:20], ...)` 只給了一個向量，R 會把它當成 y 值，x 座標自動用 `seq_along()` 生成，也就是 `1, 2, 3...10` — 而不是想要的 `11~20` ! 結果這組點會畫到 x = 1~10 的位置，跟第一組樣本重疊。要畫在正確的 x 位置，必須明確指定 `x = 11:20`。

### 用向量一次指定多組顏色/形狀

```r
col_lab <- c(rep(1, 10), rep(2, 10), rep(3, 10), rep(4, 10), rep(5, 10))

plot(data, col = col_lab, pch = col_lab, 
     xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scatter Plots of ", length(data), "Synthetic Samples", sep = ""))
```

> `col`、`pch` 都可以直接傳入一個跟資料等長的向量，R 會逐點對應上色/換形狀，不必手動呼叫多次 `points()`。

---

## 四、點的大小 : cex

**cex**(character expansion):控制點或文字的縮放倍率,預設為 1。

```r
plot(data, pch = 21, bg = col_lab, 
     cex = col_lab, xlab = "Samples", ylab = "Gene Expression values",
     main = paste("Scatter Plots of ", length(data), "Synthetic Samples", sep = ""))
```

> 這裡把 `cex = col_lab` 直接用分組標籤(1~5)當縮放倍率，同一組的點顏色(`bg`)跟大小(`cex`)一起變化，方便肉眼區分不同群組。

---

## 五、圖例 : legend()

**legend()** : 替圖表加上圖例,說明每種顏色/形狀代表的意義。位置可以用「座標」或「關鍵字」兩種方式指定。

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

> `legend()` 的第一個參數可以是座標(x, y)，也可以用 `locator(1)` 讓使用者手動點選位置,不必猜測數值。

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

> - R 支援的關鍵字位置有 : `"topleft"`、`"top"`、`"topright"`、`"left"`、`"center"`、`"right"`、`"bottomleft"`、`"bottom"`、`"bottomright"`，對應繪圖區域的九宮格位置
> - `inset` : 讓圖例框往繪圖區域內縮一點距離，避免貼到邊框

---

## 六、顏色系統 : colors()、gray.colors()、rainbow()、rgb()

R 提供多種方式產生顏色,適合不同情境。

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
| `rainbow(n)` | 產生 n 種色相均勻分布的顏色,適合分類配色 | 十六進位色碼字串向量 |
| `rgb(r, g, b, maxColorValue = 255)` | 依 RGB 數值自訂單一顏色 | 單一十六進位色碼字串 |

---    

## 七、plot() 的 type 參數

**type** : 控制 `plot()` 要把資料畫成「點」還是「線」，或兩者都畫。前面章節用過的 `type = 'n'`(不畫任何東西,只留座標軸)只是其中一種。

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

> `type = 'n'` 很常用來「先畫出空的座標系統」， 再用 `points()`、`lines()`、`legend()` 等函數手動疊圖層，取得更精細的排版控制。
---

## 重點速查表

| 主題 | 關鍵函式 |
|---|---|
| 基礎繪圖 | `plot` `points` `title` |
| 圖形裝置與匯出 | `jpeg` `bmp` `dev.off` `graphics.off` |
| 點的樣式 | `col` `pch` `bg` `cex` |
| 圖例 | `legend` `locator` |
| 顏色系統 | `colors` `gray.colors` `rainbow` `rgb` |
| 繪圖型態 | `type`(`"p"` `"l"` `"b"` `"c"` `"o"` `"h"` `"s"` `"S"` `"n"`) |

---

*本筆記依概念主題重新整理自 `4_1.R` ~ `4_8.R`*
