# For the file “cycleData_peak.txt”
## Count how many not “NA” in each row.
path <-  "/Users/austin/Desktop/Learn_R/Learn-R-Language/data/"
my_data <- read.table(paste(path, "cycleData_peak.txt", sep = ""))
d <- dim(my_data)
my_data <- my_data[2:d[1], 2:d[2]] # clean data
d <- dim(my_data)

row_NA_nums <- numeric(d[1]) # save how many NA in row

for (i in 1:d[1]){
    row_data <- my_data[i, ]
    row_NA_nums[i] <- d[2] - sum(as.numeric(is.na(row_data)))
}
row_NA_nums

# For the file “SRBCT_train.txt”.
## Normalize data by each row (let values b/w 0~1)
my_data2 <- read.delim(paste(path, "SRBCT_train.txt", sep = ""))
my_data2 <- as.matrix(my_data2[,-c(1,2)])
d2 <- dim(my_data2)
min_max_norm <- function(lst){
    (lst - min(lst)) / (max(lst) - min(lst))
}

each_row_norm <- matrix(0, nrow = d2[1], ncol = d2[2])
each_row_norm
for (i in 1:d2[1]){
    each_row_norm[i, ] <- min_max_norm(my_data2[i, ])
} 
each_row_norm

## Normalize data by each column (mean = 0, sd = 1)
z_norm <- function(lst){
    (lst - mean(lst)) / sd(lst)
}
each_col_norm <- matrix(0, nrow = d2[1], ncol = d2[2])
for (j in 1:d2[2]){
    each_col_norm[, j] <- z_norm(my_data2[, j])
}
each_col_norm



