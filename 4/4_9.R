# Multiple plots with multiple plot types in a window
data<-rnorm(50,0.5,0.2)
types<-c("p","l","b","c","o","h","s","n")
par(mfrow = c(2,4))
for(i in 1:8){
    plot(data, type=types[i])
}

par(mfcol = c(2,4))
for(i in 1:8){
    plot(data,type=types[i])
}