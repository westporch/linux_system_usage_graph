#!/bin/bash

#HyunGwan Seo

#./collect_data.sh stop -> 데이터 수집을 중지함.

ALL_DATA=all_data.txt

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
			echo "$WEEK,$YEAR,$MONTH,$DAY,$HOUR,$MINUTE,$SECOND,$MemFree_mb,$Active_mb,$Cached_mb" >> collect_data.txt
			sleep 1m	# 데이터 수집 주기 설정 ex) 30s -> 30초, 10m -> 10분, 1h -> 1시간
		done
}

function init_document()
{
	echo "Week,Year,Month,Day,Hour,Minute,Second,MemFree,Active,Cached" > collect_data.txt
}

if [ "$1" == "stop" ];then
	pkill collect_data.sh	# 데이터 수집을 중지함
else
	init_document
	print_data
fi
