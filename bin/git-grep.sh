#!/bin/bash
repos=( 'db' 'scripts' 'tools' 'common' 'ui' 'cam' );
cd /home/vagrant/lims/
#!/bin/bash
for i in */.git; do
    echo -e "\033[44m**$i**\033[0m\n"
    cd `dirname $i`
    git grep --color --line-number "$@"
    echo ""
    cd ..
done
