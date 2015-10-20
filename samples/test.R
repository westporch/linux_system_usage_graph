#사용법
#Rscript test.R을 하면 그래프가 생성됨.

#test.R
x <- readLines('scan.txt')
y <- c(10, 20, 30, 40, 50, 60, 70) 
png("test.png")
plot(x, y, type='o', col='red')
grid()

title(main="title", font.main=5)                                                              
title(xlab="B", col.lab="black")
title(ylab="C", col.lab="black") 

