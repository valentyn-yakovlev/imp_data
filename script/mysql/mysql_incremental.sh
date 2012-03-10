#!/bin/sh

export PATH=/usr/bin:/bin:/usr/sbin:/opt/mysql/bin:/sbin:$PATH

DATE=`date +%d%b%Y`

BINLOG_FILE_NO=$(/bin/ls -tr /opt/mysql/data/binary-log.0*  | tail -1 | sed 's/^.*binary\.//g')

/bin/mkdir -p /home/ankur/daily_binlog_backup/$DATE

/bin/cp $BINLOG_FILE_NO /home/ankur/daily_binlog_backup/$DATE

/opt/mysql/bin/mysql -u root -padmin -e "flush logs" --socket=/tmp/mysql.sock

cd /home/ankur/daily_binlog_backup/$DATE

/usr/bin/mysqlbinlog binary-log.* > incremental_$DATE.sql

/bin/gzip -q /home/ankur/daily_binlog_backup/$DATE/incremental*

/bin/rm -f /home/ankur/daily_binlog_backup/$DATE/binary-log.*

echo "incremental backup done"
