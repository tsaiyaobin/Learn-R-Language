aa <- read.delim("SRBCT_train.txt")
bb <- as.matrix(aa[,-c(1,2)])
sample <- colnames(bb)
gene <- aa[, 1]

# 進一步依「樣本層級的標準差（sample-wise sd）」對樣本排序，完成以下：
# 1.用 order() 找出 sd 最大的前 5 個樣本。
sd_samples <- apply(bb, 2, sd)
sd_samples_top_5 <- order(sd_samples, decreasing = TRUE)[1:5]
sd_samples_top_5

# 2.用 rank() 算出每個樣本的 sd 排名。
sd_samples_rank <- rank(sd_samples)
N <- length(sd_samples_rank)
sd_samples_rank_top5 <- which(sd_samples_rank > N - 5)
sd_samples_rank_top5

# 3.檢查 order() 得到的前 5 名，是否與 rank() 的結果一致。
setequal(sd_samples_top_5, sd_samples_rank_top5)

# 4.對 sd 最大的那個樣本，找出其表現值最高的前 10 個基因。
sd_top1_sample <- bb[, sd_samples_top_5[1]]
gene_top10 <- order(sd_top1_sample, decreasing = TRUE)[1:10]


# 5.做出一張 summary table，包含下列欄位：
#   樣本名稱、sample-wise sd、sd 排名，以及該樣本前 10 高表現基因的 Image Id 與表現值。
top10_gene_expression <- array(vector("list", 63), dim = c(63, 1))
top10_gene_id <- array(vector("list", 63), dim = c(63, 1))

for (i in 1:63){
    top10_gene_expression[[i]] <- sort(bb[, i], decreasing = TRUE)[1:10]
    idx <- order(bb[, i], decreasing = TRUE)[1:10]
    top10_gene_id[[i]] <- gene[idx]
}

table <- data.frame("樣本名稱" = colnames(bb), "sample-wise sd" = xssd_samples,
                    "sd 排名" = rank(sd_samples), 
                    "Image Id" = top10_gene_id,
                    "Gene Expression top 10" = top10_gene_expression,
                    row.names = NULL)
table


# 加分題 B
# 用兩種方式選「高變異」基因：
## 主題目的「排序取前 30%」
sd_genes <- apply(bb, 1, sd)
gene_top_30_percent <- order(sd_genes, decreasing = TRUE)[1:ceiling(nrow(bb) * 0.30)]

## 用 quantile(gene_sd, 0.7) 當門檻，取高於門檻者
th = quantile(sd_genes, 0.7)
top30_sd = sd_genes[sd_genes >= th]

## 用 which() 回報這份資料下兩法各選出幾個。
n_method1 <- length(which(sd_genes %in% sd_genes[gene_top_30_percent]))
n_method2 <- length(which(sd_genes >= th))

# 加分題 C
# 用 hist() 畫出全部 gene 的 sd 分布，並用 abline(v = ...) 標出 top 30% 的切點。
hist(sd_genes, nclass = length(sd_genes))
abline(v = th, col = "red",  lwd = 2, lty = 2)  






