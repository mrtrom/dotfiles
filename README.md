# dotfiles

Personal macOS dotfiles for [@mrtrom](https://github.com/mrtrom), managed with [yadm](https://yadm.io).

---

## Fresh Mac Setup

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install yadm
brew install yadm

# 3. Clone dotfiles
yadm clone git@github.com:mrtrom/dotfiles.git

# 4. Install all tools
bash ~/bootstrap.sh

# 5. Apply macOS system defaults
bash ~/macos.sh
```

After that, follow the manual steps printed at the end of `bootstrap.sh`.

---

## Manual Post-Install Steps

| Step | Command |
|------|---------|
| SSH keys | Copy `~/.ssh/id_rsa` from secure storage, then `chmod 600 ~/.ssh/id_rsa` |
| GitHub auth | `gh auth login` |
| AWS SSO | `aws configure sso` |
| AWS SAML | `saml2aws configure` |
| GPG signing | `gpg --import <your-key.gpg>` |
| granted browser | `granted browser set -b chrome --path "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary"` |
| Atuin sync | `atuin register` (optional, for cross-machine history sync) |
| Restart terminal | To apply all shell changes |

---

## Managing Dotfiles with yadm

yadm is a git wrapper — all standard git commands work, just prefixed with `yadm`.

### Day-to-day workflow

```bash
# Check what's changed
yadm status

# Stage a file
yadm add ~/.zshrc

# Commit
yadm commit -m "feat: update zshrc"

# Push to GitHub
yadm push

# Pull latest from another machine
yadm pull
```

### Adding a new dotfile

```bash
yadm add ~/.config/sometool/config
yadm commit -m "feat: track sometool config"
yadm push
```

### Syncing to a new machine

```bash
# After cloning with yadm clone, pull latest
yadm pull

# Check for any conflicts
yadm status
```

### Viewing history

```bash
yadm log --oneline
yadm diff HEAD~1
```

---

## What's Included

| File/Dir | Purpose |
|----------|---------|
| `.zshrc` | Main ZSH config, sources all shell modules |
| `.zprofile` | Login shell PATH (pipx, SnowSQL, Obsidian) |
| `.zshenv` | Always-sourced env (Cargo, assume alias, console function) |
| `.shell/.exports` | Environment variables (PNPM, Deno, Go, Java, etc.) |
| `.shell/.zaliases.sh` | All aliases |
| `.shell/.functions` | Shell functions (magic-enter, yazi, completion cache) |
| `.shell/.external` | Tool initialization (Homebrew, FNM, rbenv, Starship, direnv, navi, autosuggestions) |
| `.shell/.completions` | Zsh completion styling (zstyle settings, menu select, caching) |
| `.gitconfig` | Git config with delta pager, SSH signing, aliases |
| `.config/git/worktree-init` | Script to copy untracked files into a new worktree |
| `.config/lazygit/config.yml` | lazygit config: worktrees, PRs, Claude Code commits |
| `.config/starship.toml` | Starship prompt (Dracula theme, time, AWS, git, node, python) |
| `.config/ghostty/config` | Ghostty terminal (Dracula, Hack Nerd Font, shell integration) |
| `.config/atuin/config.toml` | Atuin shell history (compact, secrets filter, sync v2) |
| `.config/bat/config` | bat theme (Dracula) |
| `.config/eza/theme.yml` | eza file listing theme |
| `.local/share/navi/cheats/personal.cheat` | Personal navi snippets |
| `.local/share/navi/cheats/deckard.cheat` | Deckard work navi snippets |
| `.ssh/config` | SSH host config |
| `.aws/config` | AWS profiles (Deckardtech SSO + NewsCorp Okta) |
| `bootstrap.sh` | Fresh Mac install script |
| `macos.sh` | macOS system defaults |
| `Library/LaunchAgents/com.treadie.port-kill.plist` | port-kill status bar auto-start |

---

## Shell Features

### Magic Enter
Pressing **Enter on a blank prompt** auto-runs:
- `git status --short` — when inside a git repo
- `eza -la` — everywhere else

### Ghost Text Suggestions
**zsh-autosuggestions** shows history-based suggestions as you type:
- `→` — accept full suggestion
- `Ctrl-F` — accept one word at a time

Commands are colored **green** (valid) or **red** (not found) via **zsh-syntax-highlighting**.

### Completion Menu
Tab completion is powered by **carapace** (1000+ tools with descriptions) with:
- Interactive highlighted menu (`Tab` to navigate, `Enter` to select)
- Grouped by category with yellow headers
- Case-insensitive fuzzy matching
- Cached completions for slow tools (aws, gh, kubectl)

### Snippet Runner (navi)
Press `Ctrl-G` to open a searchable menu of saved command snippets.

Cheat files:
- `~/.local/share/navi/cheats/personal.cheat` — personal scripts
- `~/.local/share/navi/cheats/deckard.cheat` — Deckard work commands

To add a new snippet, append to the relevant `.cheat` file:
```
% category, tags

# Description shown in search
your command here
```

### Shell History (atuin)
`Ctrl-R` opens atuin's searchable history UI:
- Stored in a local SQLite DB (`~/.local/share/atuin/history.db`)
- Secrets filter auto-excludes AWS keys, tokens, etc.
- Optional encrypted sync across machines: `atuin register` + `atuin sync`

### Key Aliases

**Navigation**
| Alias | Command | Description |
|-------|---------|-------------|
| `cd` | `z` | Zoxide smart jump (frecency-based) |
| `cdi` | `zi` | Zoxide interactive selection |
| `y` | yazi shell fn | File manager, `cd`s to dir on quit |

**Listing**
| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | Colorized listing with icons |
| `ll` | `eza --icons -la` | Long format with hidden files |
| `lt` | `eza --icons --tree --level=2` | Directory tree |
| `cat` | `bat` | Syntax-highlighted file viewer |

**Git**
| Alias | Description |
|-------|-------------|
| `gs` / `gss` | `git status` / short status |
| `ga` / `gaa` | `git add` / `git add .` |
| `gc` / `gcm` | `git commit` / with message |
| `gd` / `gda` | `git diff` / diff HEAD |
| `glg` | Graph log (oneline + decorations) |
| `gp` / `gpu` | Push / push with upstream |
| `lg` | lazygit TUI |

**AWS / granted**
| Alias/Function | Description |
|----------------|-------------|
| `assume <profile>` | Switch AWS profile in current shell |
| `console <profile>` | Open AWS console in new Chrome Canary tab |

**Dev**
| Alias | Description |
|-------|-------------|
| `find` | `fd` — fast, modern find |

### lazygit Worktree Workflow

Press `W` from anywhere in lazygit to open the worktree menu:

| Key | Action |
|-----|--------|
| `W n` | New worktree + new branch from HEAD |
| `W e` | New worktree from an existing branch |
| `W l` | List all worktrees |
| `W p` | Prune stale worktree entries |

In the **Branches** panel, `N` creates a new worktree branching off the selected branch.
In the **Worktrees** panel, `D` force-removes the selected worktree.

All creation commands automatically run `~/.config/git/worktree-init` to copy untracked files (`.envrc`, `.env*`, `node_modules`, `.python-version`, `.venv`, `.direnv`) into the new worktree.

**Per-project overrides:** create a `.worktree-copy` file at the repo root with one path per line to replace the default copy list for that project.

---

## Tools Overview

| Tool | Purpose |
|------|---------|
| [yadm](https://yadm.io) | Dotfiles manager (git wrapper for `$HOME`) |
| [starship](https://starship.rs) | Shell prompt (Dracula theme, time, AWS, git modules) |
| [ghostty](https://ghostty.org) | Terminal emulator (Dracula, Hack Nerd Font, shell integration) |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` with frecency |
| [eza](https://github.com/eza-community/eza) | Modern `ls` replacement |
| [bat](https://github.com/sharkdp/bat) | Syntax-highlighted `cat` (Dracula theme) |
| [fd](https://github.com/sharkdp/fd) | Fast `find` replacement |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast `grep` replacement |
| [git-delta](https://github.com/dandavison/delta) | Syntax-highlighted git diffs |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal git UI |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager |
| [atuin](https://atuin.sh) | Shell history (SQLite, secrets filter, optional sync) |
| [carapace](https://carapace-sh.github.io/carapace-bin) | Multi-shell completions for 1000+ tools |
| [navi](https://github.com/denisidoro/navi) | Interactive command snippet runner (`Ctrl-G`) |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | History-based ghost text suggestions |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Real-time command coloring |
| [granted](https://docs.commonfate.io/granted) | AWS profile switcher + console opener |
| [direnv](https://direnv.net) | Per-directory env vars |
| [fnm](https://github.com/Schniz/fnm) | Fast Node version manager (globals via `pnpm add -g`) |
| [gh](https://cli.github.com) | GitHub CLI |
| [port-kill](https://github.com/treadiehq/port-kill) | macOS status bar port manager (auto-starts via LaunchAgent) |

---

## AWS Profiles

Profiles are split into two identity groups in `~/.aws/config`:

**Deckardtech SSO** — `assume <profile>` triggers SSO login if needed (8h sessions):
`dev` · `development-tools` · `uat` · `demo` · `staging` · `production` · `production-ro` · `production-securedocs` · `production-securedocs-ro` · `production-tools` · `production-tools-ro` · `bastion` · `playground`

**NewsCorp (Okta/SAML)** — credentials via `saml2aws`:
`nchqprod*` · `nchqstag*` · `nchqnonprod*` · `nct-admin` · `nna-nchq-*` and others
