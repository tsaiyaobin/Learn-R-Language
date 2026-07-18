path = "/Users/austin/Desktop/Learn_R/Learn-R-Language/data/"
aa <- read.delim(paste(path, "SRBCT_train.txt", sep = ""))
bb <- as.matrix(aa[,-c(1,2)])
sample <- colnames(bb)
gene <- aa[, 1]
dim(bb)

# Get mean & sd value for each gene cross samples
gene_cross_samples1 <- numeric(2308)
gene_cross_samples1

for (i in 1:2308){
  gene_cross_samples1[i] <- mean(as.numeric(bb[i, ]))
}
gene_cross_samples1

# 方法二
gene_cross_samples2 <- rowMeans(bb)  
gene_cross_samples2

all(gene_cross_samples1 == gene_cross_samples2)


# ------------------------------------------------------------------------------
# Get mean & sd value for each sample cross genes

sample_cross_genes1 <- numeric(63)

for (i in 1:63){
  sample_cross_genes1[i] = mean(as.numeric(bb[, i]))
}
sample_cross_genes1

# 方法二
sample_cross_genes2 <- colMeans(bb)
sample_cross_genes2

all(sample_cross_genes1 == sample_cross_genes2)


# ------------------------------------------------------------------------------
# Select top 30% genes with larger sd values

sd_genes <- numeric(2308)

for (i in 1:2308){
  sd_genes[i] = sd(as.numeric(bb[i, ]))
}

th = quantile(sd_genes, 0.7)
top30_sd = sd_genes[sd_genes >= th]
top30_sd

