#!/bin/sh
mkdir -p /home/ankur/Log_Backup/node2/`date +%d%b%Y`
DATE=`date +%d%b%Y`
echo "copying files...."
cd /opt/jboss-4.0.2.node2/server/default/log/
cp -p jbossserver.log /home/ankur/Log_Backup/node2/$DATE
echo "changing permission of files.."
chmod 644 /home/ankur/Log_Backup/node2/$DATE/*
echo "changing ownership of file"
chown -R ankur.ankur /home/ankur/Log_Backup/node2/$DATE/
gzip /home/ankur/Log_Backup/node2/$DATE/*
echo "done"
