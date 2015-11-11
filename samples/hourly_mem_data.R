library(sqldf)
mem <- read.csv('mem_statistics.csv')
hourly_arr <- sqldf('select Hour from mem where Year=2015 and Month=11 and Day=11 group by Hour')

hourly_arr

NROW(hourly_arr) # 배열의 전체 길이를 구함.

#hourly_arr[1,]
#hourly_arr[2,]
#hourly_arr[3,]

