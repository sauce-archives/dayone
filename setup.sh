#!/usr/bin/env bash

# Escalate to sudo
echo "sudo is needed for Sauce setup."
sudo echo "Thank you"

# Install Homebrew
if ! brew --version > /dev/null 2>&1; then
  echo "Installing brew"
  yes '' | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "homebrew already installed"
fi

# Install Homebrew packages
brew update
brew install git


#git ls-remote "https://github.com/saucelabs/dummy.git" 2> /dev/null


# echo "Where would you like code stored? (default: ~/code/)"
# read INPUT
# INPUT="${INPUT/#\~/$HOME}"
# CODE_ROOT=${INPUT:-$HOME/code}
# echo $CODE_ROOT

# Check if user has access to Github sauce organization

