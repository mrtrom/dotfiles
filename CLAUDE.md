# CLAUDE.md

Context and conventions for this dotfiles environment.

---

## Identity

- **Name**: Alexander Ochoa
- **GitHub**: mrtrom
- **Git email**: ochoaseguralex@gmail.com

---

## Dotfiles

Managed with **yadm**, tracked at `git@github.com:mrtrom/dotfiles.git`.

Always use yadm commands — never plain git — when modifying dotfiles:

```sh
yadm add <file>
yadm commit -m "<message>"
yadm push
```

**Do not commit until explicitly asked.**

Commit messages follow conventional commits: `feat:`, `fix:`, `chore:`, `refactor:`, etc.

---

## Shell

- **Shell**: zsh
- **Prompt**: Starship (`~/.config/starship.toml`), Dracula palette
- **Source order** (from `~/.zshrc`):
  - `~/.shell/.completions`
  - `~/.shell/.zaliases.sh`
  - `~/.shell/.exports`
  - `~/.shell/.functions`
  - `~/.shell/.external` — tool inits (brew, fnm, rbenv lazy, starship, direnv, navi, zsh-autosuggestions, zsh-syntax-highlighting)

### Plugins (sourced in `.external`)

| Plugin | Purpose |
|--------|---------|
| `zsh-autosuggestions` | History-based ghost text, accept with `→` |
| `zsh-syntax-highlighting` | Dracula-themed live syntax coloring |
| `navi` | Cheatsheet widget (`Ctrl+G`) |
| `direnv` | Per-directory env vars |

### Runtime managers

| Tool | Manager |
|------|---------|
| Node | `fnm` (auto-switch on `cd`) |
| Ruby | `rbenv` (lazy-loaded for startup speed) |
| Python | `uv` |

### Node global packages

Global npm packages are scoped per Node version. Use **pnpm** (installed via brew) for CLI tools that should be available across all versions:

```sh
pnpm add -g <package>   # install
pnpm remove -g <package>  # uninstall
pnpm list -g            # list installed globals
```

Currently installed globals: `serverless`, `simvyn`

---

## Key Tools & Aliases

### File & navigation

| Alias | Expands to | Notes |
|-------|-----------|-------|
| `ls` | `eza --icons --group-directories-first` | |
| `ll` | `eza --icons --group-directories-first -la` | |
| `lt` | `eza --icons --tree --level=2` | |
| `cat` | `bat` | Syntax-highlighted |
| `find` | `fd` | |
| `cd` | `z` | Zoxide frecency jump |
| `cdi` | `zi` | Zoxide interactive (fzf) |
| `aliases` | `alias \| fzf` | Search all aliases |

### Git

| Alias | Command |
|-------|---------|
| `lg` | `lazygit` |
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` / `gcm` | `git commit` / `git commit --message` |
| `gp` / `gpu` | `git push` / `git push --set-upstream origin` |
| `gd` | `git diff` |
| `gb` | `git branch` |
| `gco` / `gcob` | `git checkout` / `git checkout -b` |
| `glg` | `git log --graph --oneline --decorate --all` |
| `gu` | `git up` |
| `grh` | `git reset --hard` |
| `gccb` | Copy current branch name to clipboard |

### Claude

| Alias | Profile |
|-------|---------|
| `claude-personal` | `~/.claude` |
| `claude-work` | `~/.claude-work` |

---

## Terminal

**Ghostty** (`~/.config/ghostty/config`)

- Font: Hack Nerd Font, size 14, thickened
- Background: 90% opacity, blur 20
- `macos-option-as-alt = true`
- `copy-on-select = true`
- `Cmd+Shift+←/→` — line selection

---

## Git Config (`~/.gitconfig`)

- **Editor**: `zed --wait`
- **Pager**: `delta` (side-by-side, line numbers, Dracula theme)
- **Signing**: SSH key (`~/.ssh/id_rsa.pub`)
- **Default branch**: `main`

### Delta (`~/.config/git/` or `.gitconfig [delta]`)

```
navigate = true
side-by-side = true
line-numbers = true
syntax-theme = Dracula
```

---

## Lazygit (`~/.config/lazygit/config.yml`)

Theme: Dracula. Key custom bindings:

| Key | Context | Action |
|-----|---------|--------|
| `U` | global | `git up` |
| `W` | global | Worktree operations menu |
| `G` | files | Generate commit with Claude Code |
| `b` | files | `git blame` with delta |
| `G` | commits/branches | Open PR in browser (gh) |
| `O` | commits | Open changed files in Cursor |
| `v` | branches | Checkout GitHub PR interactively |
| `Ctrl+G` | branches | Generate PR with Claude Code |
| `Ctrl+P` | branches/remotes | Prune gone/deleted branches |
| `M` | status | Open Ghostty in project dir |
| `O` | status | Open project in Cursor |

---

## Theme

**Dracula** everywhere — Ghostty, lazygit, fzf, zsh-syntax-highlighting, delta, Starship.

Core palette:
- Background: `#282a36`
- Foreground: `#f8f8f2`
- Green: `#50fa7b`
- Purple: `#bd93f9`
- Pink: `#ff79c6`
- Cyan: `#8be9fd`
- Orange: `#ffb86c`
- Red: `#ff5555`
- Yellow: `#f1fa8c`
- Comment: `#6272a4`
- Selection: `#44475a`

When adding theming to any new tool, use these values.

---

## skhd (`~/.config/skhd/skhdrc`)

Lightweight hotkey daemon — focuses app if running, launches if not. Runs as a launchd service (`skhd --start-service`).

| Shortcut | App |
|----------|-----|
| `Ctrl+T` | Ghostty |
| `Ctrl+K` | Cursor |
| `Ctrl+B` | Google Chrome |
| `Ctrl+S` | Slack |
| `Ctrl+E` | Spark Desktop (Beta) |
| `Ctrl+L` | Claude |
| `Ctrl+F` | Finder |

**Chrome profiles**: currently one profile (Personal = `Default`). When a work profile is added, use:
```sh
open -na "Google Chrome" --args --profile-directory="Profile 1"
```

**Service commands**:
```sh
skhd --start-service   # enable + start (runs on login)
skhd --stop-service    # stop
skhd --restart-service # reload after config changes
```

---

## Config Locations

| Tool | Path |
|------|------|
| Shell aliases | `~/.shell/.zaliases.sh` |
| Shell exports | `~/.shell/.exports` |
| Shell functions | `~/.shell/.functions` |
| Shell tool inits | `~/.shell/.external` |
| Ghostty | `~/.config/ghostty/config` |
| Starship | `~/.config/starship.toml` |
| Lazygit | `~/.config/lazygit/config.yml` |
| skhd | `~/.config/skhd/skhdrc` |
| Git global | `~/.gitconfig` |
| Git extras | `~/.config/git/` |
| bat | `~/.config/bat/` |
| eza | `~/.config/eza/` |
| yazi | `~/.config/yazi/` |
| atuin | `~/.config/atuin/` |
| Claude (personal) | `~/.claude/` |
| Claude (work) | `~/.claude-work/` |
