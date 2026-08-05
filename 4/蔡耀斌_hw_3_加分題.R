# 加分題 A(最難)
data_SRBCT <- read.delim("SRBCT_train.txt")
data1 <- as.matrix(data_SRBCT[ , -c(1:2)])
Image_id <- data_SRBCT[,1]

# 用 normalize 後的 SRBCT_train.txt,分別計算每個 gene 在 EWS / BL / NB / RMS 四組樣本各自的平均表現量
min_max_norm <- function(x){
    (x - min(x)) / (max(x) - min(x))
}
data1_norm <- t(apply(data1, 1, min_max_norm))

# 取得所有欄位名稱
cols <- colnames(data1)
labels <- sub("\\..*", "", cols)

# 取出 EWS / BL / NB / RMS 四組樣本各自的資料
EWS_data <- data1_norm[, which(labels == "EWS")]
BL_data <- data1_norm[, which(labels == "BL")]
NB_data <- data1_norm[, which(labels == "NB")]
RMS_data <- data1_norm[, which(labels == "RMS")]

# 四組樣本各自的平均表現量
EWS_data_mean <- apply(EWS_data, 1, mean)
BL_data_mean <- apply(BL_data, 1, mean)
NB_data_mean <- apply(NB_data, 1, mean)
RMS_data_mean <- apply(RMS_data, 1, mean)
# ------------------------------------------------------------------------------

#   接著找出符合下列三種表現樣式的 genes

# SNR 公式:
#     SNR = (μtarget − μothers) / (σtarget + σothers)
# 其中 μ 為該群樣本在此 gene 的平均值、σ 為標準差。
SNR <- function(t_mean, t_sd, o_mean, o_sd){
    (t_mean - o_mean) / (t_sd + o_sd)
}

#   1. BL-low pattern:BL 組的平均低於 EWS、NB、RMS 三組各自的平均
bl_low_rows <- which(BL_data_mean < EWS_data_mean & 
                     BL_data_mean < NB_data_mean & 
                     BL_data_mean < RMS_data_mean)
bl_low_rows # 觀察

# 過濾:只留下 BL 組的平均低於 EWS、NB、RMS 三組各自平均的資料
bl_low_data <- data1_norm[bl_low_rows, ]
bl_low_data

# 對每個 gene 計算 SNR (signal-to-noise ratio), 並挑出 SNR 值最小的那個 gene。

# target為過濾後 BL 類別的資料，其餘為 others
# 計算 target、others 的 mean、sd，以計算 snr
target1 <- bl_low_data[, which(labels == "BL")]
target1_mean <- apply(target1, 1, mean)
target1_sd <- apply(target1, 1, sd)

others1 <- bl_low_data[, -which(labels == "BL")]
others1
others1_mean <- apply(others1, 1, mean)
others1_sd <- apply(others1, 1, sd)

snr1 <- SNR(target1_mean, target1_sd, others1_mean, others1_sd)
idx1 <- which.min(snr1) # 索引相對於 bl_low_data
# ------------------------------------------------------------------------------

#   2. EWS–NB-low pattern : EWS 與 NB 兩組的平均, 低於 BL 與 RMS 兩組的平均

EWS_NB_low_rows <- which(EWS_data_mean < RMS_data_mean & EWS_data_mean < BL_data_mean &
                         NB_data_mean  < RMS_data_mean & NB_data_mean  < BL_data_mean)

# 過濾:只留下 EWS 與 NB 兩組的平均, 低於 BL 與 RMS 兩組的平均的資料
EWS_NB_low_data <- data1_norm[EWS_NB_low_rows, ]

target2 <- EWS_NB_low_data[, which(labels == "EWS" | labels == "NB")]
target2_mean <- apply(target2, 1, mean) 
target2_sd <- apply(target2, 1, sd)

others2 <- EWS_NB_low_data[, -which(labels == "EWS" | labels == "NB")]
others2_mean <- apply(others2, 1, mean)
others2_sd <- apply(others2, 1, sd)

snr2 <- SNR(target2_mean, target2_sd, others2_mean, others2_sd)
idx2 <- which.min(snr2) # 索引相對於 EWS_NB_low_data
# ------------------------------------------------------------------------------

#   3. EWS–RMS-low pattern : EWS 與 RMS 兩組的平均, 低於 BL 與 NB 兩組的平均
EWS_RMS_low_rows <- which(EWS_data_mean < BL_data_mean & EWS_data_mean < NB_data_mean &
                          RMS_data_mean < BL_data_mean & RMS_data_mean < NB_data_mean)

EWS_RMS_low_data <- data1_norm[EWS_RMS_low_rows, ] 

target3 <- EWS_RMS_low_data[, which(labels == "EWS"|labels == "RMS")]
target3_mean <- apply(target3, 1, mean)
target3_sd <- apply(target3, 1, sd)

others3 <- EWS_RMS_low_data[, -which(labels == "EWS"|labels == "RMS")]
others3_mean <- apply(others3, 1, mean)
others3_sd <- apply(others3, 1, sd)

