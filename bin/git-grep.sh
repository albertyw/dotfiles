#!/bin/bash
repos=( 'db' 'scripts' 'tools' 'common' 'ui' 'cam' );
cd /home/vagrant/limsnew/
for i in ${repos[@]}; do
    echo -e "\033[44m**$i**\033[0m\n"
    cd $i
    echo -e "$(git grep --color --line-number $1)"
    cd ..
done
cd -
