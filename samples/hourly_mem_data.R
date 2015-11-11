library(sqldf)
mem <- read.csv('mem_statistics.csv')
hourly_arr <- sqldf('select Hour from mem where Year=2015 and Month=11 and Day=11 group by Hour')

#hourly_arr

num_of_hour <- NROW(hourly_arr) # 배열의 전체 길이를 구함.

for (idx in 1:num_of_hour)
{
	idx <- hourly_arr[idx,]

	hour_data <- sprintf("select MemFree from mem where Year=2015 and Month=11 and Day=11 and Hour=%s", idx)
	get_hour_data <- sqldf(hour_data)

	print(idx)
	print(get_hour_data)
	print("=====end======")
}




#hourly_arr[1,]
#hourly_arr[2,]
#hourly_arr[3,]

