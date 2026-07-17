x <- 0:64 / 64
y <- sin(3 * pi * x)
# type = 'n' 表示「不畫任何點或線」,圖是空白的,只有座標軸跟框線。
plot(x, y, type='n')

# "topleft":圖例位置用關鍵字指定,放在繪圖區域的左上角,不用手動給座標或滑鼠點選。
# R 支援的關鍵字還有 "topright"、"bottomleft"、"bottomright"、"center" 等
legend("bottomright", "(x,y)", pch = 1, title = "bottomright")

legend("bottom", "(x,y)", pch = 1, title = "bottom")

legend("bottomleft", "(x,y)", pch = 1, title = "bottomleft")

legend("left", "(x,y)", pch = 1, title = "left")

# inset = .05:讓圖例框往繪圖區域內縮一點距離
legend("topleft", "(x,y)", pch = 1, title = "topleft, inset = .05", inset = .05)

legend("top", "(x,y)", pch = 1, title = "top")

legend("topright", "(x,y)", pch = 1, title = "topright, inset = .02", inset = .02)

legend("right", "(x,y)", pch = 1, title = "right")

legend("center", "(x,y)", pch = 1, title = "center")