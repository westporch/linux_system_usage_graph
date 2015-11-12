#Hyeongwan Seo

library(ggplot2)

dataset <- read.csv(file="mem_statistics.csv", as.is=TRUE)

dataset$Time <- strptime(format="%d-%m-%Y %H:%M:%S %z", dataset$Timestamp, tz="GMT")

p1 <- ggplot( dataset, aes( Time, MemFree ) ) +
			  geom_point(color="black") + 
			  geom_line(colour="red") + 
			  scale_x_datetime() + 
			  labs(x="Time (HH:MM)", y="MemFree (MB)") + 
			  ggtitle("[Memory] Memfree - by a day") +
			  theme(plot.title = element_text(color="#666666", face="bold", size=16, hjust=0.5)) +
  			  theme(axis.title = element_text(color="#666666", face="bold", size=14)) 
ggsave(filename="test.png")
