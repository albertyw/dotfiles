#!/bin/bash
# This script diffs the structure of two directories
# without comparing file contents

file1="$(find $1 | sed "s/${1//\//\\/}//g" | sort)"
file2="$(find $2 | sed "s/${2//\//\\/}//g" | sort)"
diff <(echo "$file1") <(echo "$file2")
