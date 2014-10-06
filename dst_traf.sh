#!/bin/sh

#
# Client
#

IPz=$2
Time=$3
echo "on client IP = $IPz"

while getopts ":t:v:-:" OPTION;
    do
        case "$OPTION" in
            t ) echo tARG="$OPTARG"
                len='512'
                bandwidth="7000k"
        ;;
            v ) echo vARG="$OPTARG"
                len='204'
                bandwidth="10000k"
        ;;
            * ) echo "Pechalko"
        ;;
        esac
    done

echo ">>>>>>>>>>Start client>>>>>>>>>>>"
iperf -u -c $IPz -l$len -b$bandwidth -t$Time  > /dev/null 2>&1

echo ">>Sleep DST>>"
sleep 15
#runtime=${3:-${Time}s}

echo ">>>>>>>>>>>Start server>>>>>>>>>>"
mypid=$$
iperf -u -s -l$len &
clockpid=$!
echo "My PID=$mypid. Clock's PID=$clockpid"
ps -f $clockpid
#Sleep for the specified time.
sleep $Time
kill -s TERM $clockpid
exit
