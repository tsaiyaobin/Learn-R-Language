# Loading Leukemia Data
BiocManager::install("ALL") # download the latest version suited to your R version.
library(ALL) # load the package into R
data(ALL) # manually load a specific data into R
ALL # data set “ALL”; It is an instance of “ExpressionSet” class

exprs(ALL)[1:3, ]
varLabels(ALL)
ALL.1 <- ALL[, order(ALL $ mol.bio)] 
ALL.1 $ mol.bio

#### plot the correlation matrix of the 128 samples using all 12625 genes #####
heatmap(cor(exprs(ALL.1)), Rowv=NA, Colv=NA, scale= "none",
        labRow = ALL.1$mol.bio, labCol = ALL.1 $ mol.bio, 
        RowSideColors = as.character(as.numeric(ALL.1 $ mol.bio)), 
        ColSideColors = as.character(as.numeric(ALL.1 $ mol.bio)))

## In the correlation plot, NEG has two subgroups.
## One is B-cell (BT=B) and the other is T-cell (BT=T)
ALL$BT
