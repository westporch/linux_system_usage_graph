#!/bin/bash

#Hyeongwan Seo

function daily()
{
	TMP_FILE=/tmp/input.box.tmp.$$

	dialog --title "Daily graph" \
     --inputbox "메모리 사용량 그래프를 그릴 날짜를 입력해주세요. (YYYY MM DD)" 10 0 2> $TMP_FILE
	retval=$?
	input=`cat $TMP_FILE` 			# $$는 현재 프로세스의 PID를 의미함
#	rm -f /tmp/inputbox.tmp.$$

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

	sql_daily_graph <- sprintf("select MemFree, Active, Cached from mem where Year=%s and Month=%s and Day=%s", $YEAR, $MONTH, $DAY)
	sqldf(sql_daily_graph)

	#sqldf('select * from mem')
}

switch($menu_idx, draw_daily_graph(), "Weekly", "Monthly", "Yearly")

#draw_daily_graph()

#x <- switch($menu_idx, "daily_graph()", "Weekly", "Monthly", "Yearly")
#print(x)

#mem <- read.csv('mem_statistics.csv')
#sqldf('select * from mem')


EOF
