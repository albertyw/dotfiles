# Global CLAUDE.md

## User

Albert Wang (albertyw). Full-stack developer working primarily in Go, Python, and JavaScript/TypeScript.

## Overall Preferences

### Editor & Shell
- **Editor**: Neovim
- Do not read `.env` or `.env.*` files.

### Git
- Default branch: master
- SSH for GitHub URLs
- Do not run `git push` nor any commands that will trigger `git push` without first allowing me to review.  I may give general authorization to trigger `git push` for bounded work.
- When finished making a requested change on a version-controlled file, git commit it once it passes the checks and review below.  Commit only the changes you made; if a file already had my uncommitted changes, ask first.
- Never use `git -C` (working directory) or `git -c` (config override) flags — the shell is already in the correct directory and config is already set
- Commit messages should be a single concise line.  They should explain the meaning of the commit rather than the mechanics.  No multi-line body unless explicitly requested.
- Never add a Claude session marker to commit messages or pull request bodies: no `Claude-Session:` trailer, no "Generated with Claude Code" line, no co-authored-by Claude.
- All tests, lints, and type checks must pass before committing.
- Do a short code review for correctness, simplicity, and security before committing.
- Do not publish passwords, API keys, and tokens to git or to package managers.
- Never perform release steps unless explicitly asked: no version bumps, no release commits, no `git tag`.  Changelog edits are fine when requested; the release itself is always mine to run.

### Workflow
- These instructions override plugin skills such as superpowers.  When a skill's steps conflict with this file, follow this file and keep the rest of the skill — for example, save specs and plans under `claude/` (not `docs/`) without committing them, and execute plans inline.
- When doing complex work, split it into focused commits, one per logical change.
- When there is ambiguity, ask me questions.
- Clearly call out open questions and decisions that need my input, in a separate labeled section rather than buried in prose.  I may answer only some at a time; keep raising the unanswered ones in later responses until I explicitly answer or dismiss each.  Number each point and provide context for answering those questions.
- When there are multiple git commits on a related subject, use a separate branch.  When making single commits in personal repos, commit directly on the default branch.
- Fold fixes for unpushed commits into the original commit with `git commit --fixup=<sha>` and `git rebase --autosquash`, instead of adding a separate fix commit.
- Do file edits and state changes inline in the current session, never through a subagent, and don't ask which execution mode to use; if you would only wait on a subagent's result, do the work yourself.
- Write working documents — specs, implementation plans, and TODO/status tracking markdown — under a `claude/` directory at the repository root.  Check off TODO items as they are completed.
- Working docs in `claude/` must stand alone for a session with no prior context — spell out background, not just task names.  Move completed plans to `claude/archive/` and prune finished items.
- Keep the `claude/` directory out of version control by adding a line `claude/` to the repository's `.git/info/exclude` (NOT `.gitignore`, which is itself committed and shared with the team).  Never commit the `claude/` directory or its contents.
- When using /loop, always run in the local session — never use cloud schedules.

### Code Style
- Always use LF (Unix) line endings, never CRLF. When writing files with Python's csv module, set `lineterminator='\n'` explicitly.
- Keep changes minimal and focused
- Prefer simple, direct solutions
- Tests should accompany new functionality.  Aim for 100% test coverage.
- Tests should avoid modifying files or making network calls.
- Use ASCII diagrams when explaining architecture, code flow, or multi-step processes.  Always include diagrams in proposed plans.
- Prefer self-documenting code over excessive comments.

### Tools
- Do not use sed to edit files.  Do not use output redirection (>, >>) to write files except to /tmp or the session scratchpad.
- Do not ssh to remote servers to execute write operations — editing files, restarting or recreating services, deploying, changing config — unless I confirm first.  Read-only inspection over ssh (logs, status, config contents) is fine without asking.  This does not apply to Uber work.
- Do not use the `gh` CLI.  Instead use the `github` MCP or curl to get data from github.
- Use `git grep` instead of `grep` when searching version-controlled files
- Use `git ls-files | grep` instead of `find` when searching version-controlled file names
- Prefer pre-approved shell commands over ones that require confirmation: use the Read/Edit/Write tools instead of shell commands that touch files; use `jq` for JSON parsing; use `awk` or `cut` instead of `python3 -c` for simple text processing.

## Personal (Linux / Ubuntu / WSL)

- **OS**: Linux (Ubuntu), possibly under WSL
- **Python**: Managed via pyenv
- **Node**: Managed via nvm, prefers pnpm
- **Go**: GOPATH at ~/gocode
- **Git email**: git@albertyw.com

### Go
- Uses golangci-lint for linting, go vet for analysis, `gofmt -l -s` for format checks, `govulncheck ./...` for vulns
- Uses Makefiles for build/test/lint commands
- Follow [Uber's Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md)
- Ensure imports are always goimported (sorted alphabetically) and grouped by stdlib and non-stdlib

### Python
- Django for web backends, Flask for smaller projects
- Flask projects should be based on the https://github.com/albertyw/base-flask template
- Use "python -m unittest" for testing, "./manage.py test" for Django projects
- ruff for linting and formatting
- mypy for type checking (strict)
- coverage.py for code coverage
- For unittest.mock.patch, prefer using "@patch" decorators instead of "with patch"
- Run Python CLI tools directly by name (e.g. `mypy`, `ruff`, `coverage`), never via `python -m <tool>`
- Uses direnv with a virtualenv at the `env/` directory; the virtualenv is always active, so CLI tools are available directly

### JavaScript/TypeScript
- Prefer TypeScript for nontrivial projects or projects that already use it
- pnpm as package manager, use `pnpm run` commands
- ESLint, StyleLint for linting
- Vitest (preferred) and Mocha for testing; c8 for coverage

## Personal (macOS)

- **OS**: macOS
- **Package manager**: Homebrew
- **Python**: Homebrew python + pyenv
- **Node**: Managed via nvm, prefers pnpm
- **Go**: Homebrew, GOPATH at ~/gocode
- **Git email**: git@albertyw.com

Same language tools as Personal Linux above.

## Work (Uber / macOS)

- **GOPATH**: ~/Uber/gocode
- **UBER_HOME**: ~/Uber
- **Git email**: albertyw@uber.com
- **Internal git hosts**: code.uber.internal, config.uber.internal
- Gazelle for Go build file generation
- Use the SourceGraph MCP for searching for code instead of `grep`
- When running `coverage` in the go-code repository, set the environment variable `NOHTML`
- Prefer GitHub pull requests for most code changes.  Use Phabricator diffs for trivial changes.
- Always follow instructions in /uber-dev:pr-create and /uber-dev:pr-update when creating and updating GitHub pull requests, or from /uber-dev:diff-create and /uber-dev:diff-update when creating and updating Phabricator diffs.  Never use `gh` or raw `git push` commands.
- When creating a pull request, always enable auto-merge.
- Never name a branch after a Jira/Linear issue key — the keys are opaque and hard to understand at a glance.  Name branches with a few descriptive words prefixed by the project or service being modified (e.g. `delivery-alerting-platform/drop-dslite`).  Link the issue in the commit message or PR body instead.  Prefix the pull request title with `[<project or service>]`.
- When a change spans several pull requests, reuse the same prefix across all of their branches so they group together.
- Always attach at least one Jira or Linear issue to each GitHub pull request or Phabricator diff.
- Every pull request or diff should have a short description following the pull request or diff template.  The description should be at most 5 sentences and summarize the change and any major design decisions.
