# Excerise 2
list100 <- vector(mode="list", length=4)
list100

m <- matrix(0, nrow = 100, ncol = 4)
m
for (i in 1:100){
    m[i, ] <- sample(9, 4, replace = T)
}

dim(m)

for (i in 1:4){
    m_sort <- sort(table(m[,i]), decreasing = T)[1:3]
    print(m_sort)
}

