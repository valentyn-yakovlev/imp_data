#!/bin/sh

DATE=$(date +'%Y-%m-%d')
/octashop_local/scripts/monitor.sh >> /var/tmp/monitor.log.$DATE
