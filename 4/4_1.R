# plot
path <- "/Users/austin/Desktop/Learn_R/Learn-R-Language/data/"
aa<- read.delim(paste(path, "test_data.txt", sep = ""))
plot(aa$area, aa$price) ## plot area versus price

## prepare a graphic device for drawing
## draw on the graphic device
## res:(pixels per inch).Default is 72; a common print-quality setting is 300.
## units: default is "px". Changing it to "in" (or "cm", "mm") makes 
##        width/height represent actual physical size; combined with res, 
##        this determines the output pixel dimensions (e.g., 6.4in × 300ppi = 1920px).

jpeg(paste(path, "houseinfo.jpg", sep=""), units = "in", width = 6.4, height = 4.8, res = 300)
plot(aa$area, aa$price, xlab="area", ylab="price")
title("house information")
dev.off() ## close the graphic device and complete drawing

bmp(paste(path, "houseInfo.bmp", sep=""), units = "in", width = 6.4, height = 4.8, res = 300)
plot(aa$area, aa$price, xlab="area", ylab="price")
title("house information")
dev.off() ## close the graphic device and complete drawing