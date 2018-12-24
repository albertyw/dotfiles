set -e

check_internet () {
    ping github.com -c 1 > /dev/null
}

check () {
    git fetch

    git submodule --quiet init
    git submodule --quiet update --recursive

    changes="$(git diff)"
    if [ "$changes" != "" ]; then
        echo 'YOU HAVE UNCOMMITTED CHANGES';
        exit
    fi

    changes="$(git ls-files --others --exclude-standard)"
    if [ "$changes" != "" ]; then
        echo 'YOU HAVE UNCOMMITTED FILES';
        exit
    fi

    changes="$(git diff HEAD..FETCH_HEAD)"
    if [ "$changes" != "" ] ; then
        git pull --quiet > /dev/null 2>&1
        ~/.dotfiles/scripts/chmod-private-keys.sh
        echo 'Dotfiles updated'
    fi

    git submodule --quiet init
    git submodule --quiet update --recursive
}

# Check if there are updates to this dotfiles repo
cd ~/.dotfiles

check_internet
check

# Check if there are updates to ssh
if [ -d ~/.ssh/.git ]; then
    cd ~/.ssh
    check
fi
