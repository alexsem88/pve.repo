#!/bin/bash

# pct.sh
# Скрипт работы с контейнерами по всему кластеру ProxMox
# Автор: Семененко А.Г.

set -o pipefail

listpct() {
pvesh get /cluster/resources/ -type vm | jq '.[] | select(.type == "lxc") | .vmid, .name, .node' | tr -d \" | awk 'NR%3{printf "%s ",$0;next;}1'
}

case "$1" in
-h)
echo -e "Скрипт работы с контейнерами по всему кластеру ProxMox.
Опции:
 -h показать эту справку;
 -l вывести список контейнеров;
 -e <lxc_id> подключиться к контейнеру."
;;

-l)
listpct | column -t | sort -k1 -n | less
;;

-e)
# Проверяем существует ли контейнер
listpct | grep "$2 " | awk '{print $3}'
if [[ $? -ne 0 ]]
then
   echo "Error: LXC $2 does not exist"
   exit
fi

# Подключимся к контейнеру
node=`listpct | grep "$2 " | awk '{print $3}'`
ssh $node -t "pct enter $2"
;;

esac