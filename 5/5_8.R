BiocManager::install("ALL") 
library(ALL)               
data(ALL)                   
ALL                         

exprs(ALL)[1:3, ]          
varLabels(ALL)             

ALL.1 <- ALL[, order(ALL $ mol.bio)] 
ALL.1 $ mol.bio             

heatmap(cor(exprs(ALL.1)),
        Rowv = NA, Colv = NA,        
        scale = "none",            
        labRow = ALL.1$mol.bio,     
        labCol = ALL.1$mol.bio,     
        RowSideColors = as.character(as.numeric(ALL.1$mol.bio)), 
        ColSideColors = as.character(as.numeric(ALL.1$mol.bio)))  

ALL$BT  

bio <- which(ALL$mol.bio %in% c("BCR/ABL", "NEG"))
isb <- grep("^B", as.character(ALL$BT))
kp <- intersect(bio, isb)
ALL.2 <- ALL[, kp]  

tmp <- ALL.2$mol.bio == "BCR/ABL"        
tmp <- ifelse(tmp, "BCR/ABL", "NEG")      
pData(ALL.2)$bcrabl <- factor(tmp)      
ALL.2$bcrabl                             

BiocManager::install("MLInterfaces")
library(MLInterfaces) ## load in the library

t.stat <- function(x, group)
{
    
    t.test(x[group == "BCR/ABL"], x[group == "NEG"])$statistic
}
a <- apply(exprs(ALL.2)[, 1:40], 1, t.stat, group = ALL.2$bcrabl[1:40])

index <- order(abs(a))[length(a):(length(a) - 50 + 1)]

#### structured leave-one-out cross validation ####
#### note the gene selection here already used all samples
#### the cross validation errors are over-optimistic
## knn ##

# 用留一交叉驗證 (Leave-One-Out Cross Validation, LOOCV) 來評估 k-NN 分類器
# 前面那個做法是:前 40 個訓練、後 39 個測試,固定切一刀。缺點是只測了 39 個樣本,而且切在哪裡會影響結果。
# 留一法換個玩法,更充分利用資料:
#     
#     每次都「留下一個樣本」當考題,用「其他所有樣本」當課本。
# 
# 假設有 79 個樣本,流程就是:
#     
#     第 1 輪:藏起第 1 個樣本 → 用其他 78 個訓練 → 預測第 1 個 → 對不對?
#     第 2 輪:藏起第 2 個樣本 → 用其他 78 個訓練 → 預測第 2 個 → 對不對?
#     ...
#     第 79 輪:藏起第 79 個樣本 → 用其他 78 個訓練 → 預測第 79 個 → 對不對?
#     
#     跑 79 輪,每個樣本都輪流當過一次「考題」,最後統計 79 次預測裡對了幾個。
#     這樣每個樣本都被測到,結果比「固定切一刀」更穩定

## bcrabl~.:用基因預測分組(BCR/ABL vs NEG)
## ALL.2[index,]:只用剛才挑出的 50 個基因
## knn.cvI(k=3, l=1):學習器是 3-NN,而且用「cv」版本(cross-validation,內建留一法)。
##                   注意跟前面的 knnI 不同,這個 knn.cvI 會自動幫你跑留一流程。
## 1:79:這裡的 1:79 不是「訓練集」的意思了,而是指定要納入留一循環的全部 79 個樣本。
cvloo.knn<-MLearn(bcrabl~., ALL.2[index,], knn.cvI(k=3,l=1), 1:79)
confuMat(cvloo.knn)







