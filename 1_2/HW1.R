aa <- read.delim("C:\\Users\\USER\\Desktop\\Learn_R\\data\\SRBCT_train.txt")
bb <- as.matrix(aa[,-c(1,2)])
bb
dim(bb)

gene_cross_samples1 <- numeric(2308)
gene_cross_samples1

for (i in 1:2308){
  gene_cross_samples1[i] <- mean(as.numeric(bb[i, ]))
}
gene_cross_samples1

# 進階寫法
gene_cross_samples2 <- rowMeans(bb)  
gene_cross_samples2

all(gene_cross_samples1 == gene_cross_samples2)


# ------------------------------------------------------------------------------
sample_cross_genes1 <- numeric(63)

for (i in 1:63){
  sample_cross_genes1[i] = mean(as.numeric(bb[, i]))
}
sample_cross_genes1

# 進階寫法
sample_cross_genes2 <- colMeans(bb)
sample_cross_genes2
all(sample_cross_genes1 == sample_cross_genes2)
# ------------------------------------------------------------------------------
sd_genes <- numeric(2308)
for (i in 1:2308){
  sd_genes[i] = sd(as.numeric(bb[i, ]))
}
sd_genes
th = quantile(sd_genes, 0.7)
top30_sd = sd_genes[sd_genes >= th]
top30_sd

