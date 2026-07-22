aa <- read.delim("SRBCT_train.txt") # 讀檔
bb <- as.matrix(aa[,-c(1,2)]) # 扣掉第 1、2 col，因為是 character
dim(bb) # 觀察維度

# 題目一：Get mean & sd value for each gene cross samples
# 方法一 -> 創建空向量，一列一列計算平均值並填入
gene_cross_samples1 <- numeric(2308)
for (i in 1:2308){
  gene_cross_samples1[i] <- mean(bb[i, ])
}
gene_cross_samples1 # 輸出觀察

# 方法二 -> 使用 apply
gene_cross_samples2 <- apply(bb, 1, mean)
gene_cross_samples2 

# prompt : 除了以上兩種寫法，還有其他的嗎？
#      AI: 可以使用內建函式 rowMeans
# 方法三 -> 使用內建函式 rowMeans
gene_cross_samples3 <- rowMeans(bb)
gene_cross_samples3

# prompt : 如何驗證兩向量所有內容是否相同
#     AI : 可使用 all.equal(變數一, 變數二)
all.equal(gene_cross_samples1, gene_cross_samples2)
all.equal(gene_cross_samples1, gene_cross_samples3)

# ------------------------------------------------------------------------------
# 題目二：Get mean & sd value for each sample cross genes

sample_cross_genes1 <- numeric(63)

# 方法一
for (i in 1:63){
  sample_cross_genes1[i] = mean(as.numeric(bb[, i]))
}
sample_cross_genes1

# 方法二
sample_cross_genes2 <- apply(bb, 2, mean)
sample_cross_genes2

# 方法三
sample_cross_genes3 <- colMeans(bb)
sample_cross_genes3

# prompt : "names for current but not for target" 是什麼意思
#     AI :  用 numeric(63) 建立的向量，逐一填值後沒有 names，
#           colMeans 和 apply(bb, 2, mean) 都保留了矩陣 bb 的欄名，
#           要加上 check.attributes = FALSE，只比數值。
all.equal(sample_cross_genes1, sample_cross_genes2, check.attributes = FALSE)
all.equal(sample_cross_genes1, sample_cross_genes3, check.attributes = FALSE)

# ------------------------------------------------------------------------------
# Select top 30% genes with larger sd values
genes_sd <- numeric(2308)

for (i in 1:2308){
  genes_sd[i] = sd(as.numeric(bb[i, ]))
}

# prompt : ceiling是什麼函式
#     AI : 無條件進位，floor()（無條件捨去）、round()（四捨五入）
n_top30_cols <- ceiling(nrow(bb) * 0.3)
top30_genes_sd = order(genes_sd, decreasing = TRUE)[1:n_top30_cols]
top30_genes_sd

# ==============================================================================
# 加分題 A

genes_name <- aa[, 1] # 取得基因名稱
# 進一步依「樣本層級的標準差（sample-wise sd）」對樣本排序，完成以下：

# 1.用 order() 找出 sd 最大的前 5 個樣本。
samples_sd <- apply(bb, 2, sd)
top_5_samples_sd <- order(samples_sd, decreasing = TRUE)[1:5]
top_5_samples_sd

# 2.用 rank() 算出每個樣本的 sd 排名。
rank_samples_sd <- rank(samples_sd)

# 3.檢查 order() 得到的前 5 名，是否與 rank() 的結果一致。
N <- length(rank_samples_sd)

## 因為rank是從小到大，且沒辦法用decreasing，所以前五就是後五個值
top5_rank_samples_sd <- which(rank_samples_sd > N - 5)

## which 只會依照原始向量中的索引順序回傳符合條件的位置，所以我想要用集合的方式來比對結果
## prompt : R 有像 python 的 set() 語法嗎？
##     AI : R 沒有像 Python set() 那樣的專屬型態，但有一整組函數可以做集合運算，通常搭配一般向量。
##          intersect(a, b) 交集/ setdiff(a, b) 差集 / setequal(a, b)判斷兩集合是否相等
setequal(top_5_samples_sd, top5_rank_samples_sd)

# 4.對 sd 最大的那個樣本，找出其表現值最高的前 10 個基因。
max_sd_sample <- bb[, top_5_samples_sd[1]]
top10_genes_max_sample_sd <- order(max_sd_sample, decreasing = TRUE)[1:10]
top10_genes_max_sample_sd

# 5.做出一張 summary table，包含下列欄位：
#   樣本名稱、sample-wise sd、sd 排名，以及該樣本前 10 高表現基因的 Image Id 與表現值。

## prompt : 我想要跟python一樣創建2D Araay的空陣列[[],[],...,[]]，在Ｒ中如何實現
##     AI : R 沒有像 Python list 那樣可以直接放不同長度資料的陣列，
##          所以用 vector("list", n) 先建立 n 個空 list，再用 array() 包裝成指定維度

# 存放每個樣本前 10 高表現基因的值
top10_gene_expression <- array(vector("list", 63), dim = c(63, 1))
# 存放每個樣本前 10 高表現基因的Image Id
top10_gene_id <- array(vector("list", 63), dim = c(63, 1))

# 用迴圈跑每一個 col
for (i in 1:63){
    top10_gene_expression[[i]] <- sort(bb[, i], decreasing = TRUE)[1:10]
    idx <- order(bb[, i], decreasing = TRUE)[1:10] # 找到前十的原始 idx
    top10_gene_id[[i]] <- genes_name[idx] # 找到並存放 id
}

table <- data.frame("樣本名稱" = colnames(bb), "sample-wise sd" = samples_sd,
                    "sd 排名" = rank(samples_sd), 
                    "Top 10 Image Id" = top10_gene_id,
                    "Top 10 Gene Expression" = top10_gene_expression,
                    row.names = NULL)
# ------------------------------------------------------------------------------
# 加分題 B
# 用兩種方式選「高變異」基因：
# 主題目的「排序取前 30%」
# 用 quantile(gene_sd, 0.7) 當門檻，取高於門檻者
th = quantile(sd_genes, 0.7)
top30_sd = sd_genes[sd_genes >= th]

# 用 which() 回報這份資料下兩法各選出幾個。
## prompt : 如何用 which() 回報這份資料下兩法各選出幾個。(複製程式碼第64、65、128、129行)
##     AI : order() 那組取出來的數量本來就是固定的（[1:n_top30_cols] 已經限定筆數了），
##          所以真正需要用 which() 去確認「實際選出幾筆」的是門檻篩選法，
##          因為 >= 可能因為並列值（ties）而選出比預期多或少的數量
n_top30_sd <- length(which(sd_genes >= th))
n_top30_genes_sd_simple <- length(top30_genes_sd)
# 比較兩者是否一致
n_top30_sd == n_top30_genes_sd_simple

# ------------------------------------------------------------------------------
# 加分題 C
# 用 hist() 畫出全部 gene 的 sd 分布，並用 abline(v = ...) 標出 top 30% 的切點。

## prompt : abline()各參數代表的意思
##     AI : a:截距/ b:斜率/ h:畫水平線，數值代表y座標/ v：畫垂直線，數值代表x座標
##          col:顏色/ lwd：現粗細/ lty：線樣式
hist(sd_genes, nclass = length(genes_sd))
abline(v = th, col = "red",  lwd = 2, lty = 2) 
