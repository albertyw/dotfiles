check () {
    git fetch
    
    changes=$(git diff)
    if [ "$changes" != "" ]; then
        echo 'YOU HAVE UNCOMMITTED CHANGES';
    fi

    changes=$(git ls-files --others --exclude-standard)
    if [ "$changes" != "" ]; then
        echo 'YOU HAVE UNCOMMITTED FILES';
    fi
    
    changes=$(git diff HEAD..FETCH_HEAD)
    if [ "$changes" != "" ] ; then
        echo 'YOUR DOTFILES ARE OUT OF DATE';
    fi
}

# Check if there are updates to this dotfiles repo
cd ~/.dotfiles
check

# Check if there are updates to ssh
if [ -d ~/.ssh/.git ]; then
    cd ~/.ssh
    check
fi
