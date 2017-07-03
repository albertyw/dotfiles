#!/bin/bash

# Get Ubuntu version
echo "UBUNTU VERSION"
lsb_release -a
echo ""

echo "CPU"
grep "model name" /proc/cpuinfo
echo ""

echo "MEMORY"
grep MemTotal /proc/meminfo
echo ""

echo "DISK PARTITIONS"
cat /proc/partitions
echo ""

echo "DRIVES"
df -h
echo ""

echo "PCI DEVICES"
lspci
echo ""

echo "USB DEVICES"
lsusb
