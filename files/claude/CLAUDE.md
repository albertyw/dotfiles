# Global CLAUDE.md

## User

Albert Wang (albertyw). Full-stack developer working primarily in Go, Python, and JavaScript/TypeScript.

## Overall Preferences

### Editor & Shell
- **Editor**: Neovim
- **Shell**: Bash (primary), Zsh available
- Do not read `.env` or `.env.*` files.

### Git
- Default branch: master
- Always rebase when pulling (no merge commits)
- SSH for GitHub URLs
- NEVER run `git push` — notify me when commits are ready for review and pushing
- Commit messages should be concise
- All tests, lints, and type checks must pass before committing.
- Do a short code review for correctness, simplicity, and security before committing.
- Ask for explicit permission before committing.  When asking for permission, describe changes and show me a list of all files to commit.
- Do not publish passwords, API keys, and tokens to git or to package managers.

### Code Style
- Keep changes minimal and focused
- Prefer simple, direct solutions
- Tests should accompany new functionality.  Aim for 100% test coverage.
- Tests should avoid modifying files or making network calls.
- Make extensive use of ASCII diagrams for explaining concepts, code flow, and architecture. Include diagrams in proposed plans.
- Prefer self-documenting code over excessive comments.

### Tools
- Do not use sed to edit files.  Do not use output redirection to write files except to the /tmp directory
- Use `git grep` instead of `grep` when searching version-controlled files

## Personal (Linux / Ubuntu / WSL)

- **OS**: Linux (Ubuntu), possibly under WSL
- **Python**: Managed via pyenv
- **Node**: Managed via nvm, prefers pnpm
- **Go**: GOPATH at ~/gocode
- **Git email**: git@albertyw.com

### Go
- Uses golangci-lint for linting, go vet for analysis
- Uses Makefiles for build/test/lint commands

### Python
- Django for web backends, Flask for smaller projects
- Flask projects should be based on the http://github.com/albertyw/base-flask template
- ruff for linting and formatting
- mypy for type checking (strict)
- coverage.py for code coverage

### JavaScript/TypeScript
- Prefer TypeScript for nontrivial projects or projects that already use it
- pnpm as package manager, use `npm run` / `pnpm run` commands
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
