echo 'Current Branch'
git count-objects -vH | grep size-pack | cut -d' ' -f 2-3
echo ''
echo 'Total Local Storage'
du . -hs | cut -f 1
echo ''
echo 'Top 20 Largest Commits'
git-size-commit.pl | sort -hr | head -n 20
