#!/usr/bin/env bash
# macos.sh — idempotent macOS system defaults for mrtrom
# Run: bash macos.sh
# Note: some changes require a logout/restart to fully take effect.
set -euo pipefail

info()    { printf "\033[0;34m▶ %s\033[0m\n" "$*"; }
success() { printf "\033[0;32m✔ %s\033[0m\n" "$*"; }

# ── Close System Preferences to avoid overwrite conflicts ────────────────────
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

# ── Finder ───────────────────────────────────────────────────────────────────
info "Configuring Finder..."

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show path bar at bottom
defaults write com.apple.finder ShowPathbar -bool true
# Show status bar at bottom
defaults write com.apple.finder ShowStatusBar -bool true
# Show full POSIX path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Search current folder by default (not whole Mac)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Default view: list (Nlsv), alternatives: icnv, clmv, glyv
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false
# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

success "Finder configured"

# ── Keyboard ─────────────────────────────────────────────────────────────────
info "Configuring keyboard..."

# Disable press-and-hold (enables key repeat)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Fast key repeat rate (lower = faster, minimum is 1)
defaults write NSGlobalDomain KeyRepeat -int 2
# Shorter delay before repeat kicks in
defaults write NSGlobalDomain InitialKeyRepeat -int 15

success "Keyboard configured"

# ── Autocorrect — disable all (dev-hostile) ──────────────────────────────────
info "Disabling autocorrect..."

defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

success "Autocorrect disabled"

# ── Screenshots ──────────────────────────────────────────────────────────────
info "Configuring screenshots..."

# Save screenshots to ~/Desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
# Save as PNG
defaults write com.apple.screencapture type -string "png"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

success "Screenshots configured"

# ── Dock ─────────────────────────────────────────────────────────────────────
info "Configuring Dock..."

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true
# Remove the auto-hide delay
defaults write com.apple.dock autohide-delay -float 0
# Faster auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.4
# Tile size
defaults write com.apple.dock tilesize -int 47
# Don't show recent apps
defaults write com.apple.dock show-recents -bool false
# Scale minimize effect (faster than genie)
defaults write com.apple.dock mineffect -string "scale"
# Disable launch animation bounce
defaults write com.apple.dock launchanim -bool false
# Don't rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

success "Dock configured"

# ── Trackpad ─────────────────────────────────────────────────────────────────
info "Configuring trackpad..."

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# Natural scrolling (keep on)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

success "Trackpad configured"

# ── Activity Monitor ─────────────────────────────────────────────────────────
info "Configuring Activity Monitor..."

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0
# Sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

success "Activity Monitor configured"

# ── TextEdit ─────────────────────────────────────────────────────────────────
info "Configuring TextEdit..."

# Use plain text by default
defaults write com.apple.TextEdit RichText -int 0
# Open files as UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

success "TextEdit configured"

# ── Restart affected apps ────────────────────────────────────────────────────
info "Restarting affected apps..."

for app in "Finder" "Dock" "SystemUIServer" "Activity Monitor"; do
  killall "$app" &>/dev/null || true
done

echo ""
success "macOS defaults applied!"
echo ""
echo "  Note: Some changes (keyboard, trackpad) require a logout to fully take effect."
