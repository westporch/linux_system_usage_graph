#!/bin/bash

R --quiet --no-save << EOF

getwd()

mem <- read.csv('mem_statistics.csv')
mem
sqldf('select * from mem')

EOF
