#!/bin/sh
echo "-------------------------------------------------------------------------------------------------------"
loadavg=`uptime |cut -d ',' -f4,5,6`
serverStatus=`ps -ef|grep java|grep -v grep|wc -l|awk '{if($0>0) {print "UP"} else {print "DOWN"}}'`
dbconn=`netstat -nto|grep 3306|grep ESTABLISHED|wc -l`
jkconn_fe=`netstat -nto|grep 8009|grep ESTABLISHED|wc -l`
jkconn_oms=`netstat -nto|grep 9009|grep ESTABLISHED|wc -l`

echo "`date +"%d/%b/%Y:%T"` $loadavg  $serverStatus  dbconn: $((dbconn/2))  jkconn Fe: $((jkconn_fe/2)) jkconn OMS: $((jkconn_oms/2)) "
#awk '{print "Date:"$1 " Time:" $2 " L1:" $6 " L2:" $7  " L3" $8 " DB" $10 " JK" $12}'
echo "----------------------------------------------------------------------------------------------------"

