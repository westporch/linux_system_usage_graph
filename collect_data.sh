#!/bin/bash

#HyunGwan Seo

#./collect_data.sh stop -> 데이터 수집을 중지함.

MEM_STATISTICS=mem_statistics.csv

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
		echo "$WEEK,$YEAR,$MONTH,$DAY,$HOUR,$MINUTE,$SECOND,$MemFree_mb,$Active_mb,$Cached_mb" >> $MEM_STATISTICS
		sleep 2s	# 데이터 수집 주기 설정 ex) 30s -> 30초, 10m -> 10분, 1h -> 1시간
	done
}

function init_document()
{
	echo "Week,Year,Month,Day,Hour,Minute,Second,MemFree,Active,Cached" > $MEM_STATISTICS
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

init_document
process_check

#echo "collect_data.sh 프로세스 개수: $PROCESS_NUM"
#echo "collect_data.sh 프로세스 번호: `pgrep collect_data.sh`"
#echo "`ps aux | grep collect_data.sh`"

#if [ "$1" == "stop" ];then
#	pkill collect_data.sh	# 데이터 수집을 중지함
#else
	print_data
#fi