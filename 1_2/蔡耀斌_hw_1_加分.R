# 加分題 A
aa <- read.delim("SRBCT_train.txt") # 讀檔
bb <- as.matrix(aa[,-c(1,2)]) # 扣掉第 1、2 col，因為是 character
genes_name <- aa[, 1] # 取得基因名稱

# 進一步依「樣本層級的標準差（sample-wise sd）」對樣本排序，完成以下：
# 1.用 order() 找出 sd 最大的前 5 個樣本。
samples_sd <- apply(bb, 2, sd)
top_5_samples_sd <- order(samples_sd, decreasing = TRUE)[1:5]
top_5_samples_sd

# 2.用 rank() 算出每個樣本的 sd 排名。
rank_samples_sd <- rank(samples_sd)
rank_samples_sd

# 3.檢查 order() 得到的前 5 名，是否與 rank() 的結果一致。
N <- length(rank_samples_sd)

## 因為rank是從小到大，且沒辦法用decreasing，所以前五就是後五個值
top5_rank_samples_sd <- which(rank_samples_sd > N - 5)

## AI 
setequal(top_5_samples_sd, top5_rank_samples_sd)

# 4.對 sd 最大的那個樣本，找出其表現值最高的前 10 個基因。
max_sd_sample <- bb[, top_5_samples_sd[1]]
top10_genes_max_sample_sd <- order(max_sd_sample, decreasing = TRUE)[1:10]
top10_genes_max_sample_sd

# 5.做出一張 summary table，包含下列欄位：
#   樣本名稱、sample-wise sd、sd 排名，以及該樣本前 10 高表現基因的 Image Id 與表現值。
 
## 存放每個樣本前 10 高表現基因的值
top10_gene_expression <- array(vector("list", 63), dim = c(63, 1))

## 存放每個樣本前 10 高表現基因的Image Id
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
genes_sd <- apply(bb, 1, sd)
n_top30_cols <- ceiling(nrow(bb) * 0.3)
top30_genes_sd <- order(genes_sd, decreasing = TRUE)[1:n_top30_cols]

# 用 quantile(gene_sd, 0.7) 當門檻，取高於門檻者
th = quantile(genes_sd, 0.7)
top30_sd = genes_sd[genes_sd >= th] 

# 用 which() 回報這份資料下兩法各選出幾個。
## AI
n_top30_sd <- length(which(genes_sd >= th))
n_top30_genes_sd_simple <- length(top30_genes_sd)
# 比較兩者是否一致
n_top30_genes_sd_simple == n_top30_sd

# ------------------------------------------------------------------------------
# 加分題 C
# 用 hist() 畫出全部 gene 的 sd 分布，並用 abline(v = ...) 標出 top 30% 的切點。
## AI
hist(genes_sd, nclass = length(genes_sd))
abline(v = th, col = "red",  lwd = 2, lty = 2)    
















