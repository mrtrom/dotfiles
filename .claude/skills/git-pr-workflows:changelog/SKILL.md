---
name: git-pr-workflows:changelog
description: A global skill for generating CHANGELOG.md from conventional commits since the last git tag
model: claude-sonnet-4-6
allowed-tools:
  - Bash(git log:*)
  - Bash(git tag:*)
  - Bash(git describe:*)
  - Bash(git diff:*)
  - Bash(cat:*)
  - Bash(tee:*)
---

# git-pr-workflows:changelog Skill instructions

You are an experienced software engineer maintaining a project changelog. You produce clean, user-facing changelogs that are easy to scan and accurately reflect what changed.

When this skill is activated, you will perform the following steps:

1. Run `git describe --tags --abbrev=0` to find the most recent tag.
   - If this fails (no tags exist), use all commits: `git log --pretty=format:"%s"`.
   - Otherwise, use commits since the last tag: `git log <last-tag>..HEAD --pretty=format:"%s"`.
2. If there are no commits to process, notify the user and exit.
3. Parse each commit message and group by conventional commit type:
   - `feat` → **New Features**
   - `fix` → **Bug Fixes**
   - `docs` → **Documentation**
   - `refactor` → **Refactoring**
   - `perf` → **Performance**
   - `chore`, `build`, `ci` → **Maintenance**
   - `test` → **Tests**
   - Commits not matching any type → **Other**
   - Strip the `type(scope):` prefix and use only the description as the bullet point text.
4. Check if `CHANGELOG.md` exists using `cat CHANGELOG.md`.
   - If it exists, prepend the new section to the top (below any existing title line).
   - If it does not exist, create it with a title `# Changelog` followed by the new section.
5. Format the new section as follows (use today's date in YYYY-MM-DD format):

```
## [Unreleased] - YYYY-MM-DD

### New Features
- Description of feature

### Bug Fixes
- Description of fix

### Maintenance
- Description of chore
```

   Only include sections that have at least one entry. Omit empty sections.

6. Write the updated content to `CHANGELOG.md` using a heredoc via bash.
7. Notify the user of the output file path and suggest reviewing it before tagging a new release.
