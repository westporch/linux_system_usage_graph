#!/bin/bash

MemFree_kb=`cat /proc/meminfo | grep MemFree | awk '{print $2}'`
Cached_kb=`cat /proc/meminfo | grep ^Cached | awk '{print $2}'`
Active_anon_kb=`cat /proc/meminfo | grep Active\(anon\) | awk '{print $2}'`
Active_file_kb=`cat /proc/meminfo | grep Active\(file\) | awk '{print $2}'`
Active=`expr $Active_anon_kb + $Active_file_kb`

echo $Active_anon_kb
echo $Active_file_kb
echo $Active


