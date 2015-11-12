#Source: http://www.r-bloggers.com/time-zones/ 의 소스를 변형함

library(ggplot2)

dataset <- read.csv( file="peak.csv",as.is=TRUE)
# Convert timestamps
dataset$timestamp2 <- strptime( format="%d-%m-%Y %H:%M:%S %z",
                                dataset$timestamp,
                                tz="UTC" )

p1 <- ggplot( dataset, aes( timestamp2, value ) ) + geom_point(color="red") + geom_line() + scale_x_datetime()

ggsave(filename="test.png")
