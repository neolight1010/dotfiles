bindkey -v

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="refined"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="mm/dd/yyyy"

###### OTHERS ############
export LESS="-RXF"

export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=("nvim" "ng")

########### ZSH Vi Mode #########
function zvm_config() {
    ZVM_VI_INSERT_ESCAPE_BINDKEY=kj
    ZVM_TERM=xterm-256color
}

####### PLUGINS #######
plugins=(
    git
    docker
    ssh-agent
    tmux
    z
)

source ~/.zplug/init.zsh
zplug "lukechilds/zsh-nvm"
zplug "mattberther/zsh-pyenv"
zplug "ptavares/zsh-exa"
zplug "zsh-users/zsh-autosuggestions"
zplug "jeffreytse/zsh-vi-mode"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load 

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
export EDITOR='nvim'
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

############# Aliases ##########33
alias tmx="tmuxinator"
alias j="z"
alias ls="exa"
alias k="ls"

############# Deno ################
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

########### ZOxide ############
eval "$(zoxide init zsh)"

######### rbenv ##########
eval "$(rbenv init -)"

######## direnv #########
eval "$(direnv hook zsh)"

############## Poetry ###############
export PATH="$HOME/.poetry/bin:$PATH"

############## WSL GUI Support ##################
# export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
# export LIBGL_ALWAYS_INDIRECT=1
# sudo /etc/init.d/dbus start &> /dev/null

######## GHCup #########
[ -f "/home/neolight1010/.ghcup/env" ] && source "/home/neolight1010/.ghcup/env" # ghcup-env

#################### Others ###################
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/src/jdk-11.0.12+7/bin/:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/emulator

export PNPM_HOME="/home/neolight1010/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[[ -s "/home/neolight1010/.gvm/scripts/gvm" ]] && source "/home/neolight1010/.gvm/scripts/gvm"

#### Starship ####
eval "$(starship init zsh)"
