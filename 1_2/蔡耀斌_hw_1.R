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

