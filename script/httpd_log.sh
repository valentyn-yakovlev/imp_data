#!/bin/sh
mkdir -p /home/ankur/Log_Backup/httpd/`date +%d%b%Y`
DATE=`date +%d%b%Y`
echo "copying files...."
cd /opt/apache/logs/
cp -p www.fnp.in-access_log www.fnp.in-error_log /home/ankur/Log_Backup/httpd/$DATE
echo "changing permission of files.."
chmod 644 /home/ankur/Log_Backup/httpd/$DATE/*
echo "changing ownership of file"
chown -R ankur.ankur /home/ankur/Log_Backup/httpd/$DATE/
gzip /home/ankur/Log_Backup/httpd/$DATE/*
echo "done"
