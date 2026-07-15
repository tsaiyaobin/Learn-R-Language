# plot
path <- "/Users/austin/Desktop/Learn_R/Learn-R-Language/data/"
aa<- read.delim(paste(path, "test_data.txt", sep = ""))
plot(aa$area, aa$price) ## plot area versus price
## prepare a graphic device for drawing
## draw on the graphic device
jpeg(paste(path, "houseinfo.jpg", sep=""), width = 640,
       height = 480)
plot(aa$area, aa$price, xlab="area", ylab="price")
title("house information") ## add title to the plot
dev.off() ## close the graphic device and complete drawing
bmp(paste(path, "houseInfo.bmp", sep=""), width = 640,
       height = 480)
plot(aa$area, aa$price, xlab="area", ylab="price")
title("house information")
dev.off()