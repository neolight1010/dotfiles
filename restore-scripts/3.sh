# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

ROOT=$(readlink -f ..)

rm ~/.zshrc
ln -s $ROOT/zsh/.zshrc ~/.zshrc

exec $SHELL

# node
nvm install --lts
npm install -g yarn

# neovim
# vim-plug

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

yarn global add neovim

pyenv virtualenv 3.10.10 py3nvim
pyenv activate py3nvim
pip install pynvim
pyenv deactivate

rm ~/.config/nvim/init.vim
ln -s $ROOT/nvim/init.vim ~/.config/nvim/init.vim

rm ~/.config/nvim/coc-settings.json
ln -s $ROOT/nvim/coc-settings.json ~/.config/nvim/coc-settings.json

nvim --headless +PlugInstall +qa
