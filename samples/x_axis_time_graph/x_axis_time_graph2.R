#Hyeongwan Seo

library(gridExtra) # 라이브러리를 로드하지 못하면 install.packages("gridExtra")를 해야함.
library(ggplot2) #라이브러리를 로드하지 못하면 install.packages("ggplot2")를 해야함.

dataset <- read.csv(file="mem_statistics.csv", as.is=TRUE)

dataset$Time <- strptime(format="%d-%m-%Y %H:%M:%S %z", dataset$Timestamp, tz="GMT")

#그래프1
plot1 <- ggplot( dataset, aes( Time, MemFree ) ) +
			  geom_point(color="black") + 
			  geom_line(colour="red") + 
			  scale_x_datetime() + 
			  labs(x="Time (HH:MM)", y="MemFree (MB)") + 
			  ggtitle("[Memory] Memfree - by a day") +
			  theme(plot.title = element_text(color="#666666", face="bold", size=12, hjust=0.5)) +
  			  theme(axis.title = element_text(color="#666666", face="bold", size=8, hjust=1)) 
#그래프2
plot2 <- ggplot( dataset, aes( Time, MemFree ) ) +
			  geom_point(color="black") + 
			  geom_line(colour="green") + 
			  scale_x_datetime() + 
			  labs(x="Time (HH:MM)", y="MemFree (MB)") + 
			  ggtitle("[Memory] Memfree - by a day") +
			  theme(plot.title = element_text(color="#666666", face="bold", size=12, hjust=0.5)) +
  			  theme(axis.title = element_text(color="#666666", face="bold", size=8, hjust=1)) 
#그래프3
plot3 <- ggplot( dataset, aes( Time, MemFree ) ) +
			  geom_point(color="black") + 
			  geom_line(colour="blue") + 
			  scale_x_datetime() + 
			  labs(x="Time (HH:MM)", y="MemFree (MB)") + 
			  ggtitle("[Memory] Memfree - by a day") +
			  theme(plot.title = element_text(color="#666666", face="bold", size=12, hjust=0.5)) +
  			  theme(axis.title = element_text(color="#666666", face="bold", size=8, hjust=1)) 

png(filename="test.png", width=595, height=842, unit="px", res=150)
grid.arrange(plot1, plot2, plot3, ncol=1, nrow=3)
