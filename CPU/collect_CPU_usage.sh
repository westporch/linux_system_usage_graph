#!/bin/bash
#Hyeongwan Seo

CPU_STATISTICS=cpu_statistics.csv

#시스템에 R이 설치되었는지 확인함.
function R_check()
{
    if [ -e "/usr/bin/Rscript" ]; then
        echo -e "R 설치 확인:               [  \e[1;32mOK\e[0m  ]"
    else
        echo -e "R 설치 확인:               [  \e[1;31mFAIL\e[0m  ]"
        echo "\e[1;31mR을 설치해야 데이터 수집, 그래프 그리기가 가능합니다.\e[0m"
        exit
    fi  
}

#시스템에 SAR이 설치되었는지 확인함.
function SAR_check()
{
    if [ -e "/usr/bin/sar" ]; then
        echo -e "sar 설치 확인:             [  \e[1;32mOK\e[0m  ]"
    else
        echo -e "sar 설치 확인:       	      [  \e[1;31mFAIL\e[0m  ]"
        echo "\e[1;31msar을 설치해야 데이터 수집, 그래프 그리기가 가능합니다.\e[0m"
		echo "\e[1;31m(apt-get install sysstat OR yum install sysstat)\e[0m"
        exit
    fi  
}


function get_data()
{
	#날짜 및 시간 정보를 수집함
	WEEK=`date +%W`
    YEAR=`date +%Y`
    MONTH=`date +%m`
    DAY=`date +%d`
    HOUR=`date +%H`
    MINUTE=`date +%M`
    SECOND=`date +%S`

	#CPU 정보를 수집함
    CPU_USAGE=`sar -u 1 1 | grep Average | awk '{print $3}'` #300은 5분, 5는 5회를 의미함
    CPU_IDLE=`sar -u 1 1 | grep Average | awk '{print $8}'`
}

function print_data()
{
    for ((;;))
    do
        get_data
        echo "$DAY-$MONTH-$YEAR $HOUR:$MINUTE:$SECOND +0009,$CPU_USAGE,$CPU_IDLE" >> $CPU_STATISTICS
		sleep 1m
    done
}

function init_document()
{
    if [ -e $CPU_STATISTICS ]; then
        :       #NOP (csv 파일이 존재하면 init_document 함수를 실행하지 않음)
    else
        echo "Timestamp,Usage,Idle" > $CPU_STATISTICS
    fi
}

# 1개의 프로세스만 CPU 사용량을 수집하도록 함.
function process_check()
{
    PID_TXT=$CPU_STATISTICS-pid.txt
    pgrep collect_CPU_data.sh  > $PID_TXT
    PID_COUNT=`cat $PID_TXT | wc -l`
    
    if [ $PID_COUNT -ge 2 ]; then
        echo "이미 프로세스가 실행 중입니다. 데이터 수집은 1개의 프로세스만 실행해야 합니다."
            rm -rf $PID_TXT
        exit
	else
		rm -rf $PID_TXT
    fi
}

R_check
SAR_check
process_check
init_document 

if [ "$1" == "stop" ];then
    pkill collect_CPU_usage.sh   # 데이터 수집을 중지함
else
    print_data
fi                          
