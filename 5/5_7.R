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

# Machine Learning Tools in R
## software package of a unifying interface for machine learning methods ##
BiocManager::install("MLInterfaces")
library(MLInterfaces) ## load in the library

#### Training and test set cross-validation
#### take the first 40 samples as training set and test on the remaining 39 samples

t.stat <- function(x, group)
{

    t.test(x[group == "BCR/ABL"], x[group == "NEG"])$statistic
}
a <- apply(exprs(ALL.2)[, 1:40], 1, t.stat, group = ALL.2$bcrabl[1:40])

#### select the top 50 genes with the larges standard deviations
index <- order(abs(a))[length(a):(length(a) - 50 + 1)]

#### now we start with knn ######
help(MLearn)
args(MLearn)
all.knn <- MLearn(bcrabl~., ALL.2[index,], knnI(k = 3, l = 1), 1:40)

#### tabulate predictions and underlying truth for the 39 predicted samples
confuMat(all.knn)

#### SVM ####
all.svm <- MLearn(bcrabl~., ALL.2[index,], svmI, 1:40)
confuMat(all.svm)

### SVM in e1071 library ####
BiocManager::install("e1071")
library("e1071")

### training and test data ###
x_train <- t(exprs(ALL.2[index,1:40]))
y_train <- ALL.2$bcrabl[1:40]

x_test <- t(exprs(ALL.2[index,41:79]))
y_test <- ALL.2$bcrabl[41:79]

all.svm1 <- svm(x_train, y_train)
summary(all.svm1)

pred <- predict(all.svm1, x_test)
table(pred, y_test)

### test with train data
pred <- predict(all.svm1, x_train)
table(pred, y_train)


t(exprs(ALL.2[index,1:40]))
ALL.2$bcrabl[1:40]



