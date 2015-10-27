if (which brew); then
  tell "brew is installed - let's tab something nice!"
else
  tell "brew is not installed - let's install it!"

  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
