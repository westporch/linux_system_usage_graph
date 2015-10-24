#!/bin/bash

#Hyeongwan Seo

R --quiet --no-save << EOF
library(sqldf) 	# sqldf 라이브러리를 로드함.

mem <- read.csv('mem_statistics.csv')
#mem
sqldf('select * from mem')                              

EOF
