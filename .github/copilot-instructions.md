---
name: copilot-instructions
---

# GitHub Copilot Instructions

## ⛔ Tool Policy

**Git Operations — Terminal Only:**
- Use `run_in_terminal` for all git commands
- **DO NOT** use MCP git tools (GitKraken, etc.)
- Rationale: Terminal commands ensure consistent behavior and avoid interactive UI dialogs

**Prohibited:**
- ❌ **NO auto-commit** — Only commit when user explicitly invokes `/commit`
- ❌ **NO auto-push** — Never execute `git push`
- ❌ **NO arbitrary commands** — Only allowlisted commands (see below)
- ❌ **NO API access** — Do not call external APIs, cloud providers, or networked services without explicit user consent
- ❌ **NO operations beyond branch** — Stay scoped to current branch and working tree; no branch creation/deletion, force-pushes, or remote changes

**Allowlisted Commands:**
```bash
git status              # Check working tree state (auto-allowed)
git diff                # Review changes (auto-allowed)
git log                 # View history (auto-allowed)
git add .               # Stage changes (only after user invokes /commit)
git commit -m "<msg>"   # Commit (only after explicit /commit)
```

**Required Behaviors:**
- ✅ **Report summary** — Present a concise summary of proposed changes before impactful actions
- ✅ **Warnings and escalation** — When detecting destructive or sensitive changes (deleting files, upgrading dependencies, touching infra), warn and require explicit approval
- ✅ **Safe operations** — Analysis, dry-run, and informational operations may auto-execute

## File Naming Conventions
- Use **kebab-case** for files (e.g., `read-me.md`, `user-service.js`).
- Use **SCREAMING_SNAKE_CASE** for constants (e.g., `MAX_RETRIES`, `API_TIMEOUT`).
- **Prompts:** Named like functions using imperative verbs (e.g., `generate-report`, `create-document`, `refine`).
- **Instructions:** Similar to prompts but use present-continuous tense (e.g., `generating-report`, `creating-document`, `refining`).
- **Agents:** Use nouns as names (e.g., `report-generator`, `document-creator`, `refiner`).

## Code Style
- Follow `.editorconfig` settings for formatting.
- **Indentation:** 2 spaces for YAML files; tabs for other files and shell scripts.
- **Line endings:** LF (Unix-style).
- **Encoding:** UTF-8 for all files.
- **Trailing whitespace:** Remove all trailing whitespace.
- **Final newline:** Always include a newline at end of file.

## Documentation Standards
- Keep documentation in sync with code changes.
- Use clear, concise language in comments.

## Architecture Principles
- Follow separation of concerns (SoC).
- Keep dependencies minimal and well-documented.
- Use interfaces/types for public APIs.
- Organize code/instructions by feature or functional domain.
- Avoid deep nesting; keep functions readable.

## Development Guidelines
- Do not use sensitive paths like users home directory in files.
- Prefer automation scripts over markdown instructions to the user. The idea is to allow for better developer experience.

