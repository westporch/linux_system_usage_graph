#!/bin/bash

#Hyeongwan Seo

function daily() # 삭제하지마 나중에 다이어로그 그릴때 참고할 예정
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

			echo "$YEAR $MONTH $DAY";;

    	1) echo "Cancel pressed."
	
           exit;;
	esac
}

cmd=(dialog --checklist "시스템 사용량을 그래프로 보여줍니다." 15 40 4)
options=(1 "메모리 사용량 그래프" on    # any option can be set to default to "on"
         2 "CPU 사용량 그래프 (구현x)" off
         3 "기능 추가 예정" off
         4 "기능 추가 예정" off)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
	case $choice in
		1)	#daily;;
			Rscript memory_graph.R
			echo "메모리 사용량 그래프를 완성했습니다.";;
		2) echo "2";;
		3) echo "3";; 
		4) echo "4";; 
		*) echo "유효하지 않은 숫자!" ;;
	esac
done
