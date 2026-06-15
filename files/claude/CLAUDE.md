# Global CLAUDE.md

## User

Albert Wang (albertyw). Full-stack developer working primarily in Go, Python, and JavaScript/TypeScript.

## Overall Preferences

### Editor & Shell
- **Editor**: Neovim
- **Shell**: Bash (primary), Zsh available
- Do not read `.env` or `.env.*` files.
- Use `jq` instead of `python` to parse json

### Git
- Default branch: master
- SSH for GitHub URLs
- NEVER run `git push` — notify me when commits are ready for review and pushing
- Never use `git -C` (working directory) or `git -c` (config override) flags — the shell is already in the correct directory and config is already set
- Commit messages should be a single concise line.  They should explain the meaning of the commit rather than the mechanics.  No multi-line body unless explicitly requested.
- All tests, lints, and type checks must pass before committing.
- Do a short code review for correctness, simplicity, and security before committing.
- Ask for explicit permission before committing, unless a plan with specific commits has already been approved.  When asking for permission, describe changes and show me a list of all files to commit.
- Do not publish passwords, API keys, and tokens to git or to package managers.

### Workflow
- When doing complex work, split into multiple git commits.  Do not make single catch-all git commits.
- When there are multiple git commits on a related subject, use a separate branch.  Do not commit directly to the default branch.
- Avoid catch-all fixit commits.  If fixes are for commits that have not been pushed to remote, use fixup commits and interactive rebase to fold them into the original commits.
- After completing each step of a multi-step plan, pause to self-review and present a summary.  Wait for explicit user approval before proceeding to the next step.
- Write working documents — specs, implementation plans, and TODO/status tracking markdown — under a `claude/` directory at the repository root.  Check off TODO items as they are completed.
- Keep the `claude/` directory out of version control by adding a line `claude/` to the repository's `.git/info/exclude` (NOT `.gitignore`, which is itself committed and shared with the team).  Never commit the `claude/` directory or its contents.

### Code Style
- Always use LF (Unix) line endings, never CRLF. When writing files with Python's csv module, set `lineterminator='\n'` explicitly.
- Keep changes minimal and focused
- Prefer simple, direct solutions
- Tests should accompany new functionality.  Aim for 100% test coverage.
- Tests should avoid modifying files or making network calls.
- Make extensive use of ASCII diagrams for explaining concepts, code flow, and architecture. Include diagrams in proposed plans.
- Prefer self-documenting code over excessive comments.

### Tools
- Do not use sed to edit files.  Do not use output redirection (>, >>) to write files except to /tmp.
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
- Uses golangci-lint for linting, go vet for analysis
- Uses Makefiles for build/test/lint commands
- Follow [Uber's Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md)
- Ensure imports are always goimported (sorted alphabetically) and grouped by stdlib and non-stdlib

### Python
- Django for web backends, Flask for smaller projects
- Flask projects should be based on the http://github.com/albertyw/base-flask template
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
- Jest, Mocha for testing

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
- When creating a pull request, always enable auto-merge.
