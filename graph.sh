#!/bin/bash

#Hyeongwan Seo

mem_graph_type=("Memfree" "Active" "Cached")

function daily()
{
	TMP_FILE=/tmp/input.box.tmp.$$

	dialog --title "Daily graph" \
     --inputbox "메모리 사용량 그래프를 그릴 날짜를 입력해주세요. (YYYYMMDD)" 10 0 2> $TMP_FILE
	retval=$?
	input=`cat $TMP_FILE` 			# $$는 현재 프로세스의 PID를 의미함
	rm -f /tmp/inputbox.tmp.$$

	case $retval in
    	0) echo "다음 날짜의 메모리 사용량을 그래프로 그립니다. '$input'"
			YEAR=`cat $TMP_FILE | cut -c 1-4`
			MONTH=`cat $TMP_FILE | cut -c 5-6`
			DAY=`cat $TMP_FILE | cut -c 7-8` 

			STATUS=0

			echo "$YEAR $MONTH $DAY";;

    	1) echo "Cancel pressed."
	
		   STATUS=1
           exit;;
	esac
}


cmd=(dialog --checklist "Memory usage graph" 15 40 4)
options=(1 "Daily graph" on    # any option can be set to default to "on"
         2 "Weekly graph" off
         3 "Monthly graph" off
         4 "Yearly graph" off)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
	case $choice in
		1) echo "1이 선택됨"
			menu_idx=1
			daily;;
		2) echo "2" 
			menu_idx=2;;
		3) echo "3" 
			menu_idx=3;;
		4) echo "4" 
			menu_idx=4;;
		*) echo "유효하지 않은 숫자!" ;;
	esac
done

STR=test999

# R 스크립트 시작

R --quiet --no-save << EOF
library(sqldf)

draw_daily_graph <- function(YEAR, MONTH, DAY)
{
	print ("함수 내부입니다.")
	print ($YEAR)
	print ($MONTH)
	print ($DAY)
	mem <- read.csv('mem_statistics.csv')

	#sql_daily_graph <- sprintf("select MemFree, Active, Cached from mem where Year=%s and Month=%s and Day=%s", $YEAR, $MONTH, $DAY)
	sql_daily_graph <- sprintf("select MemFree, Active, Cached from mem where Year=%s and Month=%s and Day=%s", $YEAR, $MONTH, $DAY)
	y_sql_daily_graph	<- sqldf(sql_daily_graph)
	y_memfree <- y_sql_daily_graph[,1]
	y_active <- y_sql_daily_graph[,2]
	y_cached <- y_sql_daily_graph[,3]

	TYPE <- c("Memfree", "Active", "Cached")

	png(filename="test.png", width=595, height=842, unit="px")

	par(mfrow=c(3,1))

	# 그래프1~ 그래프3은 for문으로 변경 불가능.
	# 그래프1 (memfree) 
	par(cex.axis=2, cex.lab=2)
	plot(y_memfree, type="o", col="red", xlab="", ylab="")
	grid(col="blue")
	title(main="[Memory] ${mem_graph_type[0]} - by a day ($YEAR.$MONTH.$DAY)", xlab="Count", ylab="${mem_graph_type[0]} (MB)", cex=2, font.main=2, cex.sub=1.5, cex.main=2)
	legend(500, 400, c("test"), col=c("red"))

	# 그래프2 (active)
	par(cex.axis=2, cex.lab=2)
	plot(y_active, type="o", col="green", xlab="", ylab="")
	grid(col="blue")
	title(main="[Memory] Active - by a day ($YEAR.$MONTH.$DAY)", xlab="Count", ylab="Usage (MB)", font.main=2, cex=2, cex.sub=1.5, cex.main=2)

	# 그래프3 (cached)
	par(cex.axis=2, cex.lab=2)
	plot(y_cached, type="o", col="blue", xlab="", ylab="")
	grid(col="blue")
	title(main="[Memory] Cached - by a day ($YEAR.$MONTH.$DAY)", xlab="Count", ylab="Usage (MB)", font.main=2, cex=2, cex.sub=1.5, cex.main=2)
}

print ("test999")

#if ($STATUS==0)
#{
#	switch($menu_idx, draw_daily_graph(), "Weekly", "Monthly", "Yearly")
#}
#else
#{
#	q()
#}

switch($menu_idx, draw_daily_graph(), "Weekly", "Monthly", "Yearly")

print("$STR")

EOF
