#!/bin/sh

sudo apt install lm-sensors smartmontools

echo "\033[44m TEMPERATURES \033[0m"
sensors
echo ""

echo "\033[44m DISK HEALTH \033[0m"
echo "SDA"
sudo smartctl -HA /dev/sda
echo ""

echo "\033[44m DISK USAGE \033[0m"
df -h | grep 'sda\|Filesystem'
echo ""

echo "\033[44m NETWORK \033[0m"
ifconfig enp0s25
echo ""

echo "\033[44m UPTIME/USERS \033[0m"
w
echo ""

echo "\033[44m MEMORY \033[0m"
printf '\033[?7l'
ps aux | sed -n 1p && ps aux | sort -b -k 4 | tail -n 30
printf '\033[?7h'
echo ""
