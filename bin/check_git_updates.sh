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
