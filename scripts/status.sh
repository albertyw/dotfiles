#!/bin/sh

echo "\033[44m TEMPERATURES \033[0m"
temperature
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
