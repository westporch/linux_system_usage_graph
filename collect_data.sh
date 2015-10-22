#!/bin/bash

MemFree_kb=`cat /proc/meminfo | grep MemFree | awk '{print $2}'`
MemFree_mb=`echo "$MemFree_kb 1024" | awk '{print $1/$2}'`
Cached_kb=`cat /proc/meminfo | grep ^Cached | awk '{print $2}'`
Cached_mb=`echo "$Cached_kb 1024" | awk '{print $1/$2}'`
Active_anon_kb=`cat /proc/meminfo | grep Active\(anon\) | awk '{print $2}'`
Active_file_kb=`cat /proc/meminfo | grep Active\(file\) | awk '{print $2}'`
Active_kb=`expr $Active_anon_kb + $Active_file_kb`
Active_mb=`echo "$Active_kb 1024" | awk '{print $1/$2}'`

echo $MemFree_kb
echo $MemFree_mb
echo $Cached_kb
echo $Cached_mb
echo $Active_kb
echo $Active_mb


