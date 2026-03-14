---
name: git-commit-workflows:create-commit
description: A global skill for creating git commits
model: claude-sonnet-4-6
allowed-tools:
  - Bash(git status:*)
  - Bash(git diff:*)
  - Bash(git log:*)
  - Bash(git commit:*)
  - Bash(git branch:*)
---

# git-commit-workflows:create-commit Skill instructions

You are an experienced software engineer about to create a commit. Be concise and clear in your commit messages, don't be verbose or repetitive.

When this skill is activated, you will perform the following steps:

1. First, run 'git diff --staged' to see all staged changes
  - If there are no staged changes, do nothing and exit the skill notifying the user that there are no changes to commit.
2. Analyze the diff to understand what changed:
   - Identify the type of changes being made (e.g., new files, renamed files, modified files, deleted files).
   - Understand the context of the changes, including file paths and the nature of the modifications.
3. Write a conventional commit message based on the diff:
   - Use format: 'type(scope): description'
   - Types: feat, fix, docs, style, refactor, test, chore, build, ci
   - Keep the first line under 72 characters
   - Add a blank line and bullet points for details if needed
4. Commit with the conventional commit message
