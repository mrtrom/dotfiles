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
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source "$HOME/.shell/.zaliases.sh"
source "$HOME/.shell/.exports"
source "$HOME/.shell/.functions"
source "$HOME/.shell/.external"
source "/Users/mrtrom/.rover/env"
source "$HOME/.cargo/env"

# bun
export BUN_INSTALL="/Users/mrtrom/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

# Deckard
shell_aws() {
    unset -f shell_aws
    eval "$(command shell_aws --shell zsh)"
    shell_aws "$@"
}
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# eval "$(pyenv init - --no-rehash zsh)"
# eval "$(pyenv virtualenv-init -)"

saml_login() {
  saml2aws login --profile saml && \
  eval "$(saml2aws script --profile saml)" && \
  echo "✅ AWS environment loaded with profile 'saml'"
}

export GOPATH="${GOPATH:-$HOME/go}"
export PATH="$PATH:$GOPATH/bin"

# Added by Antigravity
export PATH="/Users/mrtrom/.antigravity/antigravity/bin:$PATH"

# Ensure /usr/local/bin is prioritized for AWS CLI v2
export PATH="/usr/local/bin:$PATH"

# Remove duplicate PATH entries
typeset -U PATH path

# Zoxide — must be initialized last
export _ZO_DOCTOR=0
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
