#!/bin/bash
sudo apt update
sudo apt upgrade -y

# Programs
sudo apt install curl -y
sudo apt install tmux -y

sudo apt install zsh -y
sudo apt install autojump -y

sudo apt install neovim -y
sudo apt install silversearcher-ag -y

## Python build dependencies
sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

rm ~/.tmux.conf
ln ./tmux/.tmux.conf ~/.tmux.conf

# After script is finished, open tmux and press prefix+I to install
# plugins.

# python
curl https://pyenv.run | bash

## oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

zsh ./restore-scripts/post-zsh.sh
