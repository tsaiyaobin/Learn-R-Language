# Dataframe and Matrix
accounts <- data.frame(state = c("PA", "CA", "MA"),
                       income = c(1000, 1100, 900),
                       married = c(T, F, F))
accounts
## 看屬性（欄位名、列名、class）
attributes(accounts) 
## 每欄的型態、內容概覽
str(accounts)

## matrix 轉 dataframe
mat <- matrix(data = 1:35, nrow = 5, ncol = 7)  # 欄、列都是[1,] [2,]...
mat
dat <- as.data.frame(mat)                       # 有欄名(v1,v2...) 與 列號(1,2...)
dat

## 取值差異
### dataframe
str(dat)      # 5 obs. of  7 variables (5 筆觀測值, 7個變數)
dat$V1        # 等價於 dat[,1]

### matrix
mat[, 1]
colnames(mat) # 預設為 Null
# 加欄位名
colnames(mat) <- paste("V", 1:dim(mat)[2], sep = "")
mat[, "V1"]   # matrix 即使加了欄位名，也無法用 $ 取值




