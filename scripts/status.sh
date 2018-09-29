#!/bin/sh

sudo apt install lm-sensors smartmontools hddtemp discus sysstat

echo "\033[44m TEMPERATURES \033[0m"
sensors
echo ""

echo "\033[44m DISK HEALTH \033[0m"
echo "SDA"
sudo smartctl -HA /dev/sda
echo ""

echo "\033[44m DISK USAGE \033[0m"
discus
echo ""

echo "\033[44m NETWORK \033[0m"
ifconfig
echo ""

echo "\033[44m UPTIME/USERS \033[0m"
w
echo ""

echo "\033[44m MEMORY \033[0m"
free -m
echo ""

echo "\033[44m IOSTAT \033[0m"
iostat -m
