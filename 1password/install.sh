if [ "$(uname -s)" == "Darwin" ] ; then
    if ! brew list --cask 1password &> /dev/null ; then
        brew install --cask 1password
    fi
fi
