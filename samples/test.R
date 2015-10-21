#사용법
#Rscript test.R을 하면 그래프가 생성됨.

#test.R
x <- readLines('scan.txt')                                                                                           
y <- seq(10,70,10)
#par(mfrow=c(2,3), mar=c(4,4,3,3))

png("test.png")

plot(x, y, type='o', col='red', xlab = "", ylab = "") 
grid()
title(main="MEMORY (sample)", xlab="Time (s)", ylab="Usage (MB)", font.main=2, cex=2, cex.axis=1.5, cex.sub=1.5, cex.main=2, cex.lab=1.5)
