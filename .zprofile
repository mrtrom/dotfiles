# Initialize the completion system
autoload -Uz compinit

# Enhanced form of menu completion called `menu selection'
zmodload -i zsh/complist

# Cache completion if nothing changed - faster startup time
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Commands starting from " " (whitespace) won't be saved in history:
HIST_IGNORE_SPACE="true"

plugins=(
  gitfast
  osx
)

# User configuration:
export PATH="/usr/local/sbin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [ -f ${HOME}/.zplug/init.zsh ]; then
    source ${HOME}/.zplug/init.zsh
fi

source "$HOME/.zplugrc"
source "$HOME/.shell/.zaliases.sh"
source "$HOME/.shell/.exports"
source "$HOME/.shell/.functions"
source "$HOME/.shell/.external"