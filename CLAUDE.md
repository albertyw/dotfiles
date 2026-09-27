# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal Unix dotfiles, cloned to `~/.dotfiles` and synced across Linux (Ubuntu/WSL) and macOS machines, including Uber work machines.

## Checks

CI (`.drone.yml`) runs three lint steps and nothing else; there are no unit tests.

```shell
# Python
ruff check . --exclude files/vim,scripts/git/req-update --select E,F,W,A,B,COM,N,PLC,PLE,PLW

# Vim script (vint)
git ls-files | grep vim | grep -v sh.vim | grep -v pack | grep -v spell | xargs -n 1 vint

# Bash (shellcheck on every file with a bash shebang, "bash" in its name, or ".sh")
scripts/test_bash.sh
```

To check one file: `ruff check <file>`, `vint <file>`, or `shellcheck -e SC1090,SC1091 <file>` (completion files also ignore `SC2148,SC2048` because they are sourced, not executed).

## How it fits together

```
files/<name> ──symlink (scripts/link.sh)──> ~/.<name>
                                             │
~/.bash_profile ── runs in background ──> scripts/sync-dotfiles.sh
                                             (every ≤30 min: git pull, submodule update,
                                              files/claude/settings_merge.py)
~/.gitconfig ── core.hooksPath ──> files/git-hooks/
             └─ [alias] find/size/browse/... ──> scripts/git/*
~/.bashrc ── PATH += ~/.dotfiles/bin
          └─ sources ~/.bashrc_local
```

- **`files/`** holds everything that gets linked into `$HOME` with a leading dot (`files/bashrc` → `~/.bashrc`, `files/claude` → `~/.claude`). Adding a new dotfile means adding a `move <name>` line to `scripts/link.sh`.
- **Machine-specific overrides**: on hosts whose name contains `uber`, `link.sh` links `files/bashrc_uber` → `~/.bashrc_local` and `files/gitconfig_uber` → `~/.gitconfig_local`, which `bashrc` and `gitconfig` include last.
- **Setup**: `scripts/link.sh`, then `scripts/install_ubuntu.sh` or `scripts/install_macos.sh` (plus `scripts/link_macos.sh` on macOS).
- **Auto-sync consequences**: `sync-dotfiles.sh` only pulls when on `master` with a clean tree, so uncommitted work pauses syncing on that machine. Anything committed and pushed reaches every machine on its next login shell.
- **Submodules**: vim plugins under `files/vim/pack/albertyw/start/` and the `git-browse`, `git-reviewers`, and `req-update` tools under `scripts/git/` are git submodules; don't edit them here.
- **`bin/`** is standalone utility scripts on `PATH`.

## Git hooks (apply to every repo on the machine)

- `files/git-hooks/pre-commit` strips trailing whitespace and adds a final newline to staged files, then runs `git add` on each whole file. This breaks partial staging: any unstaged edits in a staged file get committed too. To split changes in one file across commits, change the working tree one step at a time instead of staging hunks.
- `files/git-hooks/pre-push` runs `scripts/github_contributions.py` when pushing to GitHub.

## Claude Code config

- `~/.claude/` is a symlink to `files/claude/`, so the two paths are the same files. Its `.gitignore` is default-deny (`*`) with an explicit whitelist: `CLAUDE.md`, `keybindings.json`, `settings_personal.json`, `settings_format.py`, `settings_merge.py`, `statusline-command.sh`, and the `agents/`, `commands/`, `hooks/`, `output-styles/`, and `skills/` directories. Everything else (credentials, `history.jsonl`, `projects/`, `sessions/`, `plugins/`, caches) stays local. To track something new there, whitelist it — a directory needs both `!dir/` and `!dir/**`.
- `~/.claude/settings.json` is deliberately not tracked: it is a machine-local merge target. Put global permissions and settings in `files/claude/settings_personal.json`, which `settings_merge.py` merges into it (lists unioned, dicts merged recursively, conflicting scalars prompt; local-only `autoMode`, `effortLevel`, and `model` are not reported as drift).
- `files/claude/CLAUDE.md` is the global instructions file loaded in every project; this file is only for this repo.
