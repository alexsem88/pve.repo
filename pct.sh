#!/bin/bash

# pct.sh
# Скрипт работы с контейнерами по всему кластеру.
# Автор: Семененко А.Г.

set -o pipefail

listpct() {
pvesh get /cluster/resources/ -type vm | jq '.[] | select(.type == "lxc") | .vmid, .name, .node' | tr -d \" | awk 'NR%3{printf "%s ",$0;next;}1'
}

case "$1" in
-h)
echo "Скрипт работы контейнера по всему кластеру. -h выводит эту справку. -l выводит список контейнеров. -e <lxc_id> подключается к контейнеру."
;;

-l)
listpct | column -t | sort -k1 -n | less
;;

-e)
# Проверяем существует ли контейнер
#pvesh get /cluster/resources/ -type vm | jq '.[] | select(.type == "lxc") | .node, .vmid' | tr -d \" | awk 'NR%2{printf "%s ",$0;next;}1' | grep " $1$" | awk '{print $1}'
listpct | grep "$2 " | awk '{print $3}'
if [[ $? -ne 0 ]]
then
   echo "Error: LXC $2 does not exist"
   exit
fi

# Подключимся к контейнеру
#node=`pvesh get /cluster/resources/ -type vm | jq '.[] | select(.type == "lxc") | .node, .vmid' | tr -d \" | awk 'NR%2{printf "%s ",$0;next;}1' | grep " $2$" | awk '{print $1}'`
node=`listpct | grep "$2 " | awk '{print $3}'`
ssh $node -t "pct enter $2"
;;

esac
