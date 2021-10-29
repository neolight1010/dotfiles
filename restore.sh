#!/bin/bash
sudo apt update
sudo apt upgrade

# Programs
sudo apt install curl
sudo apt install tmux

sudo apt install zsh
sudo apt install autojump

sudo apt install neovim
sudo apt install silversearcher-ag

## Python build dependencies
sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

rm ~/.tmux.conf
ln ./tmux/.tmux.conf ~/.tmux.conf

# After script is finished, open tmux and press prefix+I to install
# plugins.

# python
curl https://pyenv.run | bash
pyenv install 3.10.0
pyenv global 3.10.0

# zsh
chsh -s $(which zsh)

## oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

rm ~/.zshrc
ln ./zsh/.zshrc ~/.zshrc

zsh ./restore-scripts/post-zsh.sh
