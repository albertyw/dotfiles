head -n1 /etc/issue
uname -a
grep "model name" /proc/cpuinfo
grep MemTotal /proc/meminfo
echo ""
cat /proc/partitions
echo ""
df -h
echo ""
lspci
echo ""
lsusb
