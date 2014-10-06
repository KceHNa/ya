#!/bin/bash

#script -v|t XX.XX.XX.XX s

IPz=$2
#Time='20'
Time=$3
IPme=$(ifconfig eth0| sed -n '2 {s/^.*inet addr:\([0-9.]*\) .*/\1/;p}')
IPt="/sbin/iptables"

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

$IPt -Z

#runtime=${3:-${Time}s}
ssh root@$IPz -i /root/.ssh/debian-ks_rsa "sh /opt/dst_traf.sh $1 $IPme $Time"&
echo "| "
echo "==========Start server============"
iperf -u -s -l$len >> /opt/jitter.log &
Jit=`tail -n1 /opt/jitter.log | head -c 60 | tail -c 12`
iperfpid=$!
echo "My PID=$mypid. Clock's PID=$clockpid"
ps -f $clockpid
sleep $Time
kill -s TERM $iperfpid
echo $Jit


echo "==Sleep SRC=="
sleep 20

echo "\r"
echo "===========Start client==========="
iperf -u -c $IPz -l$len -b$bandwidth -t$Time > /dev/null 2>&1

echo "___________Trafik schet___________"
IN=`$IPt -L INPUT -v -x | grep anywhere | head -c 18 | tail -c 9`
FW=`$IPt -L OUTPUT -v -x | grep anywhere | head -c 18 | tail -c 9`
RX=`expr $IN + $FW`
echo $IN + $FW = $RX
let "RX = $RX / 1024"
DATA=`date`
echo "$DATA - $RX Kb - $Jit" >> /opt/traffic.log
$IPt -Z

