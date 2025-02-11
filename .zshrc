# some aliases
alias ls="ls -G"
alias ll="ls -la"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

export TERM=xterm-256color

# starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# neofetch
neofetch --ascii ~/.config/neofetch/ascii/sakamoto --ascii_colors 15 9 8

# my dotfiles versioning
alias mydotfiles='/usr/bin/git --git-dir=$HOME/.mydotfiles.git/ --work-tree=$HOME'

