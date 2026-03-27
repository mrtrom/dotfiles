#!/usr/bin/env bash
# bootstrap.sh — fresh Mac setup for mrtrom's dotfiles
# Usage: bash bootstrap.sh
set -euo pipefail

DOTFILES_REPO="git@github.com:mrtrom/dotfiles.git"

# ── Helpers ──────────────────────────────────────────────────────────────────
info()    { printf "\033[0;34m▶ %s\033[0m\n" "$*"; }
success() { printf "\033[0;32m✔ %s\033[0m\n" "$*"; }
warn()    { printf "\033[0;33m⚠ %s\033[0m\n" "$*"; }

# ── 1. Homebrew ───────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  success "Homebrew already installed"
fi

brew update --quiet

# ── 2. yadm + dotfiles ────────────────────────────────────────────────────────
if ! command -v yadm &>/dev/null; then
  info "Installing yadm..."
  brew install yadm
fi

if [ ! -d "$HOME/.local/share/yadm/repo.git" ]; then
  info "Cloning dotfiles via yadm..."
  yadm clone "$DOTFILES_REPO"
else
  success "yadm repo already initialized"
fi

# ── 3. Shell & terminal ───────────────────────────────────────────────────────
info "Installing shell & terminal tools..."
brew install \
  zsh \
  starship \
  eza \
  fzf \
  zoxide \
  bat \
  fd \
  ripgrep \
  carapace \
  atuin \
  direnv \
  htop \
  hyperfine \
  glow \
  duf \
  git-delta \
  lazygit \
  lazydocker \
  terminal-notifier

# ── 4. Git & GitHub ───────────────────────────────────────────────────────────
info "Installing git tools..."
brew install \
  git \
  gh \
  git-lfs \
  gnupg \
  pinentry-mac

git lfs install --skip-smudge

# ── 5. Language runtimes & version managers ───────────────────────────────────
info "Installing language runtimes..."
brew install \
  fnm \
  rbenv \
  ruby-build \
  pyenv \
  go \
  rustup \
  openjdk

# Node LTS via fnm
if command -v fnm &>/dev/null; then
  eval "$(fnm env)"
  fnm install --lts
  fnm default lts-latest
fi

# Rust stable
if command -v rustup &>/dev/null; then
  rustup-init -y --no-modify-path
fi

# Bun
if ! command -v bun &>/dev/null; then
  curl -fsSL https://bun.sh/install | bash
fi

# ── 6. Package managers ───────────────────────────────────────────────────────
info "Installing package managers..."
brew install pnpm yarn

# ── 7. Cloud & DevOps ────────────────────────────────────────────────────────
info "Installing cloud & DevOps tools..."
brew install \
  awscli \
  aws-sam-cli \
  aws-iam-authenticator \
  saml2aws \
  granted \
  tfenv \
  pulumi \
  argocd \
  flyctl

# ── 8. Dev utilities ─────────────────────────────────────────────────────────
info "Installing dev utilities..."
brew install \
  jq \
  yq \
  just \
  make \
  wget \
  mkcert \
  shellcheck \
  biome \
  opencode \
  stripe \
  localstack-cli \
  yazi

# ── 9. Casks ─────────────────────────────────────────────────────────────────
info "Installing casks..."
brew install --cask \
  font-hack-nerd-font \
  google-cloud-sdk \
  session-manager-plugin \
  snowflake-snowsql \
  stats \
  zulu@17 \
  ngrok \
  claude-code

# ── 10. macOS defaults ────────────────────────────────────────────────────────
if [ -f "$HOME/macos.sh" ]; then
  info "Applying macOS defaults..."
  bash "$HOME/macos.sh"
fi

# ── 11. Manual steps ─────────────────────────────────────────────────────────
echo ""
warn "Manual steps required:"
cat <<'EOF'
  1. SSH keys:
       - Copy ~/.ssh/id_rsa (private key) from secure storage
       - Run: chmod 600 ~/.ssh/id_rsa

  2. Git credentials:
       - Run: gh auth login
       - Git will prompt for keychain on first push

  3. AWS:
       - Run: aws configure sso  (or copy ~/.aws/ from backup)
       - Run: saml2aws configure

  4. GPG / commit signing:
       - Run: gpg --import <your-key.gpg>
       - Run: gpg --list-secret-keys

  5. granted browser:
       - Run: granted browser set -b chrome --path "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary"

  6. Restart terminal to apply all shell changes.
EOF

success "Bootstrap complete!"
