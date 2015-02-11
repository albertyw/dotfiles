#!/bin/bash

echo "Users by commits"
git shortlog -sn

echo ""
echo "Users by line changes"
git ls-files | xargs -n1 git blame --line-porcelain | sed -n 's/^author //p' | sort -f | uniq -ic | sort -nr

echo ""
echo "Users by existing lines"
git ls-tree -r HEAD|sed -re 's/^.{53}//'|while read filename; do file "$filename"; done|grep -E ': .*text'|sed -r -e 's/: .*//'|while read filename; do git blame -w "$filename"; done|sed -r -e 's/.*\((.*)[0-9]{4}-[0-9]{2}-[0-9]{2} .*/\1/' -e 's/ +$//'|sort|uniq -c
