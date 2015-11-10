#!/bin/bash

#Hyeongwan Seo

function daily()
{
	TMP_FILE=/tmp/input.box.tmp.$$

	dialog --title "Daily graph" \
     --inputbox "메모리 사용량 그래프를 그릴 날짜를 입력해주세요. (YYYY MM DD)" 10 0 2> $TMP_FILE
	retval=$?
	input=`cat $TMP_FILE` 			# $$는 현재 프로세스의 PID를 의미함
	rm -f /tmp/inputbox.tmp.$$

	case $retval in
    	0) echo "다음 날짜의 메모리 사용량을 그래프로 그립니다. '$input'"
			YEAR=`cat $TMP_FILE | awk -F " " '{print $1}'`
			MONTH=`cat $TMP_FILE | awk -F " " '{print $2}'`
			DAY=`cat $TMP_FILE | awk -F " " '{print $3}'`

			echo "$YEAR $MONTH $DAY";;

    	1) echo "Cancel pressed."
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

	png(filename="test.png", width=595, height=842, unit="px")

	par(mfrow=c(3,1))

	par(cex.axis=2, cex.lab=2)
	plot(y_memfree, type="o", col="red", xlab="", ylab="")
	grid(col="blue")
	title(main="[Memory] Memfree - by a day ($YEAR.$MONTH.$DAY)", xlab="Count", ylab="Usage (MB)", cex=2, font.main=2, cex.sub=1.5, cex.main=2)

	par(cex.axis=2, cex.lab=2)
	plot(y_active, type="o", col="green", xlab="", ylab="")
	grid(col="blue")
	title(main="[Memory] Active - by a day ($YEAR.$MONTH.$DAY)", xlab="Count", ylab="Usage (MB)", font.main=2, cex=2, cex.sub=1.5, cex.main=2)
	#par(cex.axis=2, cex.lab=2)

	par(cex.axis=2, cex.lab=2)
	plot(y_cached, type="o", col="blue", xlab="", ylab="")
	grid(col="lightblue")
	title(main="[Memory] Cached - by a day ($YEAR.$MONTH.$DAY)", xlab="Count", ylab="Usage (MB)", font.main=2, cex=2, cex.sub=1.5, cex.main=2)

	#par(cex.axis=2, cex.lab=2)

	#axis(1, at=seq(0, 40, by=1))
	#axis(2, las=0, col.axis="red", ylim=c(0, 6000))
	#axis(2, at=seq(0, 600, by=10))

	#par(new=T)
	#plot(y_active, type="o", col="blue", ylim=c(0, 6000))
	#axis(4, col.axis="blue", ylim=c(0, 6000))
	#par(new=T)
	#plot(y_cached, type="o", col="green", ylab="", ylim=c(0, 6000))
	grid(col="blue")

}

switch($menu_idx, draw_daily_graph(), "Weekly", "Monthly", "Yearly")

#draw_daily_graph()

#x <- switch($menu_idx, "daily_graph()", "Weekly", "Monthly", "Yearly")
#print(x)

#mem <- read.csv('mem_statistics.csv')
#sqldf('select * from mem')


EOF
