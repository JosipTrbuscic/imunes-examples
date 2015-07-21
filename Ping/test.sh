#!/bin/sh

. ../common/procedures.sh

err=0

eid=`imunes -b ping.imn | awk '/Experiment/{print $4; exit}'`
startCheck "$eid"

netDump pc1@$eid eth0 icmp
if [ $? -eq 0 ]; then
    n=1
    pingStatus=1
    while [ $n -le 20 ] && [ $pingStats -ne 0 ]; do
        echo "Ping test $n / 20 ..."
        pingCheck pc1@$eid 10.0.8.10 2
        pingStatus=$?
        n=`expr $n + 1`
    done
    if [ $pingStatus -eq 0 ]; then

	sleep 2
	readDump pc1@$eid eth0
	err=$?
    else
	err=1
    fi
else
    err=1
fi

imunes -b -e $eid

thereWereErrors $err
