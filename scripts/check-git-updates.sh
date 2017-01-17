check () {
    git fetch

    changes=$(git diff)
    if [ "$changes" != "" ]; then
        echo 'YOU HAVE UNCOMMITTED CHANGES';
        exit
    fi

    changes=$(git ls-files --others --exclude-standard)
    if [ "$changes" != "" ]; then
        echo 'YOU HAVE UNCOMMITTED FILES';
        exit
    fi

    changes=$(git diff HEAD..FETCH_HEAD)
    if [ "$changes" != "" ] ; then
        git pull --quiet > /dev/null
        ~/.dotfiles/scripts/chmod-private-keys.sh
        echo 'Dotfiles updated'
    fi

    git submodule init
    git submodule update --recursive
}

# Check if there are updates to this dotfiles repo
cd ~/.dotfiles
check

# Check if there are updates to ssh
if [ -d ~/.ssh/.git ]; then
    cd ~/.ssh
    check
fi
