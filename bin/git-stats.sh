#!/bin/bash

echo "Users by commits"
git shortlog -sn

echo ""
echo "Users by line changes"
git ls-files | \
    xargs -n1 git blame --line-porcelain 2> /dev/null | \
    sed -n 's/^author //p' | \
    sort -f | \
    uniq -ic | \
    sort -nr

echo ""
echo "Users by existing lines"
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    regexsed="sed -r"
elif [[ "$unamestr" == 'Darwin' ]]; then
    regexsed='sed -E'
fi
git ls-tree -r HEAD | \
    $regexsed -e 's/^.{53}//' | \
    while read filename; do
        file "$filename";
    done | \
    grep -E ': .*text' | \
    $regexsed -e 's/: .*//' | \
    while read filename; do
        git blame -w "$filename";
    done | \
    $regexsed -e 's/.*\((.*)[0-9]{4}-[0-9]{2}-[0-9]{2} .*/\1/' -e 's/ +$//' | \
    sort | \
    uniq -c | \
    sort -nr