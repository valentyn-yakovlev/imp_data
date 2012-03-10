#!/bin/sh

exec 2>> /var/tmp/lucene_lock.log
set -x

if test -f /tmp/lucene-*-commit.lock
then
        rm -f /tmp/lucene-*-commit.lock
        mutt -s "lucene lockfile removed on $(date) on FnP server" fnpsupport@anmsoft.com  < /dev/null
        PID=$(ps ax | grep "/opt.jboss-4.0.2.node1.bin.run.jar" | grep -v "grep" | awk '{print $1}')
        test -n $PID && kill -9 $PID 
        nohup /opt/jboss-4.0.2.node1/bin/run.sh &
        unset PID
fi
