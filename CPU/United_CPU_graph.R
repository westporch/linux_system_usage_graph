#Hyeongwan Seo

library(gridExtra) # 라이브러리를 로드하지 못하면 install.packages("gridExtra")를 해야함.
library(ggplot2) #라이브러리를 로드하지 못하면 install.packages("ggplot2")를 해야함.

dataset <- read.csv(file="CPU/cpu_statistics.csv", as.is=TRUE)

dataset$Time <- strptime(format="%d-%m-%Y %H:%M:%S %z", dataset$Timestamp, tz="GMT")

# y축의 max 값을 계산한다                                  
y_Usage <- dataset[,2]
y_Idle <- dataset[,3]
#y_Cached <- dataset[,4]
#y_max <- max(y_Memfree, y_Active, y_Cached)

dataset$Time <- strptime(format="%d-%m-%Y %H:%M:%S %z", dataset$Timestamp, tz="GMT")

plot <- ggplot(dataset, aes(Time))  + 
            scale_y_continuous(breaks = seq(0, 100, by = 5)) +
            ggtitle("<CPU usage statistics>\nGreen(Idle), Red(Usage)") +
            theme(panel.grid.major = element_line(colour = "#969696", size=0.3, linetype='solid')) +
            theme(panel.grid.minor = element_line(colour = "white", size=0.4, linetype='F1')) +
            theme(panel.border = element_rect(colour = "#aaaaaa", fill=NA, size=1)) +
            geom_line(colour="#6ED746", size=1, aes(Time, y = y_Idle)) + 
            geom_line(colour="#FF9999", size=1, aes(Time, y = y_Usage)) + 
			ylab("Percent (%)") 

png(filename="CPU_usage_graph.png", width=1021, height=1279, unit="px", res=230)
grid.arrange(plot, ncol=1, nrow=1)
