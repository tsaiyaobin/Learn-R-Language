aa <- read.delim("SRBCT_train.txt") # 讀檔
bb <- as.matrix(aa[,-c(1,2)]) # 扣掉第 1、2 col，因為是 character
dim(bb) # 觀察維度

# 題目一：Get mean & sd value for each gene cross samples

# 求 means
# 方法一 -> 使用 apply
mean_gene_cross_samples1 <- apply(bb, 1, mean)
mean_gene_cross_samples1


# AI 
all.equal(mean_gene_cross_samples1, mean_gene_cross_samples2)

# 求 sd
sd_gene_cross_samples <- apply(bb, 1, sd)
sd_gene_cross_samples

# ------------------------------------------------------------------------------
# 題目二：Get mean & sd value for each sample cross genes

# 求 means
# 方法一
mean_sample_cross_genes1 <- apply(bb, 2, mean)


# 方法二
mean_sample_cross_genes2 <- colMeans(bb)

# AI
all.equal(mean_sample_cross_genes1, mean_sample_cross_genes2)

# 求 sd
sd_sample_cross_genes <- apply(bb, 2, sd)
sd_sample_cross_genes
# ------------------------------------------------------------------------------
# Select top 30% genes with larger sd values
# AI 
n_top30_cols <- ceiling(nrow(bb) * 0.3)
top30_genes_sd <- order(sd_gene_cross_samples, decreasing = TRUE)[1:n_top30_cols]
top30_genes_sd

