# better to use read.dlim

path <- "/Users/austin/Desktop/Learn_R/Learn-R-Language/data/"

## paste0() 等於 paste(..., sep="")
data_txt <- read.table(paste(path, "test_data.txt", sep = "")) 

# cbind = column bind,幫 data.frame 加一欄,欄名叫 garage
data_txt <- cbind(data_txt, garage = (c(1, 0, 1, 2, 0, 2)))
data_txt

write.table(data_txt, paste(path, "New_data1.txt", sep = ""), sep = "\t", quote = F)
write.table(data_txt, paste(path, "New_data2.txt", sep = ""), sep = "\t", quote = F, row.names = F, col.names = F)

new_data1 <- read.table(paste(path, "New_data1.txt", sep = ""))
row.names(new_data1)
new_data1
new_data2 <- read.table(paste(path, "New_data2.txt", sep = ""))
row.names(new_data2)
new_data2
