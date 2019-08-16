#!/bin/bash

# pctlist.sh
# Скрипт отображения всех lxc в кластере. Выводит номера lxc и имена контейнеров.
# Автор: Семененко А.Г.

case "$1" in
-h)
echo "Скрипт отображения всех lxc в кластере. Выводит номера lxc и имена контейнеров."
;;

*)
pvesh get /cluster/resources/ -type vm | jq '.[] | select(.type == "lxc") | .vmid, .name, .node' | tr -d \" | awk 'NR%3{printf "%s ",$0;next;}1' | column -t | sort -k1 -n
esac
