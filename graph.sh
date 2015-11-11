#!/bin/bash

#Hyeongwan Seo

#graph_line_color=("red" "green" "blue")

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
	mem <- read.csv('mem_statistics.csv')

	sql_daily_graph <- sprintf("select MemFree, Active, Cached from mem where Year=%s and Month=%s and Day=%s", $YEAR, $MONTH, $DAY)
	y_sql_daily_graph	<- sqldf(sql_daily_graph)

	mem_graph_type = c("Memfree", "Active", "Cached")
	graph_line_color = c("red", "green", "blue")

	png(filename=paste("Daily_graph", "($YEAR$MONTH$DAY).png"), width=595, height=842, unit="px")

	par(mfrow=c(3,1)) # 그래프 3개를 1열로 배치함

	#그래프1 ~ 그래프3을 그리는 반복문
	for(idx in 1:3)
	{
		par(cex.axis=2, cex.lab=1.5)
		' : plot 함수의 col값 0: Black, 1: Red, 2: Green, 3: Blue    
		y_memfree <- y_sql_daily_graph[,1]
    	y_active <- y_sql_daily_graph[,2]
    	y_cached <- y_sql_daily_graph[,3] '
		plot(y_sql_daily_graph[,idx], type="o", col=rep(idx+1), xlab="", ylab="")
 		grid(col="blue")
		title(paste("[Memory]", main=mem_graph_type[idx], "- by a day", "(", $YEAR, ".",  $MONTH, ".", $DAY, ")"), xlab="Count", ylab="MB", cex=2, font.main=2, cex.sub=1.5, cex.main=2)
	}
}

#if ($STATUS==0)
#{
#	switch($menu_idx, draw_daily_graph(), "Weekly", "Monthly", "Yearly")
#}
#else
#{
#	q()
#}

switch($menu_idx, draw_daily_graph(), "Weekly", "Monthly", "Yearly")

EOF
