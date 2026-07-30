# 加分題 A(最難)
# 用 normalize 後的 SRBCT_train.txt,分別計算每個 gene 在 EWS / BL / NB / RMS 四組樣本各自的平
# 均表現量, 接著找出符合下列三種表現樣式的 genes:
#   1. BL-low pattern:BL 組的平均低於 EWS、NB、RMS 三組各自的平均
#   2. EWS–NB-low pattern:EWS 與 NB 兩組的平均,低於 BL 與 RMS 兩組的平均
#   3. EWS–RMS-low pattern:EWS 與 RMS 兩組的平均,低於 BL 與 NB 兩組的平均
# 每一種 pattern 都以低表現的那一組(或兩組)為 target、其餘合併為 others, 對每個 gene 計算 SNR
# (signal-to-noise ratio),並挑出 SNR 值最小的那個 gene。
# SNR 公式:
#     SNR = (μtarget − μothers) / (σtarget + σothers)
# 其中 μ 為該群樣本在此 gene 的平均值、σ 為標準差。
# • 分子=兩群的平均差(訊號),分母=兩群的變異總和(雜訊)
# • 因為 target 是低表現的那一群,μtarget − μothers 會是負的,所以「SNR 最小」=負得最多=該 gene 在
# target 群壓得最低、且兩群各自夠集中
# • ⚠️ 注意分母是兩個標準差相加,不是合併後再算一次標準差

data_SRBCT <- read.delim("SRBCT_train.txt")
data1 <- as.matrix(data_SRBCT[ , -c(1:2)])
name1 <- data_SRBCT[,1]

min_max_norm <- function(x){
    (x - min(x)) / (max(x) - min(x))
}

data1_norm <- t(apply(data1, 1, min_max_norm))

