#Hyeongwan Seo

library(gridExtra) # 라이브러리를 로드하지 못하면 install.packages("gridExtra")를 해야함.
library(ggplot2) #라이브러리를 로드하지 못하면 install.packages("ggplot2")를 해야함.

dataset <- read.csv(file="mem_statistics.csv", as.is=TRUE)

dataset$Time <- strptime(format="%d-%m-%Y %H:%M:%S %z", dataset$Timestamp, tz="GMT")

# y축의 max 값을 계산한다                                  
y_Memfree <- dataset[,9]
y_Active <- dataset[,10]
y_Cached <- dataset[,11]
y_max <- max(y_Memfree, y_Active, y_Cached)

dataset$Time <- strptime(format="%d-%m-%Y %H:%M:%S %z", dataset$Timestamp, tz="GMT")

plot <- ggplot( dataset, aes( Time, MB ), legend=TRUE ) + 
            scale_y_continuous(breaks = seq(0, y_max, by = 100)) +
            ggtitle("Memory usage") +
            theme(panel.grid.major = element_line(colour = "#969696", size=0.3, linetype='F1')) +
            theme(panel.grid.minor = element_line(colour = "#969696", size=0.4, linetype='dotted')) +
            theme(panel.border = element_rect(colour = "#aaaaaa", fill=NA, size=1)) +
            geom_line(colour="#6ED746", aes(Time, y = y_Memfree )) +
            geom_line(colour="#FF9999", aes(Time, y = y_Active )) +   
            geom_line(colour="steelblue2", aes(Time, y = y_Cached)) +
            scale_colour_manual(values=c("green","red","blue")) # 작동 안함 (확인 필요)


#그래프1 (MemFree)
#plot1 <- ggplot( dataset, aes( Time, MemFree ) ) +
#			  geom_point(color="#6ED746") + 
#			  geom_line(colour="#6ED746") + 
#			  scale_x_datetime() + 
#			  labs(x="Time (HH:MM)", y="MemFree (MB)") + 
#			  ggtitle("[Memory] Memfree") +
#			  theme(plot.title = element_text(color="#666666", face="bold", size=12, hjust=0.5)) +
#  			  theme(axis.title = element_text(color="#666666", face="bold", size=8, hjust=1)) +
#			  theme(panel.grid.major = element_line(colour = "#969696", size=0.3, linetype='F1')) +
#			  theme(panel.grid.minor = element_line(colour = "#969696", size=0.4, linetype='dotted')) +
 #             theme(panel.border = element_rect(colour = "#aaaaaa", fill=NA, size=1))

#그래프2 (Active)
#plot2 <- ggplot( dataset, aes( Time, Active ) ) +
#			  geom_point(color="#FF9999") + 
#			  geom_line(colour="#FF9999") + 
#			  scale_x_datetime() + 
#			  labs(x="Time (HH:MM)", y="Active (MB)") + 
#			  ggtitle("[Memory] Active") +
#			  theme(plot.title = element_text(color="#666666", face="bold", size=12, hjust=0.5)) +
#  			  theme(axis.title = element_text(color="#666666", face="bold", size=8, hjust=1)) +
#			  theme(panel.grid.major = element_line(colour = "#969696", size=0.3, linetype='F1')) +
#			  theme(panel.grid.minor = element_line(colour = "#969696", size=0.4, linetype='dotted')) +
#              theme(panel.border = element_rect(colour = "#aaaaaa", fill=NA, size=1))
#
#그래프3 (Cached)
#plot3 <- ggplot( dataset, aes( Time, Cached ) ) +
#			  geom_point(color="steelblue2") + 
#			  geom_line(colour="steelblue2") + 
#			  scale_x_datetime() + 
#			  labs(x="Time (HH:MM)", y="Cached (MB)") + 
#			  ggtitle("[Memory] Cached") +
#			  theme(plot.title = element_text(color="#666666", face="bold", size=12, hjust=0.5)) +
#  			  theme(axis.title = element_text(color="#666666", face="bold", size=8, hjust=1)) +
#			  theme(panel.grid.major = element_line(colour = "#969696", size=0.3, linetype='F1')) +
#			  theme(panel.grid.minor = element_line(colour = "#969696", size=0.4, linetype='dotted')) +
#              theme(panel.border = element_rect(colour = "#aaaaaa", fill=NA, size=1))
#
# 24000, 22300, 2900
png(filename="Memory_usage_graph.png", width=24000, height=22300, unit="px", res=2900)
grid.arrange(plot, ncol=1, nrow=1)