snr3 <- SNR(target3_mean, target3_sd, others3_mean, others3_sd)
idx3 <- which.min(snr3) # 索引相對於 EWS_RMS_low_data
# ------------------------------------------------------------------------------
# 畫出所選 gene 在全部樣本上的 normalized 表現量 scatter plot
# 用四種不同顏色 + 四種不同符號分別代表 EWS / BL / NB / RMS(每組各自一種顏色與一種符號)

# 幫四種類別設定顏色跟點類型
categories <- c("EWS", "BL", "NB", "RMS")
color <- c(EWS = "blue", BL = "green", NB = "red", RMS = "black")
pch <- c(EWS = 16, BL = 17, NB = 15, RMS = 18)
col_color <- color[labels]
col_pch <- pch[labels]

# ------------------------------------------------------------------------------
# picture1
gene_expr1 <- data1_norm[bl_low_rows[idx1], ]   # 這個 gene 在所有樣本的 normalized 值
plot(gene_expr1, col = col_color, pch = col_pch,
     xlab = "Samples index", ylab = "Each Samples Expression",
     main = paste("Image ID :", Image_id[bl_low_rows[idx1]]))

legend("topright", legend = categories,
       col = color[categories], pch = pch[categories])

# ------------------------------------------------------------------------------
# picture2
gene_expr2 <- data1_norm[EWS_NB_low_rows[idx2], ]   # 這個 gene 在所有樣本的 normalized 值
plot(gene_expr2, col = col_color, pch = col_pch,
     xlab = "Samples index", ylab = "Each Samples Expression",
     main = paste("Image ID :", Image_id[EWS_NB_low_rows[idx2]]))

legend("topright", legend = categories,
       col = color[categories], pch = pch[categories])
# ------------------------------------------------------------------------------
# picture3
gene_expr3 <- data1_norm[EWS_RMS_low_rows[idx3], ]   # 這個 gene 在所有樣本的 normalized 值
plot(gene_expr3, col = col_color, pch = col_pch,
     xlab = "Samples index", ylab = "Each Samples Expression",
     main = paste("Image ID :", Image_id[EWS_RMS_low_rows[idx3]]))

legend("topright", legend = categories,
       col = color[categories], pch = pch[categories])

# ==============================================================================
# 加分題 B
# 用 par(mfrow = ...) 把主題目第 3、4 點的四張 scatter plot 排成一張組合圖,
# 但不要用方方正正的 2×2 等分排版。請自己設計版面

## 我想把第四點的兩張圖放在第一列（大圖），三張個別個案例在第二列（小圖）
#  +-----+-----+-----+
#  |   1    |    2   |   ← 第4點的兩張,較寬
#  +-----+-----+-----+
#  | 3   |  4  |  5  |    ← 第3點的三張
#  +--------+--------+
# 準備想要視覺化的資料
plot_data1 <- rbind(data1_norm[which(Image_id == 770394), ],
                    data1_norm[which(Image_id == 814260), ], 
                    data1_norm[which(Image_id == 491565), ])

# – Perform scatter plots for Image ID “770394” vs “236282”

Image_id_770394 <- data1_norm[which(Image_id == 770394), ]
Image_id_236282 <- data1_norm[which(Image_id == 236282), ]

# – Perform scatter plots for Image ID “812105” vs “784224”
Image_id_812105 <- data1_norm[which(Image_id == 812105), ]
Image_id_784224 <- data1_norm[which(Image_id == 784224), ]


# AI
layout(matrix(c(1, 1, 1, 2, 2, 2,
                3, 3, 4, 4, 5, 5), nrow = 2, byrow = TRUE),
       heights = c(2, 1) # 上列高度是下列的 2 倍
       )

plot(Image_id_770394, Image_id_236282, col = col_color, pch = col_pch, 
     xlab = "ID : 770394", ylab = "ID : 236282")

plot(Image_id_812105, Image_id_784224, col = col_color, pch = col_pch, 
     xlab = "ID : 812105", ylab = "ID : 784224")

# 不同 ID 不同點樣式，不同顏色
for (i in 1:3){
    # x 軸是樣本數，y 軸是基因表數
    plot(plot_data1[i, ], col = col_color, pch = col_pch, cex = 0.8, 
         xlab = "Samples index", ylab = "Each Samples Expression")
}
# 畫完重置,恢復成一個視窗一張圖
layout(1)

# 加分題 C
# 改用 cycleData_peak.txt 這份資料(酵母菌細胞週期, 800 genes × 77 個時間點,
#                                  最後一欄 peak 是該 gene 的高峰期別)。

cycleData_peak <- read.delim("cycleData_peak.txt")
data2 <- as.matrix(cycleData_peak[, -c(1, ncol(cycleData_peak))]) # 只保留數值資料
cols2 <- colnames(data2)
cols2 # 觀察

# AI
labels2 <- sub("\\..*|[0-9]+$", "", cols2)
table(labels2) # 檢查名稱有沒有分錯

