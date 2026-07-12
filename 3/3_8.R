# import & export data
?write.table

# Write data to .txt file
# quote = F:字串不加雙引號(預設 "setosa" 會變 setosa)
# row.names = F:不寫列編號
# col.names = F:不寫欄名稱
write.table(iris, "iris.txt") 
write.table(iris,"iris2.txt",quote=F, row.names=F)
write.table(iris,"iris3.txt",quote=F, row.names=F, col.names=F)

# read dara from .txt file
## read.table R 讀取表格型文字檔的基礎函數
## read.table() 預設的「任意空白」會把連續的空格或 tab 當成一個分隔符
## read.delim() 是每一個 tab 都是分隔符。這在資料有空欄位時差很多
demodata <- read.table("iris.txt")
demodata
demodata <- read.delim("iris.txt")
demodata

# import several .txt files 
## list.files() : 列出資料夾裡的檔案
## ".txt" 是 pattern,只挑檔名含 .txt 的
## full.names = T:回傳完整路徑("/Users/austin/Desktop/Learn_R/Learn-R-Language/iris.txt")而不是只有檔名
files.n <- list.files(path="/Users/austin/Desktop/Learn_R/Learn-R-Language/3", ".txt", full.names=T)
files.n

# lapply(向量, 函數, 額外參數) : 對向量的每個元素套用函數
# 等於對每個檔名跑一次 read.table(檔名, header = T)
# header = TRUE 的意思是:告訴 R「檔案的第一行是欄位名稱,不是資料」
files.l <- lapply(files.n, read.table, header = T)
files.l 