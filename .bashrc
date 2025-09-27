#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ls aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# dotfiles versioning
alias mydotfiles='/usr/bin/git --git-dir=$HOME/.mydotfiles.git/ --work-tree=$HOME'

# git autocomplete
. /usr/share/git/completion/git-completion.bash

# neofetch
neofetch --ascii ~/.config/neofetch/ascii/sakamoto --ascii_colors 15 9 8

# starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init bash)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# lscolors
source ~/.config/lscolors.sh

# Created by `pipx` on 2025-05-18 12:21:43
export PATH="$PATH:/home/tenick/.local/bin"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# LateX
export PATH="/usr/local/texlive/2025/bin/x86_64-linux:$PATH"
export INFOPATH="/usr/local/texlive/2025/texmf-dist/doc/info:$INFOPATH"
