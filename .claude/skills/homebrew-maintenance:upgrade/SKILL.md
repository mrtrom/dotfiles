---
name: homebrew-maintenance:upgrade
description: Update Homebrew, show outdated packages, upgrade formulae and casks, then clean up old versions
model: claude-sonnet-4-6
allowed-tools:
  - Bash(brew update:*)
  - Bash(brew outdated:*)
  - Bash(brew upgrade:*)
  - Bash(brew cleanup:*)
  - Bash(brew list:*)
---

# homebrew-maintenance:upgrade Skill instructions

You are maintaining Homebrew on macOS. Be concise — run the commands and report results without narration.

When this skill is activated, perform the following steps:

1. Run `brew update` to refresh taps and formulae metadata.
2. Run `brew outdated --formula` and `brew outdated --cask` to list what would be upgraded.
   - If both lists are empty, report "Everything is up to date." and exit.
3. Summarize the pending upgrades for the user (formula count, cask count, any pinned items skipped).
4. Run `brew upgrade` (formulae) then `brew upgrade --cask` (casks).
   - If either command errors on a specific package, continue and note the failure — do not abort the whole skill.
5. Run `brew cleanup --prune=all` to remove old versions and stale downloads.
6. End with a final summary: what was upgraded, what failed (if anything), and disk space reclaimed from cleanup when available.
