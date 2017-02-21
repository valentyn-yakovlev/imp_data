#!/bin/sh

PREV_DATE=$(date +'%Y-%m-%d' --date='1 day ago')

mutt -s "Load average report for $PREV_DATE" -a /var/tmp/monitor.log.$PREV_DATE   <  /dev/null
