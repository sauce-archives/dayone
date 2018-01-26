#!/usr/bin/env bash

GITHUB_SSH_KEY=$HOME/.ssh/id_rsa.github
SSH_CONFIG=$HOME/.ssh/config

create_and_add_github_ssh_key_to_ssh_agent() {
  yes no | ssh-keygen -t rsa -b 4096 -C "${EMAIL}" -N '' -f $GITHUB_SSH_KEY
  eval "$(ssh-agent -s)"
  if ! grep "$GITHUB_SSH_KEY" $SSH_CONFIG; then
    cat <<EOT >> $SSH_CONFIG
Host *
 AddKeysToAgent yes
 UseKeychain yes
 IdentityFile ~/.ssh/id_rsa.github
EOT
  fi
  ssh-add -K $GITHUB_SSH_KEY
}

add_ssh_key_to_github_account() {
  echo "SauceLabs dedicated GitHub username:"
  read USER
  RSA_KEY=$(cat ${GITHUB_SSH_KEY}.pub)
  curl -d -u $USER "{\"title\": \"SauceLabs\", \"key\": \"$RSA_KEY\"}" -X POST https://api.github.com/user/keys
}

# Escalate to sudo
echo "sudo is needed for Sauce setup."
sudo echo "Thank you"

# Get needed user input
echo "Your SauceLabs email address:"
read EMAIL

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

# Get git access to saucelabs org
ssh -oStrictHostKeyChecking=no -T git@github.com
if [ $? -eq 1 ]; then
  echo "GitHub SSH keys already configured"
else
  create_and_add_github_ssh_key_to_ssh_agent
  add_ssh_key_to_github_account
fi
git ls-remote "git@github.com:saucelabs/dummy.git" 2> /dev/null
# git ls-remote "https://github.com/saucelabs/dummy.git" 2> /dev/null


# echo "Where would you like code stored? (default: ~/code/)"
# read INPUT
# INPUT="${INPUT/#\~/$HOME}"
# CODE_ROOT=${INPUT:-$HOME/code}
# echo $CODE_ROOT

# Check if user has access to Github sauce organization

