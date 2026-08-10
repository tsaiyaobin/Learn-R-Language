set.seed(1024)
my.samples <- c(rep(1, 10), rep(2, 10), rep(3, 10), rep(4, 10))

ng <- max(my.samples)
ns <- length(my.samples)

my.data <- NULL

for(i in 1:ng){
    my.exprs <- rnorm(ns, 0.15, 0.05)
    my.exprs[which(my.samples == i)] <- rnorm(length(which(my.samples == i)), 0.8, 0.05)
    my.data <- rbind(my.data, my.exprs)
}
    

rownames(my.data) <- paste("Gene", 1:4)

library(gplots)
# ============================================================
# 步驟一:建立「欄位側邊顏色條」的顏色向量
# ============================================================
# factor(my.samples, ...) 把數值 1,2,3,4 轉成因子(分類變數),
#   並用 label= 指定每一「層(level)」對應的文字標籤:
#   數值 1 → "black"、2 → "red"、3 → "green"、4 → "blue"
#   as.character(...) 再把因子轉回純文字向量,
#   得到長度 40 的顏色字串:前 10 個 "black"、接著 10 個 "red"…
#   這個向量之後會餵給 ColSideColors,用來畫在熱圖上方那條分組色帶。
my.colors <- as.character(factor(my.samples, label = c("black", "red", "green", "blue")))

# ============================================================
# 步驟二:繪製熱圖 (heatmap.2 來自 gplots 套件)
# ============================================================
heatmap.2(
    my.data,                        # 要畫的資料矩陣(4 個基因 × 40 個樣本)
    
    Rowv = F,                       # 不對「列(基因)」做階層分群、不重新排序列
                                    #   (F 等同 FALSE;維持原本 Gene1~Gene4 的順序)
    
    Colv = F,                       # 不對「欄(樣本)」做分群、不重新排序欄
                                    #   (維持樣本 1~40 的原始順序)
    
    dendrogram = "none",            # 不畫任何樹狀圖(dendrogram)
                                    #   因為上面已關閉列與欄的分群
    
    col = bluered(16)[-c(1:2, 8:9, 15:16)],
    # 設定色階(顏色由低到高)
    # bluered(16):產生 16 色、由藍→白→紅的漸層
    # [-c(1:2, 8:9, 15:16)]:用負索引「刪掉」
    #   第 1,2 / 8,9 / 15,16 這幾個顏色,
    #   剩下 10 色。刪頭尾兩端是為了拿掉太深的
    #   藍與紅,刪中間 8,9 是為了拿掉太接近白的顏色,
    #   讓藍與紅的對比更鮮明。
    
    symkey = FALSE,                 # 色鍵(color key)不要以 0 為中心對稱
    symbreaks = FALSE,              # 顏色分界點不要以 0 為中心對稱
                                    #   → 這兩個一起關掉,色階會「跟著資料實際
                                    #     範圍」(約 0.15~0.8)分佈,
                                    #     低值配藍、高值配紅;
                                    #     否則正值會全部擠到紅色那半邊。
    
    xlab = "Samples",               # x 軸標題文字(標在最下方)
    ColSideColors = my.colors,      # 在熱圖「上方」加一條顏色帶,
                                    #   用步驟一算出的 my.colors 標示樣本分組
                                    #   (黑/紅/綠/藍各 10 個)
    
    trace = "none",                 # 不要在格子上疊加追蹤線(trace line)
                                    #   預設會畫青色的密度/軌跡線,這裡關掉讓畫面乾淨
    
    cexRow = 1.5,                   # 列標籤(Gene1~Gene4)的字體放大倍率 = 1.5 倍
    cexCol = 1,                     # 欄標籤(1~40)的字體倍率 = 1(原始大小)
    
    rowsep = 1:4,                   # 在第 1,2,3,4 列的「下緣」加上分隔線
                                    #   → 把每個基因用白色細縫隔開
    
    sepwidth = c(0.05, 0.05)        # 分隔線(縫隙)的寬度:c(欄縫寬, 列縫寬)
                                    #   兩者都設 0.05
)



