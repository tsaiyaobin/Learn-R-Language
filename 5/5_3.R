A<-(log2(data[,1])+log2(data[,2]))/2
> M<-(log2(data[,1])-log2(data[,2]))
> plot( c(0, 13), c(-6, 6), type="n", xlab="A", ylab="M") ### type (type of plot)
> points(A, M, pch=".") ### pch (types of points plotted)
> lines(c(0, 13), c(0,0), col=2)
> title("M-A plot of all genes in array 'm' and 'n'")
### filter out genes with average intensity less than 100) ###
> row.average<-apply(data, 1, mean)
> index<-(1:nrow(data))[row.average>=100]
> new.data<-data[index,]
> A<-(log2(new.data[,1])+log2(new.data[,2]))/2
> M<-(log2(new.data[,1])-log2(new.data[,2]))
> plot( c(min(A), max(A)), c(min(M), max(M)), type="n", xlab="A", ylab="M")
> points(A, M, pch=".")
> lines(c(0, 13), c(0,0), col=2)
> title("M-A plot of filtered genes in array 'm' and 'n'")