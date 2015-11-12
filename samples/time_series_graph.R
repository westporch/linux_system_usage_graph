mem <- read.csv('mem_statistics.csv')    

Lines <- "Date            Visits
11/1/2010   696537
11/2/2010   718748
11/3/2010   799355
11/4/2010   805800
11/5/2010   701262
11/6/2010   531579
11/7/2010   690068
11/8/2010   756947
11/9/2010   718757
11/10/2010  701768
11/11/2010  820113
11/12/2010  645259"

png(filename="test.png")
dm <- read.table(textConnection(Lines), header = TRUE)
dm$Date <- as.Date(dm$Date, "%m/%d/%Y")
plot(Visits ~ Date, dm, xaxt = "n", type = "l")
axis(1,at=NULL, labels=F)
text(x = dm$Date, par("usr")[3]*.97, labels = paste(dm$Date,' '), srt = 45, pos = 1, xpd = TRUE,cex=.7)
grid()  
