#!/bin/bash

# pctenter.sh
# Скрипт подключения к контейнеру на любой ноде. Пример использования pctenter.sh <vmid>
# Автор: Семененко А.Г.


# Настройка чтобы pipeline возвращал ошибку в случае ошибки любой из команд
set -o pipefail

case "$1" in
-h)
echo "Скрипт подключения к контейнеру на любой ноде. Пример использования pctenter.sh <vmid>"
;;

*)
# Проверяем существует ли контейнер
pvesh get /cluster/resources/ -type vm | jq '.[] | select(.type == "lxc") | .node, .vmid' | tr -d \" | awk 'NR%2{printf "%s ",$0;next;}1' | grep " $1$" | awk '{print $1}'
if [[ $? -ne 0 ]]
then
   echo "Error: LXC $1 does not exist"
   exit
fi

# Подключимся к контейнеру
node=`pvesh get /cluster/resources/ -type vm | jq '.[] | select(.type == "lxc") | .node, .vmid' | tr -d \" | awk 'NR%2{printf "%s ",$0;next;}1' | grep " $1$" | awk '{print $1}'`
ssh $node -t "pct enter $1"
;;
esac
