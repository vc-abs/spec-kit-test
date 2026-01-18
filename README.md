# spec-kit-test

A scaffold to help with kick-starting AIFSD projects or to convert existing projects into one.

## Approach

This project / repo is meant to provide the scaffolding for AIFSD. New projects could use this to setup their base repos by prompting. With existing projects, the idea is to merging this repo without overriding.

## Supported Tools

This scaffold is **optimized for GitHub Copilot** integration. Prompts, agents, and workflows are designed specifically for Copilot's capabilities and context model.

- **Supported:** GitHub Copilot (Chat, CLI, Editor integration)
- **Not supported:** Cursor, OpenAI configuration

*Focus: Copilot-first development to avoid scope creep and maintain consistent tooling.*

## Phased Implementation Pattern

For large implementations creating 10+ files, this project uses a **phased checkpoint approach** to ensure reviewable, committable increments:

- **Pattern**: Break work into 3-8 file phases with interactive approval gates
- **Session Persistence**: Phase plans survive Copilot session restarts
- **Documentation**: See [.github/patterns/phased-implementation.md](.github/patterns/phased-implementation.md)
- **Example**: See [.github/examples/phase-plan-example.md](.github/examples/phase-plan-example.md)

This prevents massive 20+ file commits and enables incremental validation and rollback safety.

## Features

### GenAI Asset Generation System

An AI-powered system for generating and managing visual assets using entity-based templates and version control.

**Directory Structure:**

```text
content/
  entities/
    characters/      # Character entity definitions
    styles/          # Art style templates
    environments/    # Scene environment settings
    scenes/          # Composed scene descriptions
    meta-prompts/    # Reusable prompt components
```

**Status:** In development (Phase 1/9 complete)

**Documentation:**

- Specification: [specs/001-genai-asset-system/spec.md](specs/001-genai-asset-system/spec.md)
- Technical Plan: [specs/001-genai-asset-system/plan.md](specs/001-genai-asset-system/plan.md)
- Implementation Tasks: [specs/001-genai-asset-system/tasks.md](specs/001-genai-asset-system/tasks.md)
