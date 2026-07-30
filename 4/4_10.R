# Multiple plots in a window by "layout" function
attach(iris)
x.hist <- hist(Sepal.Length, breaks = 10, plot = F)
y.hist <- hist(Sepal.Width, breaks = 10, plot = F)

top <- max(c(x.hist$counts, y.hist$counts))

layout(matrix(c(2, 0, 1, 3), 2, 2, byrow = T),
       width = c(4, 1), heights = c(1, 2))
plot(Sepal.Length, Sepal.Width, main = "x-y distribution")

barplot(x.hist$counts, axes = F, ylim = c(0, top),
        space = 0, main = "x-axis histogram")

barplot(y.hist$counts, axes = F, xlim = c(0, top),
        space = 0, horiz = T, main = "y-axis histogram")