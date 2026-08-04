# Loading Leukemia Data

## 急性淋巴白血病 (ALL) 基因表現資料
BiocManager::install("ALL") # download the latest version suited to your R version.
library(ALL)                # load the package into R
data(ALL)                   # manually load a specific data into R
ALL                         # 顯示資料集;它是一個 ExpressionSet 類別的物件
                            # (同時包含表現量、臨床資料、基因註解)

# exprs(某物件)        # 取表現量矩陣
# varLabels(某物件)    # 取臨床變數名稱
# pData(某物件)        # 取樣本臨床資料表 (phenotype data)
# sampleNames(某物件)  # 取樣本名稱
# featureNames(某物件) # 取基因/probe 名稱

exprs(ALL)[1:3, ]           # 取出「基因表現量矩陣」,看前 3 個基因(列=基因, 欄=樣本)
varLabels(ALL)              # 列出所有臨床變數的名稱(例如 mol.bio、BT ...)

# 依分子生物分型 mol.bio 把樣本重新排序,讓同一型的樣本排在一起
ALL.1 <- ALL[, order(ALL $ mol.bio)] 
ALL.1 $ mol.bio             # 檢視排序後每個樣本的分型

##### 用全部 12625 個基因,畫出 128 個樣本之間的相關性熱圖 #####
# cor(...) 計算「樣本 vs 樣本」的相關係數矩陣 (128 x 128)
heatmap(cor(exprs(ALL.1)),
        Rowv = NA, Colv = NA,        # 不做階層分群、不重排;保留剛剛的排序
        scale = "none",              # 不對數值做標準化
        labRow = ALL.1$mol.bio,      # 列的標籤用分型名稱
        labCol = ALL.1$mol.bio,      # 欄的標籤用分型名稱
        RowSideColors = as.character(as.numeric(ALL.1$mol.bio)),  # 列側彩條:用顏色標分型
        ColSideColors = as.character(as.numeric(ALL.1$mol.bio)))  # 欄側彩條:用顏色標分型

## 在相關性圖中,NEG 這一群其實有兩個亞群:
## 一個是 B 細胞型 (BT = B),另一個是 T 細胞型 (BT = T)
ALL$BT  # 檢視每個樣本是 B 細胞還是 T 細胞

# 白血病資料前處理 (Preprocessing)
## 只選 BCR/ABL 與 NEG 這兩組樣本
bio <- which(ALL$mol.bio %in% c("BCR/ABL", "NEG"))
## 只選 B 細胞型(BT 以 "B" 開頭),排除 T 細胞
isb <- grep("^B", as.character(ALL$BT))

## 取交集:同時是「B 細胞」且屬於「BCR/ABL 或 NEG」的樣本
kp <- intersect(bio, isb)
ALL.2 <- ALL[, kp]  # 取出符合條件的樣本子集

# 建立一個乾淨的二分類分組欄位
tmp <- ALL.2$mol.bio == "BCR/ABL"         # 是 BCR/ABL 為 TRUE, 否則 FALSE
tmp <- ifelse(tmp, "BCR/ABL", "NEG")      # 轉成文字標籤
pData(ALL.2)$bcrabl <- factor(tmp)        # 加入臨床資料表,並轉成 factor(供後續統計分組用)
ALL.2$bcrabl                              # 檢視最終分組結果
