echo 'Current Branch'
git count-objects -vH | grep size-pack | cut -d' ' -f 2-3
echo ''
echo 'Total Local Storage'
du . -hs | cut -f 1
