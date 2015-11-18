#!/bin/bash

#Hyeongwan Seo

#./collect_data.sh stop -> 데이터 수집을 중지함.

MEM_STATISTICS=mem_statistics.csv

#시스템에 R이 설치되었는지 확인함.
function R_check()
{
	if [ -e "/usr/bin/Rscript" ]; then
		echo -e "R 설치 확인:				[  \e[1;32mOK\e[0m  ]"
	else
		echo -e "R 설치 확인:				[  \e[1;31mFAIL\e[0m  ]"
		echo "\e[1;31mR을 설치해야 데이터 수집, 그래프 그리기가 가능합니다.\e[0m"
		exit
	fi
}

function get_data()
{
	MemFree_kb=`cat /proc/meminfo | grep MemFree | awk '{print $2}'`
	MemFree_mb=`echo "$MemFree_kb 1024" | awk '{print $1/$2}'`
	Cached_kb=`cat /proc/meminfo | grep ^Cached | awk '{print $2}'`
	Cached_mb=`echo "$Cached_kb 1024" | awk '{print $1/$2}'`
	Active_anon_kb=`cat /proc/meminfo | grep Active\(anon\) | awk '{print $2}'`
	Active_file_kb=`cat /proc/meminfo | grep Active\(file\) | awk '{print $2}'`
	Active_kb=`expr $Active_anon_kb + $Active_file_kb`
	Active_mb=`echo "$Active_kb 1024" | awk '{print $1/$2}'`

	WEEK=`date +%W`
	YEAR=`date +%Y`
	MONTH=`date +%m`
	DAY=`date +%d`
	HOUR=`date +%H`
	MINUTE=`date +%M`
	SECOND=`date +%S`
}

function print_data()
{
	for ((;;))
	do
		get_data
		echo "$DAY-$MONTH-$YEAR $HOUR:$MINUTE:$SECOND +0009,$MemFree_mb,$Active_mb,$Cached_mb" >> $MEM_STATISTICS
		sleep 1m	# 데이터 수집 주기 설정 ex) 30s -> 30초, 10m -> 10분, 1h -> 1시간
	done
}

function init_document()
{
	if [ -e $MEM_STATISTICS ]; then
		:		#NOP (csv 파일이 존재하면 init_document 함수를 실행하지 않음)
	else
		echo "Timestamp,MemFree,Active,Cached" > $MEM_STATISTICS
	fi
}

# 1개의 프로세스만 메모리 사용량을 수집하도록 함.
function process_check()
{
	PID_TXT=pid.txt
	pgrep collect_data.sh  > $PID_TXT
	PID_COUNT=`cat pid.txt | wc -l`
	
	if [ $PID_COUNT -ge 2 ]; then
		echo "이미 프로세스가 실행 중입니다. 데이터 수집은 1개의 프로세스만 실행해야 합니다."
			rm -rf $PID_TXT
		exit
	fi
	
	rm -rf $PID_TXT
}

R_check
process_check
init_document 

#echo "collect_data.sh 프로세스 개수: $PROCESS_NUM"
#echo "collect_data.sh 프로세스 번호: `pgrep collect_data.sh`"
#echo "`ps aux | grep collect_data.sh`"

if [ "$1" == "stop" ];then
	pkill collect_data.sh	# 데이터 수집을 중지함
else
	print_data
fi
