data_SRBCT <- read.delim("SRBCT_train.txt")
data1 <- as.matrix(data_SRBCT[ , -c(1:2)])
Image_id <- data_SRBCT[,1]

min_max_norm <- function(x){
    (x - min(x)) / (max(x) - min(x))
}

data1_norm <- t(apply(data1, 1, min_max_norm))

# 取得所有欄位名稱
cols <- colnames(data1)
labels <- sub("\\..*", "", cols)
categories = c("EWS", "BL", "NB", "RMS")

# 幫四種類別設定顏色跟點類型
color <- c("EWS" = "blue", "BL" = "green", "NB" = "red", "RMS" = "black") 
pch <- c("EWS" = 15, "BL" = 16, "NB" = 17, "RMS" = 18) 

# 套用到每一欄
col_color <- color[labels]
col_pch <- pch[labels]

# – Perform scatter plots for Image ID “770394”, “814260”, and “491565”
# – Diff. colors, symbols & legends for samples in diff. categories

# 準備想要視覺化的資料
plot_data1 <- rbind(data1_norm[which(Image_id == 770394), ],
                    data1_norm[which(Image_id == 814260), ], 
                    data1_norm[which(Image_id == 491565), ])
# 標題列
title_lst1 <- c("Image ID : 770394", "Image ID : 814260", "Image ID : 491565")

# 不同 ID 不同點樣式，不同顏色
for (i in 1:3){
    
    # x 軸是樣本數，y 軸是基因表數
    plot(plot_data1[i, ], col = col_color, pch = col_pch, cex = 0.8, 
         xlab = "Samples index", ylab = "Each Samples Expression")
    
    title(title_lst1[i])
    
    legend("topright", legend = categories, 
           col = color[categories],  pch = pch[categories], cex = 0.8)
}

# ------------------------------------------------------------------------------
# – Perform scatter plots for Image ID “770394” vs “236282”
# – Diff. colors, symbols & legends for samples in diff. categories

Image_id_770394 <- data1_norm[which(Image_id == 770394), ]
Image_id_236282 <- data1_norm[which(Image_id == 236282), ]


plot(Image_id_770394, Image_id_236282, col = col_color, pch = col_pch, 
     xlab = "ID : 770394", ylab = "ID : 236282")

title("Image ID : 770394 vs 236282")

legend("topright", legend = categories, 
       col = color[categories],  pch = pch[categories], cex = 0.8)

# ------------------------------------------------------------------------------
# – Perform scatter plots for Image ID “812105” vs “784224”
# – Diff. colors, symbols & legends for samples in diff. categories
Image_id_812105 <- data1_norm[which(Image_id == 812105), ]
Image_id_784224 <- data1_norm[which(Image_id == 784224), ]


plot(Image_id_812105, Image_id_784224, col = col_color, pch = col_pch, 
     xlab = "ID : 812105", ylab = "ID : 784224")

title("Image ID : 812105 vs 784224")

legend("topright", legend = categories, 
       col = color[categories],  pch = pch[categories], cex = 0.8)






