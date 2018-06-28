#!/bin/bash
num=$#

if ([ $num -lt 2 ] | [ "`echo $1 | awk -F '.' '{print $2}'`" != "pem" ]);then
echo 'USAGE : COMMAND <key.pem> <"command1"> ["command2"]..'
exit 1
fi

nodelist=`yarn node -list all | awk '/^ip/' | awk -F ':' '{print $1}'`

for arg in "$@"
do

 for i in $nodelist
 do

 ssh -o StrictHostKeyChecking=no -T -i ~/$1 hadoop@$i<<EOF
 if [ "$arg"x != "$1"x ]; then
$arg
 fi

EOF
done

done
