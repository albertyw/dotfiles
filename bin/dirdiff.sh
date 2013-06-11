#!/bin/bash
# This script diffs the structure of two directories
# without comparing file contents

file1=$(find $1 -printf "%P\n" | sort)
file2=$(find $2 -printf "%P\n" | sort)
diff <(echo "$file1") <(echo "$file2")
