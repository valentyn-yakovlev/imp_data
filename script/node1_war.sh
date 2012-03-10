#!/bin/sh
mkdir -p /home/ankur/Log_Backup/node1_war/`date +%d%b%Y`
DATE=`date +%d%b%Y`
echo "copying files...."
cd /opt/jboss-4.0.2.node1/server/default/deploy/
cp -rp octashop.war staging.war /home/ankur/Log_Backup/node1_war/$DATE
echo "changing permission of files.."
chmod 755 /home/ankur/Log_Backup/node1_war/$DATE/*
echo "changing ownership of file"
chown -R ankur.ankur /home/ankur/Log_Backup/node1_war/$DATE/
echo "done"
