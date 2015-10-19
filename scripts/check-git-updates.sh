# Check if there are updates to this dotfiles repo
cd ~/.dotfiles
git fetch
diffoutput=$(git diff HEAD..origin)
if [ "$diffoutput" != "" ] ; then
    echo 'YOUR DOTFILES ARE OUT OF DATE';
fi
changes=$(git diff)
if [ "$changes" != "" ]; then
    echo 'YOU HAVE UNCOMMITTED CHANGES';
fi

# Check if there are updates to ssh
if [ -d ~/.ssh/.git ]; then
    cd ~/.ssh
    git fetch
    diffoutput=$(git diff HEAD..origin)
    if [ "$diffoutput" != "" ] ; then
        echo 'YOUR SSH IS OUT OF DATE';
    fi
    changes=$(git diff)
    if [ "$changes" != "" ]; then
        echo 'YOU HAVE UNCOMMITTED SSH CHANGES';
    fi
fi