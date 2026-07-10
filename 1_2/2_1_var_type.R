# numeric
a = 666
class(a)

#integer
a = 666L
class(a)

# logical
a = TRUE
class(a)

# character
a = "hello word"
class(a)

# complex
a = 2 + 2i # i 是 √-1 -> 2i = 2 * √-1
class(a)

cat(strrep("-", 40), "\n")

a = 666L
is.integer(a)
is.character(a)

as.integer(10.10) # as.integer()把不是整數變整數

