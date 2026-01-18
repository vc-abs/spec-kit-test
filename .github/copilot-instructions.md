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
  - **CRITICAL**: Do NOT execute `git commit` unless the user types `/commit` or explicitly says "commit this" or "commit now"
- ❌ **NO auto-push** — Never execute `git push`
- ❌ **NO arbitrary commands** — Only allowlisted commands (see below)
- ❌ **NO API access** — Do not call external APIs, cloud providers, or networked services without explicit user consent
- ❌ **NO operations beyond branch** — Stay scoped to current branch and working tree; no branch creation/deletion, force-pushes, or remote changes

**Allowlisted Commands:**
```bash
git status              # Check working tree state (auto-allowed)
git diff                # Review changes (auto-allowed)
git log                 # View history (auto-allowed)
git add .               # Stage changes (ONLY after user invokes /commit)
git commit -m "<msg>"   # Commit (ONLY after explicit /commit invocation)
git reset               # Undo operations (allowed when fixing mistakes)
```

**Required Behaviors:**
- ✅ **Report summary** — Present a concise summary of proposed changes before impactful actions
- ✅ **Warnings and escalation** — When detecting destructive or sensitive changes (deleting files, upgrading dependencies, touching infra), warn and require explicit approval
- ✅ **Safe operations** — Analysis, dry-run, and informational operations may auto-execute

## Phased Implementation Pattern

**CRITICAL**: For implementations creating 10+ files, use phased checkpoints instead of single massive commits.

**Pattern**:
1. **Create phase plan file**: `phase-plan-[NN].md` specifying:
   - Files to create/modify (3-8 per phase)
   - Required user inputs (decisions, parameters)
   - Validation steps
   - Commit message template
2. **Wait for user approval**: User reviews plan, provides inputs, says "continue"
3. **Execute phase**: Create exactly the files listed
4. **User commits**: User reviews and commits the phase
5. **Next phase**: Create next phase plan and repeat

**Phase Sizing**:
- **Ideal**: 3-8 files, 300-800 lines per phase
- **Boundaries**: Architectural layers, functional milestones, testable units
- **Avoid**: 15+ files (too large) or 1-2 files (too granular)

**Session Persistence**: Phase plans are markdown files in repo, so they survive session restarts. User can say "continue with phase-plan-03.md" to resume.

**Reference**: See `.github/patterns/phased-implementation.md` for full workflow details and examples.

**When to Use**:
- ✅ `/speckit.implement` with 15+ tasks
- ✅ Large feature implementation (multi-file components)
- ✅ System setup with multiple configuration files
- ❌ Single file edits or small fixes
- ❌ Exploratory analysis or read-only operations

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