# 1. peak 欄共有 5 種期別:G1 / G2/ M / S/G2 / M/G1 / S
## 將五種 peak 類別各自取出
G1 <- which(cycleData_peak[, ncol(cycleData_peak)] == 'G1')
G2_M <- which(cycleData_peak[, ncol(cycleData_peak)] == 'G2/M')
M_G1 <- which(cycleData_peak[, ncol(cycleData_peak)] == 'M/G1')
S <- which(cycleData_peak[, ncol(cycleData_peak)] == 'S')
S_G2 <- which(cycleData_peak[, ncol(cycleData_peak)] == 'S/G2')
# ------------------------------------------------------------------------------

# 2. 從每一種期別中, 自己挑一個沒有缺值(NA) 的 gene(共挑 5 個)
## 我挑每類別中沒有缺值的第一筆資料
G1_no_Na <- G1[which(apply(is.na(data2[G1, ]), 1, sum) == 0)[1]]
G2_M_no_Na <- G2_M[which(apply(is.na(data2[G2_M, ]), 1, sum) == 0)[1]]
M_G1_no_Na <- M_G1[which(apply(is.na(data2[M_G1, ]), 1, sum) == 0)[1]]
S_no_Na <- S[which(apply(is.na(data2[S, ]), 1, sum) == 0)[1]]
S_G2_no_Na <- S_G2[which(apply(is.na(data2[S_G2, ]), 1, sum) == 0)[1]]

# 檢查挑選的資料是否有缺值，與peak類別是否正確
sum(is.na(data2[G1_no_Na, ]))
cycleData_peak[G1_no_Na, ncol(cycleData_peak)]
sum(is.na(data2[G2_M_no_Na, ]))
cycleData_peak[G2_M_no_Na, ncol(cycleData_peak)]
sum(is.na(data2[M_G1_no_Na, ]))
cycleData_peak[M_G1_no_Na, ncol(cycleData_peak)]
sum(is.na(data2[S_no_Na, ]))
cycleData_peak[S_no_Na, ncol(cycleData_peak)]
sum(is.na(data2[S_G2_no_Na, ]))
cycleData_peak[S_G2_no_Na, ncol(cycleData_peak)]

# ------------------------------------------------------------------------------

# 3. 為這 5 個 gene 各畫一張 scatter plot(表現量隨時間點變化)
# 4. 用 rainbow() 或自訂色系上色,並加上 legend
# 上色規則:這份資料的 77 個欄位分屬數種實驗條件,每種條件底下是一系列時間點(alpha 18 欄 / cdc15
#                                         24 欄 / cdc28 17 欄 / elu 14 欄 / cln3 2 欄 / clb2 2 欄)。
# 同一個實驗條件的所有時間點用同一種顏色, 不同條件用不同顏色。

categories2 <- unique(labels2)

# 設定不同時間點的顏色
color2 <- c("alpha" = "#003E19", "cdc15" = "#EECB27", "cdc28" = "#E13239", 
            "elu" = "#1F1762", "cln3" = "#A13E97", "clb2" = "#5BBDC8")

# 設定不同時間點的點樣式
pch2 <- c("alpha" = 15, "cdc15" = 16, "cdc28" = 17, 
          "elu" = 18, "cln3" = 19, "clb2" = 20)

# 套用到所有時間點
col_color2 <- color2[labels2]
col_pch2 <- pch2[labels2]

# G1
plot(data2[G1_no_Na, ], col = col_color2, pch = col_pch2, xlab = "Samples idx", ylab = "Expression")

legend("topright", legend = categories2,
       col = color2[categories2], pch = pch2[categories2], cex = 0.6)

title("G1 peak gene")
# ------------------------------------------------------------------------------
# G2/M
plot(data2[G2_M_no_Na, ], col = col_color2, pch = col_pch2, xlab = "Samples idx", ylab = "Expression")

legend("topright", legend = categories2,
       col = color2[categories2], pch = pch2[categories2], cex = 0.6)

title("G2/M peak gene")

# ------------------------------------------------------------------------------
# M/G1
plot(data2[M_G1_no_Na, ], col = col_color2, pch = col_pch2, xlab = "Samples idx", ylab = "Expression")

legend("topright", legend = categories2,
       col = color2[categories2], pch = pch2[categories2], cex = 0.6)

title("M/G1 peak gene")

# ------------------------------------------------------------------------------
# S
plot(data2[S_no_Na, ], col = col_color2, pch = col_pch2, xlab = "Samples idx", ylab = "Expression")

legend("topright", legend = categories2,
       col = color2[categories2], pch = pch2[categories2], cex = 0.6)

title("S peak gene")

# ------------------------------------------------------------------------------
# S/G2
plot(data2[S_G2_no_Na, ], col = col_color2, pch = col_pch2, xlab = "Samples idx", ylab = "Expression")

legend("topright", legend = categories2,
       col = color2[categories2], pch = pch2[categories2], cex = 0.6)

title("S/G2 peak gene")















