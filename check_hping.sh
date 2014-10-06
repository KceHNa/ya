#!/bin/bash                                                                                                                                                                                             
#
#example
#sudo hping3 192.168.1.24 --tos 28 -S -p 80 -c 2

Host_to=$1
ToS=$2
Const=7
Port=80

hping3 $Host_to --tos $ToS -S -p $Port -c $Const  > /dev/null 2>/var/log/hping3_nrpe.log

X=`tail -n1 /var/log/hping3_nrpe.log|sed 's/round-trip //'`
Los=`tail -n2 /var/log/hping3_nrpe.log| sed '/^[0-9] packets transmitted, [0-9] packets received, */!d; s///;q'`

if [[ -z $X ]]
then X=3
fi

if [[ $Los = 100* ]]
then X=1
fi

case $X in
        3) echo "HPING3 UNKNOWN - net patametrov"
        exit 3
        ;;
        2) echo "HPING3 CRITICAL - xz xz"
        exit 2
        ;;
        1) echo "HPING3 WARNING - not ping to $Host_to:$Port $Los "
        exit 1
        ;;
        *) echo "HPING3 OK - $X $Los"
        exit 0
        ;;
esac
