#Hyeongwan Seo

library(gridExtra) # 라이브러리를 로드하지 못하면 install.packages("gridExtra")를 해야함.
library(ggplot2) #라이브러리를 로드하지 못하면 install.packages("ggplot2")를 해야함.

dataset <- read.csv(file="mem_statistics.csv", as.is=TRUE)

dataset$Time <- strptime(format="%d-%m-%Y %H:%M:%S %z", dataset$Timestamp, tz="GMT")

#그래프1 (MemFree)
plot1 <- ggplot( dataset, aes( Time, MemFree ) ) +
			  geom_point(color="#6ED746") + 
			  geom_line(colour="#6ED746") + 
			  scale_x_datetime() + 
			  labs(x="Time (HH:MM)", y="MemFree (MB)") + 
			  ggtitle("[Memory] Memfree - by a day") +
			  theme(plot.title = element_text(color="#666666", face="bold", size=12, hjust=0.5)) +
  			  theme(axis.title = element_text(color="#666666", face="bold", size=8, hjust=1)) +
			  theme(panel.grid.major = element_line(colour = "#969696", size=0.3, linetype='F1')) +
			  theme(panel.grid.minor = element_line(colour = "#969696", size=0.4, linetype='dotted')) +
              theme(panel.border = element_rect(colour = "#aaaaaa", fill=NA, size=1))

#그래프2 (Active)
plot2 <- ggplot( dataset, aes( Time, Active ) ) +
			  geom_point(color="#FF9999") + 
			  geom_line(colour="#FF9999") + 
			  scale_x_datetime() + 
			  labs(x="Time (HH:MM)", y="Active (MB)") + 
			  ggtitle("[Memory] Active - by a day") +
			  theme(plot.title = element_text(color="#666666", face="bold", size=12, hjust=0.5)) +
  			  theme(axis.title = element_text(color="#666666", face="bold", size=8, hjust=1)) +
			  theme(panel.grid.major = element_line(colour = "#969696", size=0.3, linetype='F1')) +
			  theme(panel.grid.minor = element_line(colour = "#969696", size=0.4, linetype='dotted')) +
              theme(panel.border = element_rect(colour = "#aaaaaa", fill=NA, size=1))

#그래프3 (Cached)
plot3 <- ggplot( dataset, aes( Time, Cached ) ) +
			  geom_point(color="steelblue2") + 
			  geom_line(colour="steelblue2") + 
			  scale_x_datetime() + 
			  labs(x="Time (HH:MM)", y="Cached (MB)") + 
			  ggtitle("[Memory] Cached - by a day") +
			  theme(plot.title = element_text(color="#666666", face="bold", size=12, hjust=0.5)) +
  			  theme(axis.title = element_text(color="#666666", face="bold", size=8, hjust=1)) +
			  theme(panel.grid.major = element_line(colour = "#969696", size=0.3, linetype='F1')) +
			  theme(panel.grid.minor = element_line(colour = "#969696", size=0.4, linetype='dotted')) +
              theme(panel.border = element_rect(colour = "#aaaaaa", fill=NA, size=1))

#png(filename="test.png", width=842, height=794, unit="px", res=170)
png(filename="test.png", width=842, height=794, unit="px", res=150)
grid.arrange(plot1, plot2, plot3, ncol=1, nrow=3)

#png(filename="test.png", width=595, height=842, unit="px", res=150)
